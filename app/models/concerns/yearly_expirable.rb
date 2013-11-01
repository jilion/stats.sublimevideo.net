module YearlyExpirable
  extend ActiveSupport::Concern

  included do
    index({ t: 1 }, expire_after_seconds: (1.year + 1.day).to_i, background: true)
  end
end
