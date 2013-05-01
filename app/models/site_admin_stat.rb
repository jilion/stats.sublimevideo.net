require 'mongoid'

require 'site_identifiable'

class SiteAdminStat
  include Mongoid::Document
  include SiteIdentifiable

  field :al, as: :app_loads, type: Hash # { m(main): 1, e(extra): 3, s(staging): 5, d(dev): 11, i(invalid): 1 }
  field :st, as: :stage, type: Array # Stages used that day
  field :ss, as: :ssl, type: Mongoid::Boolean # SSL used this day
  # TODO Add more fields
end
