require 'mongoid'

require 'site_identifiable'
require 'yearly_expirable'
require 'statsable'
require 'last_hours_findable'
require 'last_days_starts_findable'

class SiteStat
  include Mongoid::Document
  include SiteIdentifiable
  include YearlyExpirable
  include Statsable
  include LastHoursFindable
  include LastDaysStartsFindable
end
