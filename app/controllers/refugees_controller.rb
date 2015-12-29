class RefugeesController < ApplicationController
  include RefugeeSessionsHelper

  # 無効なバーコードであることを表すエラークラス
  class InvalidBarCodeError < StandardError; end

  # 避難者数の合計
  def count
    @num_of_refugees = Family.sum(:num_of_members)
  end

  # 避難者番号入力
  def input_num
    @invalid = params[:invalid]
  end

  # 避難者番号から避難者を探し、適切なページにリダイレクトする
  # 無効な番号が入力された場合、番号入力画面に戻す
  def query
    barcode = RefugeeManager::BarCode.new(params[:refugee_num])
    unless barcode.valid?
      flash[:danger] = t('view.flash.invalid_number')
      redirect_to action: 'input_num'
      return
    end

    refugee = Refugee.find_by(id: barcode.refugee_id)
    if refugee
      if Subdomain::Admin.matches?(request)
        redirect_to refugee
      else
        redirect_to '/profile'
      end
    else
      redirect_to action: 'new', refugee_num: params[:refugee_num]
    end
  end

  # 避難者登録画面
  def new
    @refugee = Refugee.new
    @barcode = RefugeeManager::BarCode.new(params[:refugee_num])
    raise InvalidBarCodeError unless @barcode.valid?
    @refugee.id = @barcode.refugee_id
    @refugee_num = @barcode.code
  end

  # 避難者情報登録処理
  def create
    @refugee = Refugee.new(refugee_create_params)

    leader_num = params.require(:leader_num)
    barcode = RefugeeManager::BarCode.new(leader_num)
    raise InvalidBarCodeError unless barcode.valid?
    leader = Leader.find_by(refugee_id: barcode.refugee_id)
    @refugee.family = leader.try!(:family)

    if @refugee.save!
      flash[:success] = t('view.flash.profile_registered')
      redirect_to @refugee
    else
      render 'new'
    end
  end

  # 避難者情報表示画面
  def show
    @refugee = Refugee.find(params[:id])
    @refugee_num = RefugeeManager::BarCode.from_id(19, @refugee.id).code
  end

  def profile
    redirect_to login_path unless refugee_logged_in?

    @refugee = current_refugee
    @refugee_num = RefugeeManager::BarCode.from_id(19, @refugee.id).code
  end

  # 避難者情報修正画面
  def edit
    @refugee = Refugee.find(params[:id])
    @refugee_num = RefugeeManager::BarCode.from_id(19, @refugee.id).code
  end

  def update
    @refugee = Refugee.find(params[:id])
    if @refugee.update_attributes(refugee_create_params)
      flash[:success] = t('view.flash.profile_updated')
      redirect_to @refugee
    else
      render 'edit'
    end
  end

  def index
    @refugees = Refugee.all
  end

  private

  def refugee_create_params
    params.require(:refugee).permit(:id, :name, :furigana)
  end

  def refugee_update_params
    params.requrie(:refugee).permit(:name, :furigana)
  end
end
