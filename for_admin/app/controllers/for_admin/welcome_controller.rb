require_dependency "for_admin/application_controller"

module ForAdmin
  class WelcomeController < ApplicationController
    def index
      @shelter = this_shelter

      @num_of_refugees = Family.sum(:num_of_members)
      @num_of_registered_refugees = Refugee.count
      @num_of_present_refugees = Refugee.where(presence: true).count

      @now = Time.now
    end
  end
end
