class Xero
  
  def self.client
    @@client ||= Xeroizer::PrivateApplication.new(Settings.xero.consumer_key, Settings.xero.consumer_secret, Settings.xero.privatekey_path)
  end

end

class Xero
  module Order
  
    def self.included(base)
      #base.after_create :sync_with_xero
    end
    
    private
    def sync_user_with_xero
      return true if user.xero_id.present?
      contact = Xero.client.Contact.build(
        :name => user.full_name,
        :email_address => user.email,
        :updated_date_utc => updated_at
      )
      contact.add_address(
        :type => 'STREET',
        :line1 => billing_address1,
        :line2 => billing_address2,
        :city => billing_city,
        :postal_code => billing_postcode,
        :country => billing_country
      )
      contact.save
      user.update_attribute(:xero_id, contact.id)
    end
    
    def sync_with_xero
      begin        
        sync_user_with_xero
        contact = Xero.client.Contact.find(user.xero_id)
        invoice = Xero.client.Invoice.build(
          :contact => contact,
          :type => "ACCREC",
          :status => "AUTHORISED",
          :date => created_at.to_date,
          :due_date => created_at.to_date,
          :line_amount_types => "Exclusive",
          :invoice_number => (Rails.env.development? ? "dev#{id}" : id)
        )
        invoice.add_line_item(
          :description => product,
          :quantity => 1,
          :unit_amount => amount_ex_vat,
          :tax_amount => vat,
          :account_code => "200",
          :tax_type => "OUTPUT2"
        )
        invoice.save
        self.xero_id = invoice.id
        payment = Xero.client.Payment.build(
          :invoice => invoice,
          :account => Xero.client.Account.build(:code => (Rails.env.development? ? '091' : 600)),
          :date => created_at.to_date,
          :amount => amount,
          :reference => "Debit/Credit card",
        )
        payment.save
        save
      rescue Exception => e
        puts e.message
      end
    end
    
  end

end