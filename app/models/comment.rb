class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  before_validation :check_user, on: :create
  
  validates :body, presence: true


  def check_user
    self.user ||= User.anonymous
  end
end
