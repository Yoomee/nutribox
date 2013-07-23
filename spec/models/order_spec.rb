require 'spec_helper'

describe Order do
  
  describe do
    let(:order) {FactoryGirl.build(:order)}

    describe "shipping week" do
      it "should be set correctly on a thursday" do
        order.created_at = Time.new(2013,7,11,12,0,0)
        order.send(:set_shipping_week)
        order.shipping_week.should eq(2)
      end
    
      it "should be set correctly on a friday" do
        order.created_at = Time.new(2013,7,12,12,0,0)
        order.send(:set_shipping_week)
        order.shipping_week.should eq(3)
      end
    end
  end

  describe do  
    let(:order) do
      FactoryGirl.create(:order).tap do |o|
        o.user = FactoryGirl.build(:user)
        o.set_test_card_details
        o.send(:set_billing_name)
        o.send(:set_amount)
        o.set_billing_address_from_delivery_address
        o.stub!(:order_number).and_return("TEST#{Time.now.to_i}")
      end
    end

    it "should take payment and have the correct number of deliveries paid for" do      
      order.take_payment!
      order.vps_transaction_id.should_not be_blank
      order.number_of_deliveries_paid_for.should eq(order.number_of_deliveries_paid_for_each_billing)
    end
    
    it "should take repeat payment and have the correct number of deliveries paid for" do
      order.take_payment!
      Timecop.travel(Time.now + 30)
      RepeatPayment.any_instance.stub(:order_number).and_return("TESTR#{Time.now.to_i}")
      order.take_repeat_payment!
      order.reload
      order.number_of_deliveries_paid_for.should eq(2 * order.number_of_deliveries_paid_for_each_billing)
    end
  end
  
end
