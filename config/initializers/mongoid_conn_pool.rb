# From https://gist.github.com/cpuguy83/5945217

require 'thread'
require 'thread_safe'
require 'monitor'

module Mongoid
  def with_session(&block)
    Sessions.with_session(&block)
  end
  module Config
    option :session_pool_size, :default        => 25
    option :session_checkout_timeout, :default => 2
    option :session_reap_frequency, :default   => 10
  end

  module Sessions
    class << self
      def synchronize(&block)
        @lock ||= Mutex.new
        @lock.synchronize(&block)
      end

      def session_pool(name=:default)
        synchronize do
          @session_pool ||= {}
          @session_pool[name] ||= Pool.new(
            :size             => Config.session_pool_size,
            :name             => name,
            :checkout_timeout => Config.session_checkout_timeout,
            :reap_frequency   => Config.session_reap_frequency)
        end
      end

      def disconnect
        synchronize do
          session_pool.each {|s| s.disconnect}
          @session_pool = nil
        end
      end

      def with_name(name)
        session_pool(name).session_for_thread(Thread.current) ||
          session_pool(name).checkout
      end

      def with_session(name=:default)
        yield
      ensure
        reap_current_session(name)
      end

      private

      def reap_current_session(name, thread = Thread.current)
        session_pool(name).checkin_from_thread thread
        true
      end
    end

    class Pool
      class Queue
        def initialize(lock=Monitor.new)
          @lock = lock
          @cond = @lock.new_cond
          @num_waiting = 0
          @queue = []
        end

        def any_waiting?
          synchronize do
            @num_waiting > 0
          end
        end

        def num_waiting
          synchronize do
            @num_waiting
          end
        end

        def add(session)
          synchronize do
            @queue.push session
            @cond.signal
          end
        end

        def remove
          synchronize do
            @queue.shift
          end
        end

        def poll(timeout = nil)
          synchronize do
            if timeout
              no_wait_poll || wait_poll(timeout)
            else
              no_wait_poll
            end
          end
        end

        def count
          @queue.count
        end

        private

        def synchronize(&block)
          @lock.synchronize(&block)
        end

        def any?
          !@queue.empty?
        end

        def can_remove_no_wait?
          @queue.size > @num_waiting
        end

        def no_wait_poll
          remove if can_remove_no_wait?
        end

        def wait_poll(timeout)
          @num_waiting += 1

          t0 = Time.now
          elapsed = 0
          loop do
            @cond.wait(timeout - elapsed)

            return remove if any?

            elapsed = Time.now - t0
            if elapsed >= timeout
              msg = 'Timed out waiting for database session'
              raise ConnectionTimeoutError, msg
            end
          end
        ensure
          @num_waiting -= 1
        end
      end

      include MonitorMixin

      attr_reader :sessions, :size, :reaper, :reserved_sessions, :available
      def initialize(opts={})
        super()
        opts[:name] ||= :default

        @reaper = Reaper.new(opts[:reap_frequency] || 10, self)
        @reaper.run

        @checkout_timeout = opts[:checkout_timeout] || 5

        @size = opts[:size] || 5
        @name = opts[:name] || :default
        @sessions = []
        @reserved_sessions = ThreadSafe::Cache.new(:initial_capacity => @size)
        @available = Queue.new self
      end

      def checkout
        unless (session = session_for_thread(Thread.current))
          synchronize do
            session = get_session
            reserve(session)
          end
        end
        session
      end

      # Returns a session back to the available pool
      def checkin(session)
        synchronize do
          @available.add session
          release(session)
        end
      end

      def checkin_from_thread(thread)
        checkin @reserved_sessions[thread]
      end

      def count
        @available.count
      end

      def reap
        @reserved_sessions.keys.each do |thread|
          session = @reserved_sessions[thread]
          checkin(session) if thread.stop?
        end
      end

      def session_for_thread(thread)
        @reserved_sessions[thread]
      end


      private

      def reserve(session)
        @reserved_sessions[current_session_id] = session
      end

      def current_session_id
        Thread.current
      end

      def release(session)
        thread =  if @reserved_sessions[current_session_id] == session
                      current_session_id
                  else
                    @reserved_sessions.keys.find do |k|
                      @reserved_sessions[k] == session
                    end
                  end
        @reserved_sessions.delete thread if thread
      end

      def get_session
        if session = @available.poll
          session
        elsif @sessions.size < @size
          checkout_new_session
        else
          @available.poll(@checkout_timeout)
        end
      end

      def checkout_new_session
        session = new_session
        @sessions << session
        session
      end

      def new_session
        Factory.create(@name)
      end

      class ConnectionTimeoutError < StandardError; end

      def create_new_session
        Factory.create(@name)
      end

      class Reaper
        attr_reader :pool
        attr_reader :frequency
        def initialize(frequency, pool)
          @frequency = frequency
          @pool = pool
        end

        def run
          return unless frequency
          Thread.new(frequency, pool) do |t, p|
            while true
              sleep t
              p.reap
            end
          end
        end
      end
    end
  end
end
