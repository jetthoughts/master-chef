class CookbooksController < UserBaseController

  respond_to :json

  before_filter :load_project

  def update
    @project.delay.update_cookbooks!
    respond_with @project do |format|
      format.json { head :ok }
    end
  end
end
