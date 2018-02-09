class EventsController < ActionController::API

  def create
    challenge = params[:challenge]

    case params[:type]
    when 'url_verification'
      render json: { challenge: params[:challenge] }
    end
  end
end
