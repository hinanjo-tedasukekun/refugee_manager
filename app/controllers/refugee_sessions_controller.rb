class RefugeeSessionsController < ApplicationController
  def new
  end

  # 避難者番号から避難者を探し、適切なページにリダイレクトする
  # 無効な番号が入力された場合、番号入力画面に戻す
  def create
    refugee_num = params[:session][:refugee_num]
    barcode = RefugeeManager::BarCode.new(refugee_num)
    unless barcode.valid?
      flash.now[:alert] = t('view.flash.invalid_number')
      render 'new'
      return
    end

    refugee = Refugee.find_by(id: barcode.refugee_id)
    if refugee
      refugee_log_in refugee
      redirect_to profile_path
    else
      redirect_to controller: 'profile', action: 'new', num: refugee_num
    end
  end

  def destroy
  end
end
