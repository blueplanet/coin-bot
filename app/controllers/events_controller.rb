class EventsController < ActionController::API

  def create
    challenge = params[:challenge]

    case params[:event][:type]
    when 'url_verification'
      render json: { challenge: params[:challenge] }
    when 'reaction_added'
      ReactionAddedJob.perform_later(
        params[:team_id],
        params[:api_app_id],
        params[:event][:item_user],
        params[:event][:item][:channel]
      )

      head :ok
    else
      head :ok
    end
  end

  private

    def reaction_added_params
      params.permit(
        :team_id, :api_app_id,
        event: [:type, :item_user, item: :channel]
      )
    end
end
