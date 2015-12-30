class RefugeeSessionsController < ApplicationController
  def new
  end

  # 避難者番号から避難者を探し、適切なページにリダイレクトする
  # 無効な番号が入力された場合、番号入力画面に戻す
  def create
    barcode = RefugeeManager::BarCode.new(params[:session][:refugee_num])
    unless barcode.valid?
      flash.now[:danger] = t('view.flash.invalid_number')
      render 'new'
      return
    end

    refugee = Refugee.find_by(id: barcode.refugee_id)
    if refugee
      refugee_log_in refugee
      redirect_to profile_path
    else
      raise NotImplementedError
    end
  end

  def destroy
  end
end
