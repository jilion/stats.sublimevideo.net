require 'mongoid'

require 'geoip_wrapper'
require 'user_agent_wrapper'

module Statsable
  extend ActiveSupport::Concern

  included do
    field :lo, as: :loads, type: Hash # { w(website): 3, e(external): 9 }
    field :st, as: :starts, type: Hash # { w(website): 3, e(external): 9 }
    field :de, as: :devices, type: Hash # { w(website): { "d" => 2, "m" => 4 }, e(external): ... } on starts only
    field :co, as: :countries, type: Hash # { w(website): { "us" => 2, "fr" => 4, ... }, e(external): ... } on starts only
    field :bp, as: :browser_and_platform, type: Hash # { w(website): { "saf-win" => 2, "saf-osx" => 4, ... }, e(external): ... } on starts only
  end

  module ClassMethods
    def inc_stats(args, event_field, data)
      args = _hour_precise_time(args)
      stat = where(args)
      stat.find_and_modify(
        { :$inc => _incs(event_field, data) },
        upsert: true,
        new: true)
    end

    private

    def _hour_precise_time(args)
      args[:time] = Time.at(args[:time]).change(min: 0)
      args
    end

    def _incs(event_field, data)
      source_provenance = _source_provenance(data)
      case event_field
      when :loads
        { "lo.#{source_provenance}" => 1 }
      when :starts
        { "st.#{source_provenance}" => 1,
          "de.#{source_provenance}.#{data['d']}" => 1,
          "co.#{source_provenance}.#{_country_code(data)}" => 1,
          "bp.#{source_provenance}.#{_browser_code_and_platform_code_from_user_agent(data)}" => 1 }
      end
    end

    def _source_provenance(data)
      case data['ex']
      when 1, '1' then 'e'
      else 'w'
      end
    end

    def _country_code(data)
      GeoIPWrapper.country(data['ip'])
    end

    def _browser_code_and_platform_code_from_user_agent(data)
      user_agent = UserAgentWrapper.new(data['ua'])
      "#{user_agent.browser_code}-#{user_agent.platform_code}"
    end
  end

  def all(field)
    w, e = website(field), external(field)
    case _field_default(field)
    when Integer then w + e
    when Hash then w.merge(e) { |k, v1, v2| v1 + v2 }
    end
  end

  def website(field)
    send(field) && send(field)['w'] || _field_default(field)
  end

  def external(field)
    send(field) && send(field)['e'] || _field_default(field)
  end

  private

  def _field_default(field)
    field.in?(%i[loads starts]) ? 0 : {}
  end
end
