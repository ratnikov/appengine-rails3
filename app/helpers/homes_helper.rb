module HomesHelper
  def author_name(comment)
    if user = comment.user
      user.nickname.gsub(/@.*$/, '').humanize
    else
      'Someone'
    end
  end
end
