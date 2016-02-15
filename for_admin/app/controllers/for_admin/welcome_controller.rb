require_dependency "for_admin/application_controller"

module ForAdmin
  class WelcomeController < ApplicationController
    def index
      @shelter = this_shelter
    end
  end
end
