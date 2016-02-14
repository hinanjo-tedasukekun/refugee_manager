require_dependency "for_admin/application_controller"

module ForAdmin
  class Refugees::BasicInfoController < ApplicationController
    def edit
      @refugee = Refugee.find(params[:id])
    end

    def update
      @refugee = Refugee.find(params[:id])
      if @refugee.update_attributes(basic_info_params)
        flash[:success] = t('view.flash.profile_updated')
        redirect_to @refugee
      else
        render 'edit'
      end
    end

    private

    def basic_info_params
      params.require(:refugee).permit(:name, :furigana, :gender, :age)
    end
  end
end
