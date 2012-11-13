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
      
      def repeat(money, credit_card, options = {})
        requires!(options, :order_id)
        requires!(options, :related_transaction)
        post = {}

        add_amount(post, money, options)
        add_invoice(post, options)
        #add_credit_card(post, credit_card)
        #add_address(post, options)
        #add_customer_data(post, options)
        
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

