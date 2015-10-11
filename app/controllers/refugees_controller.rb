class RefugeesController < ApplicationController
  def count
    @num_of_refugees = Family.sum(:num_of_members)
  end
end
