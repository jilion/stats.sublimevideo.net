class SiteStatsDay
  include Mongoid::Document
  include CustomizedId
  include Statsable
end
