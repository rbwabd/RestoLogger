class VisitedStoreListReportsController < ApplicationController
  before_filter :decode_id
  before_filter :authenticate_user!
  load_and_authorize_resource 

  def index
    @vsl_report = VisitedStoreListReport.new(params[:visited_store_list_report])
    @assets = @vsl_report.assets.page(params[:page])
  end
end


