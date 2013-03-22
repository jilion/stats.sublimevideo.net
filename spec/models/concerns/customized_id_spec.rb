require "spec_helper"

describe CustomizedId do
  class CustomizedIdModel
    include Mongoid::Document
    include CustomizedId
  end

  let(:site_token) { 'site_token' }
  let(:time) { Time.now.utc }
  subject { CustomizedIdModel.new(time: time, site_token: site_token) }

  its(:site_token) { should eq site_token }
  its(:time) { should eq time }
end
