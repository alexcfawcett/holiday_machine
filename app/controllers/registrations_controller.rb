class RegistrationsController < Devise::RegistrationsController

  def update
    account_update_params = params[:user]
    @user = User.find(current_user.id)

    successfully_updated = if needs_password?(@user, params)
                             @user.update_with_password(account_update_params)
                           else
                             # remove the virtual current_password attribute
                             # update_without_password doesn't know how to ignore it
                             params[:user].delete(:current_password)
                             @user.update_without_password(account_update_params)
                           end

    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case their password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

  private

  # Check if we need password to update user data
  # Need password when updating: email, password
  def needs_password?(user, params)
    user.email != params[:user][:email] ||
        params[:user][:password].present?
  end
end