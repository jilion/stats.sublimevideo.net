class VideoStat
  include Mongoid::Document
  include Statsable

  field :s, as: :site_token
  field :u, as: :video_uid
  field :t, as: :time, type: Time # hour precision

  index site_token: 1, video_uid: 1, time: -1
end
