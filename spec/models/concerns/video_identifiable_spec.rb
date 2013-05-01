require 'fast_spec_helper'
require 'config/mongoid'

require 'video_identifiable'

describe VideoIdentifiable do
  class VideoIdentifiableModel
    include Mongoid::Document
    include VideoIdentifiable
  end
  subject { VideoIdentifiableModel }

  it { should have_field(:s).with_alias(:site_token) }
  it { should have_field(:u).with_alias(:video_uid) }
  it { should have_field(:t).with_alias(:time).of_type(Time) }

  it { should have_index_for(s: 1, u: 1, t: -1) }
end
