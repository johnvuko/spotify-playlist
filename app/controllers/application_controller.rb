class ApplicationController < ActionController::Base
  
  include CurrentUser

  protect_from_forgery with: :exception

end
