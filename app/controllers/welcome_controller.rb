class WelcomeController < ApplicationController
  def index
    @notices = Notice.order(updated_at: :desc).limit(5)
  end
end
