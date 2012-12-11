class XeroLogFormatter < Logger::Formatter
  def call(severity, time, progname, msg)
    "[%s%6s] %s\n" % [time.strftime("%Y-%m-%d %H:%M:%S.") << time.usec.to_s[0..2].rjust(3), severity, msg2str(msg)]
  end
end

class Xero
  
  def self.client
    @@client ||= Xeroizer::PrivateApplication.new(Settings.xero.consumer_key, Settings.xero.consumer_secret, Settings.xero.privatekey_path)
  end
  
  def self.logger
    @@logger ||= begin
      logger = Logger.new(File.join(Rails.root,"log/xero.log"))
      logger.formatter = XeroLogFormatter.new
      logger
    end
  end

end

class Xero
  module Order
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
        Xero.logger.info "Syncing order #{self.id}"   
        sync_user_with_xero
        contact = Xero.client.Contact.find(user.xero_id)
        invoice = Xero.client.Invoice.build(
          :contact => contact,
          :type => "ACCREC",
          :status => "AUTHORISED",
          :date => created_at.to_date,
          :due_date => created_at.to_date,
          :line_amount_types => "Exclusive",
          :invoice_number => (Rails.env.development? ? "dev#{id}" : "NB#{id}")
        )
        invoice.add_line_item(
          :description => product,
          :quantity => 1,
          :unit_amount => amount_ex_vat,
          :tax_amount => vat,
          :account_code => gift? ? "210" : "200",
          :tax_type => "NONE"
        )
        invoice.save
        self.xero_id = invoice.id
        payment = Xero.client.Payment.build(
          :invoice => invoice,
          :account => Xero.client.Account.build(:code => (Rails.env.development? ? '091' : 601)),
          :date => created_at.to_date,
          :amount => amount,
          :reference => "Debit/Credit card",
        )
        payment.save
        self.xero_status = "success"
        Xero.logger.info "Successfully synced #{self.id}"   
        save
      rescue Exception => e
        Xero.logger.error "Failed to sync #{self.id}"   
        Xero.logger.error e.message
        update_attribute(:xero_status,"failed")
      end
    end
    
  end

end