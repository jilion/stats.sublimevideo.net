require 'spec_helper'

describe SiteAdminStat do
  it { should be_kind_of Mongoid::Document }
  it { should be_kind_of SiteIdentifiable }

  it { should have_field(:al).with_alias(:app_loads).of_type(Hash) }
  it { should have_field(:lo).with_alias(:loads).of_type(Hash) }
  it { should have_field(:st).with_alias(:starts).of_type(Hash) }
  it { should have_field(:sa).with_alias(:stages).of_type(Array) }
  it { should have_field(:ss).with_alias(:ssl).of_type(Mongoid::Boolean) }
  it { should have_field(:pa).with_alias(:pages).of_type(Array) }

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

    it "updates with $push & $slice" do
      SiteAdminStat.update_stats(args, :$push => { 'pa' => { :$each => %w[url1 url2], :$slice => -2 } })
      SiteAdminStat.update_stats(args, :$push => { 'pa' => { :$each => %w[url3], :$slice => -2 } })
      SiteAdminStat.last.pages.should eq %w[url2 url3]
    end
  end

  describe ".last_pages" do
    let(:site_token) { 'site_token' }

    before {
      SiteAdminStat.create(site_token: site_token, time: 1.days.ago, pages: %w[url1 url2])
      SiteAdminStat.create(site_token: site_token, time: 2.days.ago, pages: %w[url2 url3 url4])
      SiteAdminStat.create(site_token: site_token, time: 31.days.ago, pages: %w[old_url])
    }

    it "returns last most used pages" do
      SiteAdminStat.last_pages(site_token, limit: 3).should eq %w[url2 url3 url1]
    end
  end
end
