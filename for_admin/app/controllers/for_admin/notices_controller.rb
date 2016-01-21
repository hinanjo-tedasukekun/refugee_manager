require_dependency "for_admin/application_controller"

module ForAdmin
  class NoticesController < ApplicationController
    def index
      @notices = Notice.order(updated_at: :desc, created_at: :desc)
    end

    def create
      raise NotImplementedError
    end

    def new
      @notice = Notice.new
    end

    def edit
      raise NotImplementedError
    end

    def show
      @notice = Notice.find(params[:id])
    end

    def update
      raise NotImplementedError
    end

    def destroy
      raise NotImplementedError
    end
  end
end
