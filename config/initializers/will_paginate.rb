# config/initializers/will_paginate.rb
# https://github.com/mislav/will_paginate/issues/174
# workaround to get will_paginate to work with active_admin
if defined?(WillPaginate)
  module WillPaginate
    module ActiveRecord
      module RelationMethods
        def per(value = nil) per_page(value) end
        def total_count() count end
      end
    end
    module CollectionMethods
      alias_method :num_pages, :total_pages
    end
  end
end