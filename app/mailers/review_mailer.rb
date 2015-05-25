class ReviewMailer < ApplicationMailer
  def review_created_email review
    @review = review
    mail to: administrators
  end

  private
  def administrators
    Role.find_by(name: RoleAdmin).users.pluck(:email)
  end
end
