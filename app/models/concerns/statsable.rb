require 'mongoid'

module Statsable
  extend ActiveSupport::Concern

  included do
    field :lo, as: :loads, type: Hash # { a(all): 12, w(website): 3, e(external): 9 }
    field :st, as: :starts, type: Hash # { a(all): 12, w(website): 3, e(external): 9 }
    field :de, as: :devises, type: Hash # { a(all): { "d" => 2, "m" => 4 }, w(website): ... }
    field :co, as: :countries, type: Hash # { a(all): { "usa" => 2, "fra" => 4, ... }, w(website): ... }
    field :bp, as: :browser_and_platform, type: Hash # { a(all): { "saf-win" => 2, "saf-osx" => 4, ... }, w(website): ... }
  end
end
