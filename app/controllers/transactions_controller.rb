class TransactionsController < ApplicationController
  before_action :user_info_require

  def new
    @from_user = SlackUser.find(params[:from_user_id])
    @to_user = SlackUser.find(params[:to_user_id])
  end

  private

    def user_info_require
      redirect_to root_path if params[:from_user_id].blank? || params[:to_user_id].blank?
    end
end
