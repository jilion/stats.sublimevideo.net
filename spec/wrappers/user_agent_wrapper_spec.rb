require 'fast_spec_helper'

require 'user_agent_wrapper'

describe UserAgentWrapper do
  subject { UserAgentWrapper.new(user_agent) }

  context "Safari / OS X user agent" do
    let(:user_agent) { "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_8; de-at) AppleWebKit/533.21.1 (KHTML, like Gecko) Version/5.0.5 Safari/533.21.1" }

    its(:browser_code) { should eq 'saf' }
    its(:platform_code) { should eq 'osx' }
  end

  context "Firefox / Linux user agent" do
    let(:user_agent) { "Mozilla/5.0 (X11; U; Linux amd64; rv:5.0) Gecko/20100101 Firefox/5.0 (Debian)" }

    its(:browser_code) { should eq 'fir' }
    its(:platform_code) { should eq 'lin' }
  end

  context "not supported mobile user agent" do
    let(:user_agent) { "Opera/9.80 (J2ME/MIDP; Opera Mini/9.80 (J2ME/23.377; U; en) Presto/2.5.25 Version/10.54" }

    its(:browser_code) { should eq 'oth' }
    its(:platform_code) { should eq 'otm' }
  end
end

