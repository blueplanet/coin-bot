class SlackUsersController < ActionController::API

  def create
    RegisterAddressJob.perform_later(params[:team_id], params[:user_id], params[:text], params[:channel_id])

    head :ok
  end
end
