require 'geoip'

class GeoIPWrapper
  attr_accessor :ip

  def initialize(ip)
    @ip = ip
  end

  def self.country(ip)
    new(ip).country
  end

  def country
    _database.country(ip).country_code2.downcase
  rescue
    '--'
  end

  private

  def _database
    @database ||= GeoIP.new(_database_url)
  end

  def _database_url
    Rails.root.join('vendor', 'geoip.dat')
  end

end
