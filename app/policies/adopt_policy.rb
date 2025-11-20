class AdoptPolicy < ApplicationPolicy
    def index?
      true
    end

    def show?
      return false unless user
      user.admin? || owner?
    end

    alias update? show?
    alias destroy? show?

    def create?
      true
    end

    def requests?
      return false unless user
      user.admin? || user.adopts.exists?(dog_id: record.id) rescue user.admin?
    end

    class Scope < Scope
      def resolve
        if user&.admin?
          scope.all
        else
          scope.where(user: user)
        end
      end
    end
end
