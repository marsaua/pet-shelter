class DogPolicy < ApplicationPolicy
    def index?   = true
    def show?    = true

    def create? = admin_or_manager?
    def new?     = create?

    def update?  = admin_or_manager?
    def edit?    = update?
    def destroy? = admin_or_manager?


    def admin_or_manager?
    user && (user.admin? || user.manager?)
    end

    class Scope < Scope
        def resolve
            scope.all
        end
    end
end
