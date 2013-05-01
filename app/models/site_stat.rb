require 'mongoid'

require 'site_identifiable'
require 'statsable'

class SiteStat
  include Mongoid::Document
  include SiteIdentifiable
  include Statsable
end
