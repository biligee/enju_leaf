module EnjuLeaf
  module ClassMethods
    def enju_leaf
      include EnjuLeaf::InstanceMethods
      include EnjuLeaf::Controller
    end

    private
    def set_error_template
      rescue_from Pundit::NotAuthorizedError, with: :render_403
      #rescue_from ActiveRecord::RecordNotFound, with: :render_404
      rescue_from Errno::ECONNREFUSED, with: :render_500_nosolr
      #rescue_from ActionView::MissingTemplate, with: :render_404_invalid_format
    end
  end

  module Controller
    def self.included(base)
      base.send(:before_filter, :get_library_group, :set_locale, :set_available_languages, :set_mobile_request)
      base.send(:set_error_template)
    end
  end
end
