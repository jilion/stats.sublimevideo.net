require 'mongoid'

require 'video_identifiable'
require 'hourly_expirable'

class LastPlay
  include Mongoid::Document
  include VideoIdentifiable
  include HourlyExpirable

  index site_token: 1, time: -1 # for site last plays

  field :du, as: :document_url
  field :ru, as: :referrer_url
  field :ex, as: :external, type: Mongoid::Boolean
  field :br, as: :browser
  field :pl, as: :platform
  field :co, as: :country

  scope :since, ->(time) { where(:time.gt => time) }
end
