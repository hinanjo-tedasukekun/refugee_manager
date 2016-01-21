class FamilyController < ApplicationController
  before_action :logged_in_refugee, only: %i(show edit update)

  def show
    @refugee = current_refugee
    @family = @refugee.family
    @leader = Leader.find_by(family: @family).refugee
  end

  def edit
    @refugee = current_refugee
    @family = @refugee.family
  end

  def update
    @refugee = current_refugee
    @family = @refugee.family

    if @family.update_attributes(family_params)
      flash[:success] = t('view.flash.family_profile_updated')
      redirect_to family_path
    else
      render 'edit'
    end
  end

  private

  def family_params
    params.
      require(:family).
      permit(:num_of_members, :postal_code, :address, :at_home)
  end
end
