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
    when 'message'
      if params[:event][:text].start_with?("#{ENV['SLACK_BOT_USER_ID']} ")
        SlackCommandJob.perform_later(
          params[:team_id],
          params[:event][:user],
          params[:event][:channel],
          params[:event][:text]
        )
      end

      head :ok
    else
      head :ok
    end
  end
end
