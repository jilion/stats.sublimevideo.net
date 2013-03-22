require 'mongoid'

module ExpirableDaily
  extend ActiveSupport::Concern

  included do
    include Mongoid::Timestamps::Created::Short # For c_at only.
    index({ created_at: 1 }, { expire_after_seconds: 27.hours.to_i })
  end
end
