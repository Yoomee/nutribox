class EnquiriesController < ApplicationController
  
  include YmEnquiries::EnquiriesController
  load_and_authorize_resource
  
end