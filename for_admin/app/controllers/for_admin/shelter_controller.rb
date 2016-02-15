require_dependency "for_admin/application_controller"

module ForAdmin
  class ShelterController < ApplicationController
    def edit
      @shelter = this_shelter
    end

    def update
      @shelter = this_shelter
      if @shelter.update_attributes(shelter_params)
        flash[:success] = t('view.flash.shelter_profile_updated')
        redirect_to root_path
      else
        render 'edit'
      end
    end

    private

    def shelter_params
      params.
        require(:shelter).
        permit(:num, :name, :postal_code, :address)
    end
  end
end
