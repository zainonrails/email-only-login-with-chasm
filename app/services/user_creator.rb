class UserCreator
  def call(email)
    user = User.find_by(email: email)

    unless user
      user = User.new(email: email)
      user.save
    end

    user
  end
end
