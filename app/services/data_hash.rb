require 'geoip_wrapper'
require 'user_agent_wrapper'

class DataHash < Hash

  def initialize(data = {})
    self.replace(data)
    self
  end

  def source_key
    case ex
    when 1, '1' then 'e'
    else 'w'
    end
  end

  def source
    case source_key
    when 'e' then 'external'
    when 'w' then 'website'
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

  def hostname
    case ho
    when 'm' then 'main'
    when 'e' then 'extra'
    when 's' then 'staging'
    when 'd' then 'dev'
    when 'i' then 'invalid'
    end
  end

  def stage
    case st
    when 'a' then 'alpha'
    when 'b' then 'beta'
    when 's' then 'stable'
    end
  end

  def device
    case de
    when 'd' then 'desktop'
    when 'm' then 'mobile'
    end
  end

  def tech
    case te
    when 'h' then 'html'
    when 'f' then 'flash'
    end
  end

  def method_missing(method_name)
    self[method_name.to_s]
  end

  private

  def _user_agent
    @_user_agent ||= UserAgentWrapper.new(ua)
  end
end
