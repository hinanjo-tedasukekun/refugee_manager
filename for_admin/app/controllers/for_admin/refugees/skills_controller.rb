require_dependency "for_admin/application_controller"

module ForAdmin
  class Refugees::SkillsController < ApplicationController
    def edit
      @refugee = Refugee.find(params[:id])
    end

    def update
      @refugee = Refugee.find(params[:id])
      if @refugee.update_attributes(skills_params)
        flash[:success] = t('view.flash.profile_updated')
        redirect_to @refugee
      else
        render :edit
      end
    end

    private

    def skills_params
      params.require(:refugee).permit(skill_ids: [])
    end
  end
end
