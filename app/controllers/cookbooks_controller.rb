class CookbooksController < ApplicationController

  respond_to :json

  before_filter :load_project

  def update
    #@project.delay.update_cookbooks
    @project.update_cookbooks
    respond_with @project
  end
end
