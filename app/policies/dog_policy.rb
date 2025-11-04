class DogPolicy < ApplicationPolicy
    def index?   = true
    def show?    = true

    def create? = user.admin? || user.manager?
    def new?     = create?

    def update?  = user.admin? || user.manager?
    def edit?    = update?
    def destroy? = user.admin?

end