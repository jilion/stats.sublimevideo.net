require 'fast_spec_helper'
require 'config/mongoid'

require 'statsable'

describe Statsable do
  class StatsableModel
    include Mongoid::Document
    include Statsable
  end
  subject { StatsableModel }

  it { should have_field(:lo).with_alias(:loads).of_type(Hash) }
  it { should have_field(:st).with_alias(:starts).of_type(Hash) }
  it { should have_field(:de).with_alias(:devices).of_type(Hash) }
  it { should have_field(:co).with_alias(:countries).of_type(Hash) }
  it { should have_field(:bp).with_alias(:browser_and_platform).of_type(Hash) }

  context "with a model with stats" do
    let(:model) { StatsableModel.new(
      loads: { 'w' => 2, 'e' => 4 },
      starts: { 'e' => 3 },
      devices: { 'w' => { 'm' => 3, 'd' => 5 }, 'e' => { 'm' => 5, 'd' => 10 } },
      countries: { 'e' => { 'ch' => 5, 'fr' => 10 } }
    ) }

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
    end
    describe "#external" do
      it "returns external loads" do
        model.external(:loads).should eq 4
      end
      it "returns website starts" do
        model.external(:starts).should eq 3
      end
      it "returns external devices" do
        model.external(:devices).should eq({ 'm' => 5, 'd' => 10 })
      end
      it "returns website countries" do
        model.external(:countries).should eq({ 'ch' => 5, 'fr' => 10 })
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
    end
  end

end
