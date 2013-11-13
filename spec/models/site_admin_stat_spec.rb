require 'spec_helper'

describe SiteAdminStat do
  let(:site_token) { 'site_token' }

  it { should be_kind_of Mongoid::Document }
  it { should be_kind_of SiteIdentifiable }
  it { should be_kind_of LastDaysStartsFindable }

  it { should have_field(:al).with_alias(:app_loads).of_type(Hash) }
  it { should have_field(:lo).with_alias(:loads).of_type(Hash) }
  it { should have_field(:st).with_alias(:starts).of_type(Hash) }
  it { should have_field(:sa).with_alias(:stages).of_type(Array) }
  it { should have_field(:ss).with_alias(:ssl).of_type(Mongoid::Boolean) }
  it { should have_field(:pa).with_alias(:pages).of_type(Array) }

  describe ".upsert_stats" do
    let(:time) { Time.now.to_i }
    let(:args) { { 's' => site_token, 't' => time.to_s } }
    let(:updates) { { :$inc => { 'al.m' => 1 } } }

    it "precises time to day" do
      described_class.upsert_stats(args, updates)
      expect(described_class.last.time).to eq Time.at(time).utc.change(hour: 0)
    end

    it "updates existing stat" do
      expect{ described_class.upsert_stats(args, updates) }
        .to change{ described_class.count }.from(0).to(1)
      expect{ described_class.upsert_stats(args, updates) }
        .to_not change{ described_class.count }
    end

    it "updates with $set" do
      described_class.upsert_stats(args, :$set => { 'ss' => false })
      expect(described_class.last.ssl).to be_false
    end

    it "updates with $addToSet" do
      described_class.upsert_stats(args, :$addToSet => { 'sa' => 'a' })
      described_class.upsert_stats(args, :$addToSet => { 'sa' => 'b' })
      expect(described_class.last.stages).to eq %w[alpha beta]
    end

    it "updates with $push & $slice" do
      described_class.upsert_stats(args, :$push => { 'pa' => { :$each => %w[url1 url2], :$slice => -2 } })
      described_class.upsert_stats(args, :$push => { 'pa' => { :$each => %w[url3], :$slice => -2 } })
      expect(described_class.last.pages).to eq %w[url2 url3]
    end
  end

  describe ".last_pages" do
    before {
      described_class.create(site_token: site_token, time: 1.days.ago, pages: %w[url1 url2])
      described_class.create(site_token: site_token, time: 2.days.ago, pages: %w[url2 url3 url4])
      described_class.create(site_token: site_token, time: 3.days.ago, pages: nil)
      described_class.create(site_token: site_token, time: 31.days.ago, pages: %w[old_url])
    }

    it "returns last most used pages" do
      expect(described_class.last_pages(site_token, limit: 3)).to eq %w[url2 url3 url1]
    end
  end

  describe ".last_without_pages" do
    let!(:stat1) { described_class.create(site_token: site_token, time: 3.days.ago) }
    let!(:stat2) { described_class.create(site_token: site_token, time: 2.days.ago) }
    let!(:stat3) { described_class.create(site_token: site_token, time: 1.days.ago, pages: %w[url1]) }

    it "returns last without pages" do
      expect(described_class.last_without_pages(site_token)).to eq stat2
    end
  end

  describe ".global_day_stat" do
    let(:day) { 1.days.ago.midnight.utc }
    let!(:stat1) { described_class.create(site_token: '1', time: day, app_loads: { 'm' => 1, 'e' => 2 }, loads: { 'w' => 1 }) }
    let!(:stat2) { described_class.create(site_token: '2', time: day, app_loads: { 'm' => 1, 's' => 2 }, starts: { 'e' => 3 }) }
    let!(:stat3) { described_class.create(site_token: '3', time: day, loads: { 'w' => 1, 'e' => 1 }, starts: { 'w' => 3, 'e' => 1 }) }

    it "merges all stats from every sites that day" do
      stat = SiteAdminStat.global_day_stat(day.to_date, [:app_loads, :loads, :starts])
      expect(stat.app_loads).to eq({ 'm' => 2, 'e' => 2, 's' => 2 })
      expect(stat.loads).to eq({ 'w' => 2, 'e' => 1 })
      expect(stat.starts).to eq({ 'w' => 3, 'e' => 4 })
    end
  end

  describe ".last_30_days_sites_with_starts" do
    let!(:stat1) { described_class.create(site_token: '1', time: 1.days.ago, starts: { 'e' => 3, 'w' => 1}) }
    let!(:stat2) { described_class.create(site_token: '2', time: 5.days.ago, starts: { 'e' => 5 }) }
    let!(:stat3) { described_class.create(site_token: '2', time: 5.days.ago, starts: { 'w' => 3 }) }
    let!(:stat4) { described_class.create(site_token: '2', time: 5.days.ago, starts: nil) }
    let!(:stat5) { described_class.create(site_token: '3', time: 19.days.ago, starts: { 'w' => 1, 'e' => 1 }) }
    let!(:stat6) { described_class.create(site_token: '4', time: 31.days.ago, starts: { 'w' => 1, 'e' => 1 }) }

    it "counts number of site with more than threshold in the last 30 days" do
      count = SiteAdminStat.last_30_days_sites_with_starts(Date.yesterday, threshold: 2)
      expect(count).to eq 3
    end

    it "counts number of site with more than threshold in the last 30 days (threshold: 4)" do
      count = SiteAdminStat.last_30_days_sites_with_starts(Date.yesterday, threshold: 4)
      expect(count).to eq 2
    end

    it "counts number of site with more than threshold in the last 30 days (5 days ago)" do
      count = SiteAdminStat.last_30_days_sites_with_starts(5.days.ago, threshold: 2)
      expect(count).to eq 3
    end
  end
end
