class UpdateUser
  attr_reader :user, :params

  def initialize(user, params={})
    @user = user
    @params = params
  end

  def update
    if needs_password?(user, params)
      @user.update_with_password(params)
    else
      # remove the virtual current_password attribute
      # update_without_password doesn't know how to ignore it
      params.delete(:current_password)
      @user.update_without_password(params)
    end
  end


  private

  # Check if we need password to update user data
  # Need password when updating: email, password
  def needs_password?(user, params)
    user.email != params[:email] || params[:password].present?
  end

end