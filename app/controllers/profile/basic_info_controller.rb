class Profile::BasicInfoController < ApplicationController
  before_action :logged_in_refugee, only: %i(edit update)

  def edit
    @refugee = current_refugee
  end

  def update
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
