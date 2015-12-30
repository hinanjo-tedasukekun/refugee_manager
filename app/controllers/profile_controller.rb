class ProfileController < ApplicationController
  def show
    unless refugee_logged_in?
      redirect_to login_path
      return
    end

    @refugee = current_refugee
    @refugee_num = @refugee.barcode.code
  end
end
