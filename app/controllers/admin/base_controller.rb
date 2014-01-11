class Admin::BaseController < ApplicationController
  before_filter :authenticate_admin_user!
end
