require 'spec_helper'

describe Statsable do
  class StatsableModel
    include Mongoid::Document
    include Statsable

    field :time, as: :t, type: Time
    field :key_id
  end
  subject { StatsableModel }

  it { should have_field(:lo).with_alias(:loads).of_type(Hash) }
  it { should have_field(:st).with_alias(:starts).of_type(Hash) }
  it { should have_field(:de).with_alias(:devices).of_type(Hash) }
  it { should have_field(:co).with_alias(:countries).of_type(Hash) }
  it { should have_field(:bp).with_alias(:browser_and_platform).of_type(Hash) }

  describe ".inc_stats" do
    let(:key_id) { 'key_id' }
    let(:time) { Time.now.to_i }
    let(:args) { { key_id: key_id, time: time } }
    let(:data) { double('DataHash', source_key: 'w', hostname: 'main') }

    it "precises time to hour" do
      StatsableModel.inc_stats(args, :loads, data)
      StatsableModel.last.time.should eq Time.at(time).utc.change(min: 0)
    end

    it "updates existing stat" do
      expect{ StatsableModel.inc_stats(args, :loads, data) }
        .to change{StatsableModel.count}.from(0).to(1)
      expect{ StatsableModel.inc_stats(args, :loads, data) }
        .to_not change{ StatsableModel.count }
    end

    context "with loads event field" do
      let(:event_field) { :loads }

      context "main external event" do
        before { data.stub(source_key: 'e') }

        it "increments externals loads" do
          StatsableModel.inc_stats(args, event_field, data)
          StatsableModel.last.external(:loads).should eq 1
        end
      end

      context "extra website event" do
        before { data.stub(hostname: 'extra') }

        it "increments externals loads" do
          StatsableModel.inc_stats(args, event_field, data)
          StatsableModel.last.website(:loads).should eq 1
        end
      end

      %w[staging dev invalid].each do |hostname|
        context "#{hostname} website event" do
          before { data.stub(hostname: hostname) }

          it "doesn't increments stat" do
            StatsableModel.inc_stats(args, event_field, data)
            StatsableModel.last.should be_nil
          end
        end
      end
    end

    context "with starts event field" do
      let(:event_field) { :starts }

      context "main website event" do
        before {
          data.stub(de: 'm')
          data.stub(country_code: 'ch')
          data.stub(browser_code: 'saf')
          data.stub(platform_code: 'osx')
        }

        it "increments website stats" do
          StatsableModel.inc_stats(args, event_field, data)
          stat = StatsableModel.last
          stat.website(:starts).should eq 1
          stat.website(:devices).should eq({'m' => 1})
          stat.website(:countries).should eq({'ch' => 1})
          stat.website(:browser_and_platform).should eq({'saf-osx' => 1})
        end
      end

      context "extra external event" do
        before {
          data.stub(hostname: 'extra')
          data.stub(source_key: 'e')
          data.stub(de: 'm')
          data.stub(country_code: 'ch')
          data.stub(browser_code: 'saf')
          data.stub(platform_code: 'osx')
        }

        it "increments website stats" do
          StatsableModel.inc_stats(args, event_field, data)
          stat = StatsableModel.last
          stat.external(:starts).should eq 1
          stat.external(:devices).should eq({'m' => 1})
          stat.external(:countries).should eq({'ch' => 1})
          stat.external(:browser_and_platform).should eq({'saf-osx' => 1})
        end
      end

      %w[staging dev invalid].each do |hostname|
        context "#{hostname} website event" do
          before { data.stub(hostname: hostname) }

          it "doesn't increments stat" do
            StatsableModel.inc_stats(args, event_field, data)
            StatsableModel.last.should be_nil
          end
        end
      end
    end
  end

  context "with a model with stats" do
    let(:model) { StatsableModel.new(
      loads: { 'w' => 2, 'e' => 4 },
      starts: { 'e' => 3 },
      devices: { 'w' => { 'm' => 3, 'd' => 5 }, 'e' => { 'm' => 5, 'd' => 10 } },
      countries: { 'e' => { 'ch' => 5, 'fr' => 10 } })
    }

    describe "#website" do
      it "returns website loads" do
        model.website(:loads).should eq 2
      end
      it "returns website starts" do
        model.website(:starts).should eq 0
      end
      it "returns website devices" do
        model.website(:devices).should eq({ 'm' => 3, 'd' => 5 })
      end
      it "returns website countries" do
        model.website(:countries).should eq({})
      end
      it "returns website browser_and_platform" do
        model.website(:browser_and_platform).should eq({})
      end
    end
    describe "#external" do
      it "returns external loads" do
        model.external(:loads).should eq 4
      end
      it "returns external starts" do
        model.external(:starts).should eq 3
      end
      it "returns external devices" do
        model.external(:devices).should eq({ 'm' => 5, 'd' => 10 })
      end
      it "returns external countries" do
        model.external(:countries).should eq({ 'ch' => 5, 'fr' => 10 })
      end
      it "returns external browser_and_platform" do
        model.external(:browser_and_platform).should eq({})
      end
    end
    describe "#all" do
      it "returns all loads" do
        model.all(:loads).should eq 6
      end
      it "returns all starts" do
        model.all(:starts).should eq 3
      end
      it "returns all devices" do
        model.all(:devices).should eq({ 'm' => 8, 'd' => 15 })
      end
      it "returns all countries" do
        model.all(:countries).should eq({ 'ch' => 5, 'fr' => 10 })
      end
      it "returns all browser_and_platform" do
        model.all(:browser_and_platform).should eq({})
      end
    end
  end

end
