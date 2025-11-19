class CommentPolicy < ApplicationPolicy
    def create?
       true
    end

    def destroy?
       admin? || owner?
    end

    class Scope < Scope
      def resolve
        if user&.admin? || user&.manager?
          scope.all
        else
          scope.where(user_id: user&.id)
        end
      end
    end

    private
    def owner? = record.respond_to?(:user_id) && user && record.user_id == user.id
end
