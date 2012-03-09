module ApplicationHelper
  
  # Return a title on a per-page basis.
  def title
    base_title = "RestoLogger"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
    image_tag("logo.jpg", :size => "360x100", :alt => "RestoLogger", :class => "round")
  end
end
