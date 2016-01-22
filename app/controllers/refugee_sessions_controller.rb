class RefugeeSessionsController < ApplicationController
  def new
    session[:auth_refugee_num] = nil
  end

  # 避難者番号から避難者を探し、適切なページにリダイレクトする
  # 無効な番号が入力された場合、番号入力画面に戻す
  def create
    refugee_num = params[:session][:refugee_num]
    barcode = Barcode.new(code: refugee_num)
    unless barcode.valid?
      flash.now[:alert] = t('view.flash.invalid_number')
      render 'new'
      return
    end

    refugee = Refugee.find_by(id: barcode.refugee_id)
    if refugee
      if refugee.password_protected?
        session[:auth_refugee_num] = refugee.barcode.code
        redirect_to authenticate_path
      else
        refugee_log_in refugee
        redirect_to profile_path
      end
    else
      redirect_to controller: 'profile', action: 'new', num: refugee_num
    end
  end

  def authenticate
    refugee_num = session[:auth_refugee_num]
    barcode = Barcode.new(code: refugee_num)
    unless barcode.valid?
      flash[:alert] = t('view.flash.invalid_number')
      redirect_to login_path
      return
    end

    @refugee = Refugee.find_by(id: barcode.refugee_id)
  end

  def do_authenticate
    @refugee = Refugee.find_by(id: params[:refugee][:id])
    if @refugee.authenticate(params[:refugee][:password])
      session[:auth_refugee_num] = nil
      refugee_log_in @refugee
      redirect_to profile_path
    else
      flash.now[:alert] = t('view.flash.password_not_match')
      render 'authenticate'
    end
  end

  def destroy
    refugee_log_out
    redirect_to root_url
  end
end
