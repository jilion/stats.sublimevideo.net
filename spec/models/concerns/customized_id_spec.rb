# require 'spec_helper'

# describe CustomizedId , :focus do
#   class CustomizedIdModel
#     include Mongoid::Document
#     include CustomizedId

#     field :foo, type: Integer, default: 0
#   end
#   let(:time) { Time.now.utc }

#   describe "created object" do
#     subject { CustomizedIdModel.create(time: time, site_token: 'site_token').reload }

#     its(:id) { should have_key('i') }
#     its(:id) { should have_key('s') }
#     its(:site_token) { should eq 'site_token' }
#     its(:time) { should be_within(1.second).of(time) }
#   end

#   context "with multiple entries" do
#     let!(:entry11) { CustomizedIdModel.create(time: time, site_token: 'site_token') }
#     let!(:entry12) { CustomizedIdModel.create(time: 1.week.ago, site_token: 'site_token') }
#     let!(:entry2) { CustomizedIdModel.create(time: time, site_token: 'site_token2') }

#     it "uses index on find" do
#       criteria = CustomizedIdModel.where(_id: { s: 'site_token2', i: Moped::BSON::ObjectId.from_time(time) })
#       criteria.explain["cursor"].should eq "BtreeCursor _id_"
#       criteria.first.should eq entry2.reload
#     end

#     it "uses index on find by time" do
#       criteria = CustomizedIdModel.where(id: { s: 'site_token',
#         :$gte => { i: Moped::BSON::ObjectId.from_time(1.minute.ago) },
#         :$lte => { i: Moped::BSON::ObjectId.from_time(1.minute.from_now) }
#       })
#       criteria.explain["cursor"].should eq "BtreeCursor _id_"
#       criteria.count.should eq 1
#       criteria.first.should eq entry11.reload
#     end

#     it "upserts data" do
#       CustomizedIdModel.collection
#         .find(_id: { s: 'site_token', i: Moped::BSON::ObjectId.from_time(time)})
#         .update({:$inc => { foo: 2 }}, upsert: true)
#       entry11.reload.foo.should eq 2
#       entry12.reload.foo.should eq 0
#       entry2.reload.foo.should eq 0
#     end
#   end

# end
