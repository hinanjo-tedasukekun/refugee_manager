class Profile::BasicInfoController < ApplicationController
  before_action :logged_in_refugee, only: %i(edit update)

  def edit
    @refugee = current_refugee
  end

  def update
    @refugee = current_refugee
    if @refugee.update_attributes(basic_info_params)
      flash[:success] = t('view.flash.profile_updated')
      redirect_to profile_path
    else
      render 'edit'
    end
  end

  private

  def basic_info_params
    params.require(:refugee).permit(:name, :furigana, :gender, :age)
  end
end
