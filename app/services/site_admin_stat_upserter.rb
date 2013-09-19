require 'site_admin_stat'

class SiteAdminStatUpserter
  attr_accessor :data, :updates

  def initialize(event_field, data)
    @data = data
    @updates = send("_updates_for_#{event_field}")
  end

  def self.upsert(site_args, event_field, data)
    new(event_field, data).upsert(site_args)
  end

  def upsert(site_args)
    SiteAdminStat.upsert_stats(site_args, updates)
  end

  private

  def _updates_for_app_loads
    { :$inc => { "al.#{data.ho}" => 1 },
      :$set => { 'ss' => data.ss },
      :$addToSet => { 'sa' => data.st } }
  end

  def _updates_for_loads
    { :$inc => { "lo.#{data.source_key}" => 1 } }
  end

  def _updates_for_starts
    { :$inc =>  { "st.#{data.source_key}" => 1 },
      :$push => { 'pa' => { :$each => [data.du].compact, :$slice => -10 } } }
  end
end
