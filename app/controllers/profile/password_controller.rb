class Profile::PasswordController < ApplicationController
  before_action :logged_in_refugee, only: %i(edit update)

  def edit
    @refugee = current_refugee
  end

  def update
    @refugee = current_refugee
    new_data = password_params
    @refugee.password_protected = new_data[:password_protected]

    if @refugee.password_protected?
      @refugee.password = new_data[:password]
      @refugee.password_confirmation = new_data[:password_confirmation]
    else
      @refugee.password = nil
    end

    # パスワードのバリデーションを有効にして保存する
    # @see http://qiita.com/kadoppe/items/061d137e6022fa099872
    if @refugee.save(context: :change_password)
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
