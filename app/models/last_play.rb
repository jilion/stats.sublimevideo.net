class LastPlay
  include Mongoid::Document
  include Mongoid::Timestamps::Created::Short # For c_at only.

  field :s, as: :site_token
  field :u, as: :video_uid

  field :du, as: :document_url
  field :ru, as: :referrer_url
  field :ex, as: :external, type: Boolean
  field :br, as: :browser
  field :pl, as: :platform
  field :co, as: :country

  index site_token: 1, created_at: -1
  index site_token: 1, video_uid: 1, created_at: -1
  index({ created_at: 1 }, expire_after_seconds: 61.minutes.to_i)
end
