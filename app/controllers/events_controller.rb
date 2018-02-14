class EventsController < ActionController::API

  def create
    challenge = params[:challenge]

    case params[:event][:type]
    when 'url_verification'
      render json: { challenge: params[:challenge] }
    when 'reaction_added'
      ReactionAddedJob.perform_later(
        params[:team_id],
        params[:event][:item_user],
        params[:event][:item][:channel]
      )

      head :ok
    else
      head :ok
    end
  end
end
