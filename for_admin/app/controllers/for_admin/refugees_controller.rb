require_dependency "for_admin/application_controller"

module ForAdmin
  class RefugeesController < ApplicationController
    def index
      @refugees = Refugee.order(:id)
    end

    def show
      @refugee = Refugee.find_by(id: params[:id])

      @family = @refugee.family
      @leader = @family.leader
    end
  end
end
