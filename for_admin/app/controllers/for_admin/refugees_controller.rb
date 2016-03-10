require_dependency "for_admin/application_controller"

module ForAdmin
  class RefugeesController < ApplicationController
    def index
      respond_to do |format|
        format.html do
          @refugees = Refugee.
            includes(:family).
            order(:family_id, :id)
        end

        format.csv do
          render(text: ListOfRefugees.to_csv.encode('Shift_JIS'))
        end
      end
    end

    def show
      @refugee = Refugee.find(params[:id])

      @family = @refugee.family
      @leader = @family.leader
    end
  end
end
