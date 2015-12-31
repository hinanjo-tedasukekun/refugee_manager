class ProfileController < ApplicationController
  def new
    barcode = RefugeeManager::BarCode.new(params[:num])
    unless barcode.valid?
      flash[:danger] = t('view.flash.invalid_number')
      redirect_to login_path
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
    unless refugee_logged_in?
      redirect_to login_path
      return
    end

    @refugee = current_refugee
    @family = @refugee.family
    @leader = Leader.find_by(family: @family).refugee
  end

  private

  def refugee_create_params
    params.require(:refugee).permit(:id, :name, :furigana)
  end
end
