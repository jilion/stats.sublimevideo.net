require 'spec_helper'

describe SiteAdminStat do
  it { should be_kind_of Mongoid::Document }
  it { should be_kind_of SiteIdentifiable }

  it { should have_field(:al).with_alias(:app_loads).of_type(Hash) }
  it { should have_field(:st).with_alias(:stage).of_type(Array) }
  it { should have_field(:ss).with_alias(:ssl).of_type(Mongoid::Boolean) }
end
