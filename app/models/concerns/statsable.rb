require 'mongoid'

module Statsable
  extend ActiveSupport::Concern

  included do
    field :vl, as: :video_loads, type: Hash # { a(all): 12, w(website): 3, e(external): 9 }
    field :vs, as: :video_starts, type: Hash # { a(all): 12, w(website): 3, e(external): 9 }
    field :td, as: :tech_by_device, type: Hash # { a(all): { h(html5): { d(desktop): 2, m(mobile): 1 }, f(flash): ... }, w(website): {} }
    field :bp, as: :browser_and_plateform, type: Hash # { a(all): { "saf-win" => 2, "saf-osx" => 4, ... }, e(external):
  end
end
