require 'fast_spec_helper'

require 'data_hash'
require 'site_admin_stat_upserter'

describe SiteAdminStatUpserter do

  describe "#perform" do
    let(:upserter) { SiteAdminStatUpserter.new(event_field, data) }
    let(:site_args) { { 's' => 'site_token', 't' => Time.now.to_i } }

    context "app_loads event" do
      let(:event_field) { :app_loads }
      let(:data) { DataHash.new('ho' => 'm', 'ss' => '1', 'st' => 'a') }

      it "increments app_loads, updates stages and sets ssl" do
        SiteAdminStat.should_receive(:upsert_stats).with(site_args,
          :$inc => { 'al.m' => 1 },
          :$set => { 'ss' => '1' },
          :$addToSet => { 'sa' => 'a' })
        upserter.upsert(site_args)
      end
    end

    context "loads event" do
      let(:event_field) { :loads }
      let(:data) { DataHash.new('ex' => '1') }

      it "increments app_loads stats" do
        SiteAdminStat.should_receive(:upsert_stats).with(site_args,
          :$inc => { 'lo.e' => 1 })
        upserter.upsert(site_args)
      end
    end

    context "starts event" do
      let(:event_field) { :starts }
      let(:data) { DataHash.new('du' => 'document_url') }

      it "increments app_loads stats and pushes document url to pages" do
        SiteAdminStat.should_receive(:upsert_stats).with(site_args,
          :$inc => { 'st.w' => 1 },
          :$push => { 'pa' => { :$each => ['document_url'], :$slice => -10 } })
        upserter.upsert(site_args)
      end
    end

  end
end
