require 'geoip'

class GeoIPWrapper

  def self.country(ip)
    result = database.country(ip).country_code2.downcase
    handle_special_case(result)
  rescue
    nil
  end

  private

  def self.database
    @database ||= GeoIP.new(database_url)
  end

  def self.database_url
    Rails.root.join('vendor', 'geoip.dat')
  end

  def self.handle_special_case(result)
    case result
    when 'gb' then 'uk'
    when '--' then nil
    else result
    end
  end

end
