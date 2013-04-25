require 'mongoid'

module LastStatsable
  extend ActiveSupport::Concern

  included do
    field :lo, as: :loads, type: Integer
    field :st, as: :starts, type: Integer
  end
end
