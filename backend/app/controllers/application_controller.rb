class ApplicationController < ActionController::API
  wrap_parameters false

  include ActionController::Cookies
  include Authentication
end
