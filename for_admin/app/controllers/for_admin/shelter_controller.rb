require_dependency "for_admin/application_controller"

module ForAdmin
  class ShelterController < ApplicationController
    def show
      unless params[:format] == 'json'
        redirect_to root_path, status: :moved_permanently
      end

      @shelter = this_shelter
      @num_of_refugees = Family.sum(:num_of_members)
      @num_of_registered_refugees = Refugee.count
      @num_of_present_refugees = Refugee.where(presence: true).count
      @timestamp = DateTime.now.xmlschema
    end

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
