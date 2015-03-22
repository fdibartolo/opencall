# Preview all emails at http://localhost:3000/rails/mailers/role_mailer
class RoleMailerPreview < ActionMailer::Preview
  def create
    RoleMailer.role_created_email(User.first, RoleReviewer)
  end
end
