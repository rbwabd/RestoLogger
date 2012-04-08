class VisitedStoreListReportsController < ApplicationController
  before_filter :decode_id
  before_filter :authenticate_user!

  def index
    authorize! :index, VisitedStoreListReport
    @visited_store_list = current_user.visited_store_list
    if params[:visited_store_list_report] && params[:visited_store_list_report][:store_name]
      params[:visited_store_list_report][:store_name] = '%'+params[:visited_store_list_report][:store_name]+'%'
    end
    params[:visited_store_list_report][:visited_store_list_id] = current_user.visited_store_list.id
    
    p "Test Output-------------"
    p "Test Output-------------"
    p "Test Output-------------"
    p "Test Output-------------"
    p params[:visited_store_list_report]
    p "Test Output-------------"
    p "Test Output-------------"
    p "Test Output-------------"
    p "Test Output-------------"
    @vsl_report = VisitedStoreListReport.new(params[:visited_store_list_report])
    @assets = @vsl_report.assets.page(params[:page])
  end
end


