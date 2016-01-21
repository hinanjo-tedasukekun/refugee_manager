class FamilyController < ApplicationController
  before_action :logged_in_refugee, only: %i(show edit update)

  def show
    @refugee = current_refugee
    @family = @refugee.family
    @leader = Leader.find_by(family: @family).refugee
  end

  def edit
    @refugee = current_refugee
    @family = @refugee.family
  end

  def update
  end
end
