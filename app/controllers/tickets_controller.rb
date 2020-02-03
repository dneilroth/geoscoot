class TicketsController < ApplicationController
  def create
    @scooter = Scooter.find_by(id: params[:scooter_id])

    if @scooter
      @scooter.maintain!(ticket_params)
    else
      render json: {}, status: :not_found
    end
  end

  private def ticket_params
    params.permit(:description)
  end
end
