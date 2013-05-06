require 'useragent'

class UserAgentWrapper

  SUPPORTED_BROWSER = {
    "Firefox"           => "fir",
    "Chrome"            => "chr",
    "Internet Explorer" => "iex",
    "Safari"            => "saf",
    "Android"           => "and",
    "BlackBerry"        => "rim",
    "webOS"             => "weo",
    "Opera"             => "ope"}

  SUPPORTED_PLATEFORM = {
    "Windows"       => "win",
    "Macintosh"     => "osx",
    "iPad"          => "ipa",
    "iPhone"        => "iph",
    "iPod"          => "ipo",
    "Linux"         => "lin",
    "Android"       => "and",
    "BlackBerry"    => "rim",
    "webOS"         => "weo",
    "Windows Phone" => "wip"}

  attr_accessor :user_agent

  def initialize(user_agent)
    @user_agent = UserAgent.parse(user_agent)
  end

  def browser_code
    SUPPORTED_BROWSER[user_agent.browser] || "oth"
  end

  def platform_code
    SUPPORTED_PLATEFORM[user_agent.platform] || (user_agent.mobile? ? "otm" : "otd")
  end

end
