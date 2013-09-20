require 'fast_spec_helper'

require 'site_admin_pages_migrator_worker'

describe SiteAdminPagesMigratorWorker do
  let(:worker) { SiteAdminPagesMigratorWorker.new }

  it "delays job in stats (stsv) queue" do
    expect(SiteAdminPagesMigratorWorker.get_sidekiq_options['queue']).to eq 'stats-migration'
  end

  describe "#perform" do
    let(:site_token) { 'site_token' }
    let(:pages) { %w[old_url] }
    let(:site_admin_stat) { double(SiteAdminStat) }

    it "updates last site_admin_stat without pages" do
      expect(SiteAdminStat).to receive(:last_without_pages).with(site_token) { site_admin_stat }
      expect(site_admin_stat).to receive(:update_attribute).with(:pages, pages)
      worker.perform(site_token, pages)
    end
  end
end
