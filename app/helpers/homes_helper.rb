module HomesHelper
  def user_name(user)
    user.nickname.gsub(/@.*$/, '').humanize
  end
end
