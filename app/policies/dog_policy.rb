class DogPolicy < ApplicationPolicy
    def index?
        true
    end

    alias show? index?

    def create?
        user&.admin? || user&.manager?
    end

    alias new? create?
    alias update? create?
    alias edit? create?
    alias destroy? create?

    class Scope < Scope
        def resolve
            return scope.all if user&.admin?

            scope.where(user: user)
        end
    end
end
