require 'spec_helper'

describe Date do
  
  describe "shipping_week" do
  
    it "should be correct on a Thursday" do
      date = Date.new(2013,7,11)
      date.shipping_week.should eq(2)
    end
    
    it "should be correct on a Friday" do
      date = Date.new(2013,7,12)
      date.shipping_week.should eq(3)
    end
    
    it "should be correct on the first day of the month (Monday)" do
      date = Date.new(2013,7,1)
      date.shipping_week.should eq(1)
    end
    
    it "should be correct on the first day of the month (Thursday)" do
      date = Date.new(2013,8,1)
      date.shipping_week.should eq(1)
    end
    
    it "should be correct on the first day of the month (Friday)" do
      date = Date.new(2013,11,1)
      date.shipping_week.should eq(2)
    end
    
    it "should be correct on the last day of the month (Monday)" do
      date = Date.new(2013,9,30)
      date.shipping_week.should eq(1)
    end
    
    it "should be correct on the last day of the month (Thursday)" do
      date = Date.new(2013,10,31)
      date.shipping_week.should eq(1)
    end
    
    it "should be correct on the last day of the month (Friday)" do
      date = Date.new(2013,5,31)
      date.shipping_week.should eq(1)
    end
    
    it "should be correct on the fifth Monday in a month" do
      date = Date.new(2013,4,29)
      date.shipping_week.should eq(1)
    end
    
    it "should be correct on the fifth Thursday in a month" do
      date = Date.new(2013,1,31)
      date.shipping_week.should eq(1)
    end
    
    it "should be correct on the fifth Friday in a month" do
      date = Date.new(2013,3,29)
      date.shipping_week.should eq(1)
    end
    
    it "should be correct when there are five Fridays in a month" do
      date = Date.new(2013,8,26)
      date.shipping_week.should eq(5)
    end
    
  end
  
  describe "five_fridays_in_month?" do
    
    it "should be true when there are five Fridays" do
      date = Date.new(2013,11,13)
      date.five_fridays_in_month?.should be_true
    end
    
    it "should be false when there are four Fridays" do
      date = Date.new(2013,7,26)
      date.five_fridays_in_month?.should be_false
    end
    
  end
    
end