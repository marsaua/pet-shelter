class AdoptPolicy < ApplicationPolicy
    def index?
      true
    end

    def show?
      user.admin? || owner?
    end

    alias update? show?
    alias destroy? show?

    def create?
      true
    end

    def requests?
      user.admin? || user.adopts.exists?(dog_id: record.id)
    end

    class Scope < Scope
      def resolve
        return scope.all if user.admin?

        scope.where(user: user)
      end
    end
end
