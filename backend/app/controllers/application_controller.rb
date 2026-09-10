class ApplicationController < ActionController::API
  wrap_parameters false

  include Authentication
end
