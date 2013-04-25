# require 'spec_helper'

# describe VideoUid do
#   class VideoUidModel
#     include Mongoid::Document
#     include CustomizedId
#     include VideoUid
#   end
#   let(:time) { Time.now.utc }
#   subject { VideoUidModel }

#   it { should have_field(:u).with_alias(:uid).of_type(String) }
#   it { should have_index_for(_id: 1, u: 1) }

#   context "with multiple entries" do
#     let!(:entry11) { VideoUidModel.create(site_token: 'site_token', time: time, uid: 'abc123') }
#     let!(:entry12) { VideoUidModel.create(site_token: 'site_token', time: 1.week.ago, uid: 'abc123') }
#     let!(:entry21) { VideoUidModel.create(site_token: 'site_token2', time: time, uid: 'abc456') }
#     let!(:entry22) { VideoUidModel.create(site_token: 'site_token2', time: time, uid: 'abc789') }

#     before { VideoUidModel.remove_indexes && VideoUidModel.create_indexes }

#     it "uses index on find" do
#       criteria = VideoUidModel.where(_id: { s: 'site_token', i: Moped::BSON::ObjectId.from_time(time) }, uid: 'abc123')
#       criteria.explain["cursor"].should eq "BtreeCursor u_1__id_1"
#       criteria.first.should eq entry11.reload
#     end

#     it "uses index on find by time" do
#       criteria = VideoUidModel.where(_id: {
#         :$gte => { s: 'site_token', i: Moped::BSON::ObjectId.from_time(1.minute.ago) },
#         :$lte => { s: 'site_token', i: Moped::BSON::ObjectId.from_time(1.minute.from_now) }
#       }, uid: 'abc123')
#       criteria.explain["cursor"].should eq "BtreeCursor u_1__id_1"
#       criteria.count.should eq 1
#       criteria.first.should eq entry11.reload
#     end

#     it "uses index on find by time", :focus do
#       p VideoUidModel.count
#       criteria = VideoUidModel.where(_id: {
#         :$gte => { s: 'site_token2', i: Moped::BSON::ObjectId.from_time(1.minute.ago) },
#         :$lte => { s: 'site_token2', i: Moped::BSON::ObjectId.from_time(1.minute.from_now) }
#       })
#       criteria.explain["cursor"].should eq "BtreeCursor _id_"
#       criteria.count.should eq 2
#       criteria.all.should eq [entry21, entry22]
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
