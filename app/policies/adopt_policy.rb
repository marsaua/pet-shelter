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
      record.dog.available?
    end
    def new?
      create?
    end

    def requests?
      user.admin? || user.adopts.exists?(dog_id: record.id)
    end

    class Scope < ApplicationPolicy::Scope
      def resolve
        return scope.all if user.admin?
        scope.where(user: user)
      end

      def adoptable_dogs
        scope.joins(:dog).where(dogs: { status: :available })
      end
    end
end
