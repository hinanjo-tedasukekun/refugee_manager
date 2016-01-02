class Profile::BasicInfoController < ApplicationController
  def edit
    unless refugee_logged_in?
      redirect_to login_path
      return
    end

    @refugee = current_refugee
  end

  def update
    unless refugee_logged_in?
      redirect_to login_path
      return
    end

    @refugee = current_refugee
    new_data = basic_info_params
    @refugee.name = new_data[:name]
    @refugee.furigana = new_data[:furigana]
    @refugee[:gender] = new_data[:gender]
    @refugee.age = new_data[:age]

    if @refugee.save
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
