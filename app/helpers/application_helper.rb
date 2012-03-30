module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"  
    if column == params[:sort]
      css_class = direction == "asc" ? "current #{'asc'}" : "current #{'desc'}"
    end
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end
end
