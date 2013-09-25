require 'fast_spec_helper'

require 'stats_migrator_worker'

describe StatsMigratorWorker do
  it "delays job in stats (stsv) queue" do
    expect(StatsMigratorWorker.get_sidekiq_options['queue']).to eq 'stats-migration'
  end

  describe "#perform" do
    let(:worker) { StatsMigratorWorker.new }

    context "with Stat::Site::Day stat" do
      let(:stat_class) { 'Stat::Site::Day' }
      let(:time) { 3.days.ago.utc.beginning_of_day }
      let(:data) { {
        'site_token' => 'site_token',
        'time' => time.to_s,
        'app_loads' => { 'm' => '1', 'e' => '2', 's' => '3', 'd' => '4', 'i' => '5', 'em' => '6' },
        'stages' => %w[s b],
        'ssl' => 'true' } }

      it "updates SiteAdminStat" do
        expect(SiteAdminStat).to receive(:upsert_stats).with(
          { site_token: 'site_token', time: time },
          { :$inc => { 'al.m' => 1, 'al.e' => 2, 'al.s' => 3, 'al.d' => 4, 'al.i' => 5 },
            :$set => { 'ss' => true, 'sa' => %w[s b] } })
        worker.perform(stat_class, data)
      end
    end

    context "with Stat::Video::Day stat" do
      let(:video_uid) { 'valid_uid' }
      let(:stat_class) { 'Stat::Video::Day' }
      let(:time) { 3.days.ago.utc.beginning_of_day }
      let(:data) { {
        'site_token' => 'site_token',
        'video_uid' => video_uid,
        'time' => time.to_s,
        'sa' => true,
        'loads' => { 'm' => '1', 'e' => '2', 's' => '3', 'd' => '4', 'i' => '5', 'em' => '6' },
        'starts' => { 'm' => '1', 'e' => '2', 's' => '3', 'd' => '4', 'i' => '5', 'em' => '6' },
        'player_mode_and_device' => { 'h' => { 'd' => '1', 'm' => '2' }, 'f' => { 'd' => '3', 'm' => '4' } },
        'browser_and_platform' => { "saf-win" => '2', "saf-osx" => '4' } } }
      before {
        SiteAdminStat.stub(:upsert_stats)
        SiteStat.stub(:upsert_stats)
        VideoStat.stub(:upsert_stats)
      }

      context "with valid uid" do
        it "updates SiteAdminStat" do
          expect(SiteAdminStat).to receive(:upsert_stats).with(
            { site_token: 'site_token', time: time },
            { :$inc => {
              'lo.w' => 1 + 2, 'lo.e' => 6,
              'st.w' => 1 + 2, 'st.e' => 6 } })
          worker.perform(stat_class, data)
        end

        it "updates SiteStat" do
          expect(SiteStat).to receive(:upsert_stats).with(
            { site_token: 'site_token', time: time },
            { :$inc => {
              'lo.w' => 1 + 2, 'lo.e' => 6,
              'st.w' => 1 + 2, 'st.e' => 6,
              'de.w.d' => 1 + 3, 'de.w.m' => 2 + 4,
              'bp.w.saf-win' => 2, 'bp.w.saf-osx' => 4 } })
          worker.perform(stat_class, data)
        end

        it "updates VideoStat" do
          expect(VideoStat).to receive(:upsert_stats).with(
            { site_token: 'site_token', video_uid: video_uid, time: time },
            { :$inc => {
              'lo.w' => 1 + 2, 'lo.e' => 6,
              'st.w' => 1 + 2, 'st.e' => 6,
              'de.w.d' => 1 + 3, 'de.w.m' => 2 + 4,
              'bp.w.saf-win' => 2, 'bp.w.saf-osx' => 4 } })
          worker.perform(stat_class, data)
        end
      end

      context "with invalid uid" do
        let(:video_uid) { 'invalid_uid!$%?' }

        it "updates SiteAdminStat" do
          expect(SiteAdminStat).to receive(:upsert_stats)
          worker.perform(stat_class, data)
        end

        it "updates SiteStat" do
          expect(SiteStat).to receive(:upsert_stats)
          worker.perform(stat_class, data)
        end

        it "doesn't updates VideoStat" do
          expect(VideoStat).to_not receive(:upsert_stats)
          worker.perform(stat_class, data)
        end
      end

      context "without stats addon" do
        before { data['sa'] = false }

        it "updates SiteAdminStat" do
          expect(SiteAdminStat).to receive(:upsert_stats)
          worker.perform(stat_class, data)
        end

        it "doesn't updates SiteStat" do
          expect(SiteStat).to_not receive(:upsert_stats)
          worker.perform(stat_class, data)
        end

        it "doesn't updates VideoStat" do
          expect(VideoStat).to_not receive(:upsert_stats)
          worker.perform(stat_class, data)
        end
      end
    end
  end
end
