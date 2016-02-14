require_dependency "for_admin/application_controller"

module ForAdmin
  class Refugees::PasswordController < ApplicationController
    def edit
      @refugee = Refugee.find(params[:id])
    end

    def update
      @refugee = Refugee.find(params[:id])
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
        redirect_to @refugee
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
end
