module UsersHelper

  def user_grammer
    if (@users.count <= 1)
      "#{@users.count}  User Listed"
    else
      "#{@users.count}  Users Listed"
    end
  end

  def member_since(user)
    user.created_at
  end

  def member_since_format(user)
    member_since(user).strftime("%B, %Y")
  end

end
