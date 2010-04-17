require 'spec_helper'

describe District do
  before(:each) do
    @valid_attributes = {
      :city_id => 1,
      :ine_id => "value for ine_id",
      :name => "value for name",
      :nicename => "value for nicename"
    }
  end

  it "should create a new instance given valid attributes" do
    District.create!(@valid_attributes)
  end
end
