class CommentPolicy < ApplicationPolicy
    def create?
       true
    end

    def destroy?
       user&.admin? || owner?
    end
end
