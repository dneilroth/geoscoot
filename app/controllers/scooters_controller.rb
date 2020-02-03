class ScootersController < ApplicationController
  def update
    @scooter = Scooter.find_by(id: params[:id])

    if @scooter
      battery = update_params[:battery]&.to_i

      if battery && (battery < 0 || battery > 100)
        return render json: {}, status: :bad_request
      end

      @scooter.update_data!(update_params)
      render json: @scooter
    else
      render json: {}, status: :not_found
    end
  end

  def bulk_unlock
    @scooters = Scooter.where(
      id: params[:ids].split(',').map(&:to_i),
      state: Scooter::STATE_LOCKED
    )

    if @scooters.present?
      @scooters.each(&:unlock!)
      render json: @scooters.map(&:id)
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

  def index
    @scooters = Scooter.includes(:transitions).all

    if @scooters.present?
      render json: @scooters, include: [:transitions]
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
