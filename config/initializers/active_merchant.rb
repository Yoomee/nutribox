module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class SagePayGateway < Gateway  
      TRANSACTIONS = {
        :purchase => 'PAYMENT',
        :credit => 'REFUND',
        :authorization => 'DEFERRED',
        :capture => 'RELEASE',
        :void => 'VOID',
        :abort => 'ABORT',
        :repeat => 'REPEAT'
      }
      
      def repeat(money, options = {})
        requires!(options, :order_id)
        requires!(options, :related_transaction)
        post = {}

        add_amount(post, money, options)
        add_invoice(post, options)
        
        # Add related transaction details
        transaction_to_repeat = options[:related_transaction]
        add_pair(post, :RelatedVendorTxCode, transaction_to_repeat[:id])
        add_pair(post, :RelatedVPSTxId, transaction_to_repeat[:vps_transaction_id])
        add_pair(post, :RelatedSecurityKey, transaction_to_repeat[:security_key])
        add_pair(post, :RelatedTxAuthNo, transaction_to_repeat[:transaction_auth_number])
        
        commit(:repeat, post)
      end
      
    end
  end
end

module ActiveMerchant  
  module Billing  
    class CreditCard  
      def persisted?  
        false  
      end  
    end  
  end  
end  

ActiveMerchant::Billing::Base.mode = :test #unless Rails.env.production?