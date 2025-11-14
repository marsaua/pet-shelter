class AdoptPolicy < ApplicationPolicy
    def index?   = owner? || user.admin? || user.manager?
    def show?    = owner? || user.admin? || user.manager?
    def create?  = user.present?
    def update?  = user.admin? || user.manager? || owner?
    def destroy? = user.admin? || owner?
    def requests?
        user.admin? || user.adopts.exists?(dog: record)
    end


        class Scope < Scope
            def resolve
              if user.admin?
                scope.all
              else
                scope.where(user: user)
              end
            end
        end
    private
    def owner? = record.user == user
end
