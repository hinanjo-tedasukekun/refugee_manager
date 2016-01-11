class Profile::SuppliesController < ApplicationController
  before_action :logged_in_refugee, only: %i(edit update)

  def edit
    @refugee = current_refugee
  end

  def update
    @refugee = current_refugee
    @refugee.supply_ids = supplies_params[:supply_ids]
    if @refugee.save
      flash[:success] = t('view.flash.profile_updated')
      redirect_to profile_path
    else
      render :edit
    end
  end

  private

  def supplies_params
    params.require(:refugee).permit(supply_ids: [])
  end
end
