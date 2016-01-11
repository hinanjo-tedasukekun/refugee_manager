class Profile::VulnerabilitiesController < ApplicationController
  before_action :logged_in_refugee, only: %i(edit update)

  def edit
    @refugee = current_refugee
  end

  def update
    @refugee = current_refugee
    @refugee.vulnerability_ids = vulnerabilities_params[:vulnerability_ids]
    if @refugee.save
      flash[:success] = t('view.flash.profile_updated')
      redirect_to profile_path
    else
      render :edit
    end
  end

  private

  def vulnerabilities_params
    params.require(:refugee).permit(vulnerability_ids: [])
  end
end
