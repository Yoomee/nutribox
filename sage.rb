gateway = ActiveMerchant::Billing::SagePayGateway.new(:login => 'thechildrenshos')

ActiveMerchant::Billing::Base.mode = :test

billing_address = {:address1 => 88, :zip => 412,:city => "London",:country => "UK"}

credit_card = ActiveMerchant::Billing::CreditCard.new(
                :first_name         => 'Bob',
                :last_name          => 'Bobsen',
                :number             => '4929000000006',
                :month              => '8',
                :year               => '2013',
                :verification_value => '123')