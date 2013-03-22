class SiteAdminStats # per Day only
  include Mongoid::Document
  include CustomizedId
  include Statsable

  field :al, as: :app_loads, type: Hash # { m(main): 1, e(extra): 3, s(staging): 5, d(dev): 11, i(invalid): 1 }
  field :st, as: :stage, type: Array # Stages used that day
  field :s, as: :ssl, type: Boolean # SSL used this day
end
