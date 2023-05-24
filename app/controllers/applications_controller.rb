class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    if params[:search].present?
      @pets = Pet.search(params[:search])
    else
      @pets = []
    end
  end

  def new; end

  def create
    application = Application.new(application_params)
    if application.save
      redirect_to "/applications/#{application.id}"
    else
      flash[:alert] = "Error: #{error_message(application.errors)}"
      render :new
    end
  end

  def update
    application = Application.find(params[:id])
      application.status = "Pending"
      application.save
      redirect_to "/applications/#{application.id}"
  end

  private

  def application_params
    params.permit(:name, :address, :city, :state, :zip, :description_why)
  end
end
