class EventsController < ApplicationController
  def create
    challenge = params[:challenge]

    case params[:type]
    when 'url_verification'
      render json: { challenge: params[:challenge] }
    when 'event_callback'
    end
  end
end
