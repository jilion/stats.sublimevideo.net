require 'fast_spec_helper'

require 'stats_migrator_worker'

describe StatsMigratorWorker do
  it "delays job in stats (stsv) queue" do
    StatsMigratorWorker.get_sidekiq_options['queue'].should eq 'stats'
  end

  describe "#perform" do
    let(:worker) { StatsMigratorWorker.new }

    context "with Stat::Site::Day stat" do
      let(:stat_class) { 'Stat::Site::Day' }
      let(:time) { 3.days.ago.utc.beginning_of_day }
      let(:data) { {
        'site_token' => 'site_token',
        'time' => time,
        'app_loads' => { 'm' => 1, 'e' => 2, 's' => 3, 'd' => 4, 'i' => 5, 'em' => 6 },
        'stages' => %w[stable beta],
        'ssl' => true } }

      it "updates SiteAdminStat" do
        SiteAdminStat.should_receive(:update_stats).with(
          { site_token: 'site_token', time: time },
          { :$inc => { 'al.m' => 1, 'al.e' => 2, 'al.s' => 3, 'al.d' => 4, 'al.i' => 5 },
            :$set => { 'ss' => true, 'sa' => %w[stable beta] } })
        worker.perform(stat_class, data)
      end
    end
  end

end
