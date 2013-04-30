require 'mongoid'

module Statsable
  extend ActiveSupport::Concern

  included do
    field :lo, as: :loads, type: Hash # { w(website): 3, e(external): 9 }
    field :st, as: :starts, type: Hash # { w(website): 3, e(external): 9 }
    field :de, as: :devices, type: Hash # { w(website): { "d" => 2, "m" => 4 }, e(external): ... }
    field :co, as: :countries, type: Hash # { w(website): { "us" => 2, "fr" => 4, ... }, e(external): ... }
    field :bp, as: :browser_and_platform, type: Hash # { w(website): { "saf-win" => 2, "saf-osx" => 4, ... }, e(external): ... }
  end

  def all(field)
    w, e = website(field), external(field)
    case field_default(field)
    when Integer then w + e
    when Hash then w.merge(e) { |k, v1, v2| v1 + v2 }
    end
  end

  def website(field)
    send(field)['w'] || field_default(field)
  end

  def external(field)
    send(field)['e'] || field_default(field)
  end

  def field_default(field)
    field.in?(%i[loads starts]) ? 0 : {}
  end
end
