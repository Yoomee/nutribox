require 'spec_helper'

describe AvailableOrderOption do
  
  let(:available_order_option) {FactoryGirl.build(:available_order_option)}

  it "should be valid" do
    available_order_option.valid?.should eq(true)
  end
end
