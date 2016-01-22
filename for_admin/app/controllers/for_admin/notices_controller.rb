require_dependency "for_admin/application_controller"

module ForAdmin
  class NoticesController < ApplicationController
    def index
      @notices = Notice.order(updated_at: :desc, created_at: :desc)
    end

    def create
      @notice = Notice.new(notice_params)
      if @notice.save
        flash[:success] = t('view.flash.notice_registered')
        redirect_to notices_path
      else
        render 'new'
      end
    end

    def new
      @notice = Notice.new
    end

    def edit
      @notice = Notice.find(params[:id])
    end

    def show
      @notice = Notice.find(params[:id])
    end

    def update
      @notice = Notice.find(params[:id])
      if @notice.update_attributes(notice_params)
        flash[:success] = t('view.flash.notice_updated')
        redirect_to @notice
      else
        render 'edit'
      end
    end

    def destroy
      @notice = Notice.find(params[:id])
      @notice.destroy
      flash[:success] = t('view.flash.notice_deleted')
      redirect_to notices_path
    end

    private

    def notice_params
      params.require(:notice).permit(:title, :content)
    end
  end
end
