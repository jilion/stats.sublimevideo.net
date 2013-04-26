require 'mongoid'

module LastStatsable
  extend ActiveSupport::Concern

  included do
    field :lo, as: :loads, type: Integer, default: 0
    field :st, as: :starts, type: Integer, default: 0
  end
end
