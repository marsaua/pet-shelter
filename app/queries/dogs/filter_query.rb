module Dogs
  class FilterQuery < Patterns::Query
    queries Dog

    private

    def query
      scope = relation.recent_with_avatar_scope
      scope = hide_dogs_under_treatment_for_user(scope)
      scope = apply_ransack_search(scope)
      scope = scope.with_attached_avatar
      scope.page(options[:page]).per(per_page)
    end

    def apply_ransack_search(scope)
      return scope if search_params.blank?

      search = scope.ransack(search_params)
      search.result(distinct: true)
    end

    def search_params
      options[:search_params]
    end

    def per_page
      options[:per_page] || 3
    end

    def current_user
      options[:current_user]
    end

    def hide_dogs_under_treatment_for_user(scope)
      scope = if current_user.role == "user"
        scope.where.not(health_status: "under_treatment")
      else
        scope
      end
    end
  end
end
