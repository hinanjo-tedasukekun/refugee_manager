class RefugeesController < ApplicationController
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
      redirect_to action: 'input_num', invalid: true
      return
    end

    refugee = Refugee.find_by(id: barcode.refugee_id)
    if refugee
      redirect_to refugee
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
    @refugee = Refugee.new(
      params.require(%i(refugee)).permit(%i(name furigana))
    )
  end

  # 避難者情報表示画面
  def show
    @refugee = Refugee.find(params[:id])
    @refugee_num = RefugeeManager::BarCode.from_id(19, @refugee.id).code
  end

  # 避難者情報修正画面
  def edit
    @refugee = Refugee.find(params[:id])
    @refugee_num = RefugeeManager::BarCode.from_id(19, @refugee.id).code
  end

  def index
    redirect_to root_path
  end
end
