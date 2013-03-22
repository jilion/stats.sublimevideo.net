require 'spec_helper'

describe CustomizedId do
  class CustomizedIdModel
    include Mongoid::Document
    include CustomizedId

    field :foo, type: Integer, default: 0
  end

  let(:site_token) { 'site_token' }
  let(:time) { Time.now.utc }
  subject { CustomizedIdModel.create(time: time, site_token: site_token).reload }

  its(:site_token) { should eq site_token }
  its(:time) { should be_within(1.second).of(time) }

  it "uses index on find" do
    subject

    criteria = CustomizedIdModel.where(id: { t: time, s: site_token })
    criteria.explain["cursor"].should eq "BtreeCursor _id_"
    criteria.first.should eq subject
  end

  it "upserts data" do
    CustomizedIdModel.collection
      .find(_id: { t: time, s: site_token})
      .update({:$inc => { foo: 2 }}, upsert: true)

    subject.reload.foo.should eq 2
  end
end
