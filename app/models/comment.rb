class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  validates :body, presence: true
  before_validation :check_user, on: :create


  def check_user
    self.user ||= User.anonymous
  end
end
