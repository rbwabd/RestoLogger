class ShowFriendVisitReportsController < ApplicationController
  before_filter :decode_id
  before_filter :authenticate_user!

  def index
    authorize! :index, ShowFriendVisitReport

    #if !params[:visit_report] 
    #  params[:visit_report] = Hash.new
    #end
    # hack to restrict the scope dynamically using a hidden filter
   # params[:visit_report][:user_id] = Hid.enc(current_user.id)
    
    @report = ShowFriendVisitReport.new(params[:visit_report])
    @assets = @report.assets.page(params[:page])
  end
end


