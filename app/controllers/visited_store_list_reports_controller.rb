class VisitedStoreListReportsController < ApplicationController
  before_filter :decode_id
  before_filter :authenticate_user!

  def index
    authorize! :index, VisitedStoreListReport
    @visited_store_list = current_user.visited_store_list
    if params[:visited_store_list_report] 
      #add % automatically to allow for substring search - however dunno how to remove them at other end...
      #if params[:visited_store_list_report][:store_name]
        #params[:visited_store_list_report][:store_name] = '%'+params[:visited_store_list_report][:store_name]+'%'
      #end
    else
      params[:visited_store_list_report] = Hash.new
    end
    # hack to restrict the scope dynamically using a hidden filter
    params[:visited_store_list_report][:visited_store_list_id] = current_user.visited_store_list.id
    
    @vsl_report = VisitedStoreListReport.new(params[:visited_store_list_report])
    @assets = @vsl_report.assets.page(params[:page])
  end
end


