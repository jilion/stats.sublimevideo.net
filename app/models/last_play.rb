require 'hourly_expirable'

class LastPlay
  include Mongoid::Document
  include HourlyExpirable

  field :s, as: :site_token
  field :u, as: :video_uid
  field :t, as: :time, type: Time # seconds precision
  index site_token: 1, time: -1
  index site_token: 1, video_uid: 1, time: -1

  field :du, as: :document_url
  field :ru, as: :referrer_url
  field :ex, as: :external, type: Mongoid::Boolean
  field :br, as: :browser
  field :pl, as: :platform
  field :co, as: :country
end
