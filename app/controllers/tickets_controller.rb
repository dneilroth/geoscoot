class TicketsController < ApplicationController
  def create
    @scooter = Scooter.find_by(id: params[:scooter_id])

    if @scooter
      @scooter.maintain!(ticket_params)
      render json: @scooter.tickets.order(created_at: :desc).first
    else
      render json: {}, status: :not_found
    end
  end

  private def ticket_params
    params.permit(:description)
  end
end
