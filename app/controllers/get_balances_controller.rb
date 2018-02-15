class GetBalancesController < ActionController::API
  def create
    GetBalanceJob.peform_later(params[:team_id], params[:user_id])

    head :ok
  end
end
