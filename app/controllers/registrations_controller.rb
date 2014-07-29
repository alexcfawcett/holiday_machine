class RegistrationsController < Devise::RegistrationsController

  def update
    @user = User.find(current_user.id)
    user_updater = UpdateUser.new(@user, params[:user])

    if user_updater.update
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case their password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end


  protected

  def after_inactive_sign_up_path_for(resource)
    sign_in_path
  end
end