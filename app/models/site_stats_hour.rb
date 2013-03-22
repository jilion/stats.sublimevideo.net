class SiteStatsHour
  include Mongoid::Document
  include CustomizedId
  include Statsable
  include ExpirableDaily
end
