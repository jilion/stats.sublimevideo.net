require 'geoip_wrapper'
require 'user_agent_wrapper'

class DataAnalyzer < Hash

  attr_accessor :data

  def initialize(data = {})
    self.replace(data)
    self
  end

  def source_provenance
    case ex
    when 1, '1' then 'e'
    else 'w'
    end
  end

  def country_code
    GeoIPWrapper.country(ip)
  end

  def browser_code
    _user_agent.browser_code
  end

  def platform_code
    _user_agent.platform_code
  end

  def method_missing(method_name)
    self[method_name.to_s]
  end

  private

  def _user_agent
    @_user_agent ||= UserAgentWrapper.new(ua)
  end
end
