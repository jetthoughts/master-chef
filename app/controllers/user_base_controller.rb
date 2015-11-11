class UserBaseController < ApplicationController
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    raise ActionController::RoutingError.new('Not Found')
  end

end
