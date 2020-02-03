class ScootersController < ApplicationController
  def update
    @scooter = Scooter.find_by(id: params[:id])

    if @scooter
      @scooter.update_data!(update_params)
    else
      render json: {}, status: :not_found
    end
  end

  def bulk_unlock
    @scooters = Scooter.where(id: params[:ids], state: 'locked')

    if @scooters.present?
      @scooters.each(&:unlock!)
    else
      render json: {}, status: :not_found
    end
  end

  def active
    @scooters = Scooter.find_active_scooters_within_kilometers(
      active_params[:lon],
      active_params[:lat],
      active_params[:radius].to_i
    )

    if @scooters.present?
      render json: @scooters
    else
      render json: {}, status: :not_found
    end
  end

  private def update_params
    params.permit(:lon, :lat, :battery)
  end

  private def active_params
    params.permit(:lon, :lat, :radius)
  end
end
