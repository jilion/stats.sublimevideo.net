require 'spec_helper'

describe SiteAdminStat do
  it { should be_kind_of Mongoid::Document }
  it { should be_kind_of SiteIdentifiable }

  it { should have_field(:al).with_alias(:app_loads).of_type(Hash) }
  it { should have_field(:lo).with_alias(:loads).of_type(Hash) }
  it { should have_field(:st).with_alias(:starts).of_type(Hash) }
  it { should have_field(:sa).with_alias(:stages).of_type(Array) }
  it { should have_field(:ss).with_alias(:ssl).of_type(Mongoid::Boolean) }

  describe ".update_stats" do
    let(:time) { Time.now.to_i }
    let(:args) { { site_token: 'site_token', time: time } }
    let(:updates) { { :$inc => { 'al.m' => 1 } } }

    it "precises time to day" do
      SiteAdminStat.update_stats(args, updates)
      SiteAdminStat.last.time.should eq Time.at(time).utc.change(hour: 0)
    end

    it "updates existing stat" do
      expect{ SiteAdminStat.update_stats(args, updates) }
        .to change{ SiteAdminStat.count }.from(0).to(1)
      expect{ SiteAdminStat.update_stats(args, updates) }
        .to_not change{ SiteAdminStat.count }
    end

    it "updates with $set" do
      SiteAdminStat.update_stats(args, :$set => { 'ss' => true })
      SiteAdminStat.last.ssl.should be_true
    end

    it "updates with $addToSet" do
      SiteAdminStat.update_stats(args, :$addToSet => { 'sa' => 'a' })
      SiteAdminStat.update_stats(args, :$addToSet => { 'sa' => 'b' })
      SiteAdminStat.last.stages.should eq %w[alpha beta]
    end
  end

end
