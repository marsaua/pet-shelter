class VolunteerPolicy < ApplicationPolicy
    def index?
      true
    end

    alias show? index?
    alias create? index?
    alias update? index?
    alias destroy? index?

    class Scope < Scope
      def resolve
        return scope.all if user&.admin? || user&.manager?

        scope.where(user_id: user&.id)
      end
    end
end
