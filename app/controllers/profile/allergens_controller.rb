class Profile::AllergensController < ApplicationController
  before_action :logged_in_refugee, only: %i(edit update)

  def edit
    @refugee = current_refugee
  end

  def update
    @refugee = current_refugee
    @refugee.allergen_ids = allergens_params[:allergen_ids]
    if @refugee.save
      flash[:success] = t('view.flash.profile_updated')
      redirect_to profile_path
    else
      render :edit
    end
  end

  private

  def allergens_params
    params.require(:refugee).permit(allergen_ids: [])
  end
end