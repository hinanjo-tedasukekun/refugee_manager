class ProfileController < ApplicationController
  before_action :logged_in_refugee, only: %i(show)

  def new
    barcode = RefugeeManager::BarCode.new(params[:num])
    unless barcode.valid?
      redirect_to login_path, alert: t('view.flash.invalid_number')
      return
    end

    @refugee_num = barcode.code
    @refugee = Refugee.new(id: barcode.refugee_id,
                           name: params[:name],
                           furigana: params[:furigana])
  end

  def create
    @refugee = Refugee.new(refugee_create_params)
    @refugee_num = @refugee.barcode.code

    leader_num = params[:leader_num]
    barcode = RefugeeManager::BarCode.new(leader_num)
    leader = Leader.find_by(refugee_id: barcode.refugee_id)
    @refugee.family = leader.try!(:family)

    if @refugee.save
      refugee_log_in(@refugee)
      flash[:success] = t('view.flash.profile_registered')
      redirect_to profile_path
    else
      render :new
    end
  end

  def show
    @refugee = current_refugee
    @family = @refugee.family
    @leader = Leader.find_by(family: @family).refugee
  end

  private

  def refugee_create_params
    params.require(:refugee).permit(:id, :name, :furigana)
  end
end
