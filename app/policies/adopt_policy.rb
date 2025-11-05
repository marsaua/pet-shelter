class AdoptPolicy < ApplicationPolicy
    def index?   = owner? || user.admin? || user.manager?
    def show?    = owner? || user.admin? || user.manager?
    def create?  = user.present?
    def update?  = user.admin? || user.manager? || owner?
    def destroy? = user.admin? || owner?

    private
    def owner? = record.respond_to?(:user_id) && user && record.user_id == user.id
end