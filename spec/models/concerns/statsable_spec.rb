require 'spec_helper'

describe Statsable do
  class StatsableModel
    include Mongoid::Document
    include Statsable

    field :t, as: :time, type: Time
    field :key_id
  end
  subject { StatsableModel }

  it { should have_field(:lo).with_alias(:loads).of_type(Hash) }
  it { should have_field(:st).with_alias(:starts).of_type(Hash) }
  it { should have_field(:de).with_alias(:devices).of_type(Hash) }
  it { should have_field(:co).with_alias(:countries).of_type(Hash) }
  it { should have_field(:bp).with_alias(:browser_and_platform).of_type(Hash) }

  describe ".upsert_stats_from_data" do
    let(:key_id) { 'key_id' }
    let(:time) { Time.now.to_i }
    let(:args) { { 'key_id' => key_id, 't' => time.to_s } }
    let(:data) { double('DataHash', source_key: 'w', hostname: 'main') }

    it "precises time to hour" do
      StatsableModel.upsert_stats_from_data(args, :loads, data)
      expect(StatsableModel.last.time).to eq Time.at(time).utc.change(min: 0)
    end

    it "updates existing stat" do
      expect{ StatsableModel.upsert_stats_from_data(args, :loads, data) }
        .to change{StatsableModel.count}.from(0).to(1)
      expect{ StatsableModel.upsert_stats_from_data(args, :loads, data) }
        .to_not change{ StatsableModel.count }
    end

    context "with loads event field" do
      let(:event_field) { :loads }

      context "main external event" do
        before { data.stub(source_key: 'e') }

        it "increments externals loads" do
          StatsableModel.upsert_stats_from_data(args, event_field, data)
          expect(StatsableModel.last.external(:loads)).to eq 1
        end
      end

      context "extra website event" do
        before { data.stub(hostname: 'extra') }

        it "increments externals loads" do
          StatsableModel.upsert_stats_from_data(args, event_field, data)
          expect(StatsableModel.last.website(:loads)).to eq 1
        end
      end

      %w[staging dev invalid].each do |hostname|
        context "#{hostname} website event" do
          before { data.stub(hostname: hostname) }

          it "doesn't increments stat" do
            StatsableModel.upsert_stats_from_data(args, event_field, data)
            expect(StatsableModel.last).to be_nil
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
          StatsableModel.upsert_stats_from_data(args, event_field, data)
          stat = StatsableModel.last
          expect(stat.website(:starts)).to eq 1
          expect(stat.website(:devices)).to eq({'m' => 1})
          expect(stat.website(:countries)).to eq({'ch' => 1})
          expect(stat.website(:browser_and_platform)).to eq({'saf-osx' => 1})
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
          StatsableModel.upsert_stats_from_data(args, event_field, data)
          stat = StatsableModel.last
          expect(stat.external(:starts)).to eq 1
          expect(stat.external(:devices)).to eq({'m' => 1})
          expect(stat.external(:countries)).to eq({'ch' => 1})
          expect(stat.external(:browser_and_platform)).to eq({'saf-osx' => 1})
        end
      end

      %w[staging dev invalid].each do |hostname|
        context "#{hostname} website event" do
          before { data.stub(hostname: hostname) }

          it "doesn't increments stat" do
            StatsableModel.upsert_stats_from_data(args, event_field, data)
            expect(StatsableModel.last).to be_nil
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
        expect(model.website(:loads)).to eq 2
      end
      it "returns website starts" do
        expect(model.website(:starts)).to eq 0
      end
      it "returns website devices" do
        expect(model.website(:devices)).to eq({ 'm' => 3, 'd' => 5 })
      end
      it "returns website countries" do
        expect(model.website(:countries)).to eq({})
      end
      it "returns website browser_and_platform" do
        expect(model.website(:browser_and_platform)).to eq({})
      end
    end
    describe "#external" do
      it "returns external loads" do
        expect(model.external(:loads)).to eq 4
      end
      it "returns external starts" do
        expect(model.external(:starts)).to eq 3
      end
      it "returns external devices" do
        expect(model.external(:devices)).to eq({ 'm' => 5, 'd' => 10 })
      end
      it "returns external countries" do
        expect(model.external(:countries)).to eq({ 'ch' => 5, 'fr' => 10 })
      end
      it "returns external browser_and_platform" do
        expect(model.external(:browser_and_platform)).to eq({})
      end
    end
    describe "#all" do
      it "returns all loads" do
        expect(model.all(:loads)).to eq 6
      end
      it "returns all starts" do
        expect(model.all(:starts)).to eq 3
      end
      it "returns all devices" do
        expect(model.all(:devices)).to eq({ 'm' => 8, 'd' => 15 })
      end
      it "returns all countries" do
        expect(model.all(:countries)).to eq({ 'ch' => 5, 'fr' => 10 })
      end
      it "returns all browser_and_platform" do
        expect(model.all(:browser_and_platform)).to eq({})
      end
    end
  end

end
