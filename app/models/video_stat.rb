class VideoStat
  include Mongoid::Document
  include Statsable

  field :s, as: :site_token
  field :u, as: :uid
  field :t, as: :time, type: Time # hour precision

  index site_token: 1, uid: 1, time: -1
end
