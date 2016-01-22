require_dependency "for_admin/application_controller"

module ForAdmin
  class FamiliesController < ApplicationController
    def index
      @families = Family.includes(:leader).
        sort_by { |f| f.leader.barcode.code }
    end

    def show
      @family = Family.find(params[:id])
      @leader = @family.leader
    end

    def edit
      @family = Family.find(params[:id])
    end

    def update
      @family = Family.find(params[:id])
      if @family.update_attributes(family_params)
        flash[:success] = t('view.flash.family_profile_updated')
        redirect_to @family
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
end
