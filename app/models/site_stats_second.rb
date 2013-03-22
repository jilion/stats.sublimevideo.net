class SiteStatsSecond
  include Mongoid::Document
  include CustomizedId
  include Statsable
  include ExpirableMinutely
end
