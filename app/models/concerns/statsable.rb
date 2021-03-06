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
    def upsert_stats(args, updates)
      args = _hour_precise_time(args)
      self.collection.where(args).upsert(updates)
    end

    def upsert_stats_from_data(args, event_field, data)
      return unless data.hostname.in? %w[main extra]
      updates = { :$inc => _incs(event_field, data) }
      upsert_stats(args, updates)
    end

    private

    def _hour_precise_time(args)
      args['t'] = Time.at(args['t'].to_i).utc.change(min: 0)
      args
    end

    def _incs(event_field, data)
      case event_field
      when :loads
        { "lo.#{data.source_key}" => 1 }
      when :starts
        { "st.#{data.source_key}" => 1,
          "de.#{data.source_key}.#{data.de}" => 1,
          "co.#{data.source_key}.#{data.country_code}" => 1,
          "bp.#{data.source_key}.#{data.browser_code}-#{data.platform_code}" => 1 }
      end
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
