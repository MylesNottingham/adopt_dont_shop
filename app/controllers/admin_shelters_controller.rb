class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter
  end
end
