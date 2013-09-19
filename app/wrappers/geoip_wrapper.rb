require 'geoip'

class GeoIPWrapper

  def self.country(ip)
    _database.country(ip).country_code2.downcase
  rescue
    '--'
  end

  private

  def self._database
    @database ||= GeoIP.new(_database_url)
  end

  def self._database_url
    Rails.root.join('vendor', 'geoip.dat')
  end

end
