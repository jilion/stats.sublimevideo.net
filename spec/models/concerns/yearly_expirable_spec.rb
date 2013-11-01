require 'fast_spec_helper'
require 'config/mongoid'

require 'yearly_expirable'

describe YearlyExpirable do
  class YearlyExpirableModel
    include Mongoid::Document
    include YearlyExpirable
    field :time, as: :t, type: Time
  end
  subject { YearlyExpirableModel }

  it { should have_index_for(t: 1).with_options(expireAfterSeconds: 31644000) }
  it { should have_index_for(t: 1).with_options(background: true) }
end
