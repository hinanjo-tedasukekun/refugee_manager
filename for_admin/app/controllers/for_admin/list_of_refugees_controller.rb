require_dependency "for_admin/application_controller"

module ForAdmin
  class ListOfRefugeesController < ApplicationController
    def index
    end

    def all_refugees
      respond_to do |format|
        format.csv do
          send_data(ListOfRefugees.all.encode('Shift_JIS'),
                    type: 'text/csv')
        end
      end
    end

    def refugees_not_at_home
      respond_to do |format|
        format.csv do
          send_data(ListOfRefugees.not_at_home.encode('Shift_JIS'),
                    type: 'text/csv')
        end
      end
    end

    def refugees_at_home
      respond_to do |format|
        format.csv do
          send_data(ListOfRefugees.at_home.encode('Shift_JIS'),
                    type: 'text/csv')
        end
      end
    end
  end
end
