require_dependency "for_admin/application_controller"

module ForAdmin
  class ListOfRefugeesController < ApplicationController
    def index
    end

    def all_refugees
      respond_to do |format|
        format.csv do
          render(text: ListOfRefugees.all.encode('Shift_JIS'))
        end
      end
    end

    def refugees_not_at_home
      respond_to do |format|
        format.csv do
          render(text: ListOfRefugees.not_at_home.encode('Shift_JIS'))
        end
      end
    end

    def refugees_at_home
      respond_to do |format|
        format.csv do
          render(text: ListOfRefugees.at_home.encode('Shift_JIS'))
        end
      end
    end
  end
end
