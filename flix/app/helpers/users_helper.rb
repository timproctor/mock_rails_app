module UsersHelper

  def user_grammer
    if (@users.count <= 1)
      "#{@users.count}  User Listed"
    else
      "#{@users.count}  Users Listed"
    end
  end

end
