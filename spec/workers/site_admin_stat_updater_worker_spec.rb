require 'fast_spec_helper'

require 'site_admin_stat_updater_worker'

describe SiteAdminStatUpdaterWorker do
  it "delays job in stats queue" do
    SiteAdminStatUpdaterWorker.sidekiq_options_hash['queue'].should eq 'stats-low'
  end

  describe "#perform" do
    let(:worker) { SiteAdminStatUpdaterWorker.new }
    let(:site_args) { { site_token: 'site_token', time: Time.now.to_i } }
    let(:data_hash) { OpenStruct.new(data) }
    before { DataHash.stub(:new) { data_hash } }

    context "app_loads event" do
      let(:event_field) { :app_loads }
      let(:data) { { 'ho' => 'm', 'ss' => '1', 'st' => 'a' } }

      it "increments app_loads, updates stages and sets ssl" do
        SiteAdminStat.should_receive(:update_stats).with(site_args,
          :$inc => { 'al.m' => 1 },
          :$set => { 'ss' => '1' },
          :$addToSet => { 'sa' => 'a' })
        worker.perform(site_args, event_field, data)
      end
    end

    context "loads event" do
      let(:event_field) { :loads }
      let(:data) { { 'ex' => '1' } }
      before { data_hash.stub(:source_key) { 'e' } }

      it "increments app_loads stats" do
        SiteAdminStat.should_receive(:update_stats).with(site_args,
          :$inc => { 'lo.e' => 1 })
        worker.perform(site_args, event_field, data)
      end
    end

    context "starts event" do
      let(:event_field) { :starts }
      let(:data) { { 'du' => 'document_url' } }
      before { data_hash.stub(:source_key) { 'w' } }

      it "increments app_loads stats and pushes document url to pages" do
        SiteAdminStat.should_receive(:update_stats).with(site_args,
          :$inc => { 'st.w' => 1 },
          :$push => { 'pa' => { :$each => ['document_url'], :$slice => -10 } })
        worker.perform(site_args, event_field, data)
      end
    end

  end
end
