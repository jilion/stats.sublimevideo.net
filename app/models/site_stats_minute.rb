class SiteStatsMinute
  include Mongoid::Document
  include CustomizedId
  include Statsable
  include ExpirableHourly
end
