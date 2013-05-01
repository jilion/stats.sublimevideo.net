require 'mongoid'

require 'video_identifiable'
require 'statsable'

class VideoStat
  include Mongoid::Document
  include VideoIdentifiable
  include Statsable
end
