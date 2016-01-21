class NoticesController < ApplicationController
  def index
    @notices = Notice.order(updated_at: :desc, created_at: :desc)
  end

  def show
    @notice = Notice.find(params[:id])
  end
end
