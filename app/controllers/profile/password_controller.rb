class Profile::PasswordController < ApplicationController
  def edit
    unless refugee_logged_in?
      redirect_to login_path
      return
    end

    @refugee = current_refugee
  end

  def update
    unless refugee_logged_in?
      redirect_to login_path
      return
    end

    @refugee = current_refugee
    new_data = password_params
    @refugee.password_protected = new_data[:password_protected]

    if @refugee.password_protected?
      @refugee.password = new_data[:password]
      @refugee.password_confirmation = new_data[:password_confirmation]
    else
      @refugee.password = nil
    end

    if @refugee.save
      flash[:success] = t('view.flash.profile_updated')
      redirect_to profile_path
    else
      render 'edit'
    end
  end

  private

  def password_params
    params.
      require(:refugee).
      permit(:password_protected, :password, :password_confirmation)
  end
end
