class GetBalancesController < ActionController::API
  def create
    GetBalanceJob.perform_later(params[:team_id], params[:user_id], params[:channel_id])

    head :ok
  end
end
