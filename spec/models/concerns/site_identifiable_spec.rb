require 'fast_spec_helper'
require 'config/mongoid'

require 'site_identifiable'

describe SiteIdentifiable do
  class SiteIdentifiableModel
    include Mongoid::Document
    include SiteIdentifiable
  end
  subject { SiteIdentifiableModel }

  it { should have_field(:s).with_alias(:site_token) }
  it { should have_field(:t).with_alias(:time).of_type(Time) }

  # https://github.com/evansagge/mongoid-rspec/issues/102
  # it { should have_index_for(s: 1, t: -1) }
end
