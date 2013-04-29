require 'mongoid'

module HourlyExpirable
  extend ActiveSupport::Concern

  included do
    index({ t: 1 }, expire_after_seconds: 61.minutes.to_i)
  end
end
