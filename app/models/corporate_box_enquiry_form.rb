module CorporateBoxEnquiryForm

  include YmEnquiries::EnquiryForm

  title 'The Nutribox Corporate'

  intro ''

  fields :name, :email, :organisation, :phone_number, :message

  validates :message, :presence => { :message => "please tell us what you'd like to know" }
  validates :email, :email => true, :allow_blank => true

  email_from Settings.site_email
  email_subject "An enquiry about a corporate box on #{Settings.site_name}"
  email_to Settings.site_email

  response_message "Thanks a lot for your enquiry, we'll get back to you soon."

end