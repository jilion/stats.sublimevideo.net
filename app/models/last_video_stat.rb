class LastVideoStat
  include Mongoid::Document
  include LastStatsable

  field :s, as: :site_token
  field :u, as: :video_uid
  field :t, as: :time, type: Time # seconds precision

  index site_token: 1, video_uid: 1, time: -1
  index({ time: 1 }, expire_after_seconds: 61.minutes.to_i)
end
