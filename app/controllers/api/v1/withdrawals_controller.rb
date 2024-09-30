class Api::V1::WithdrawalsController < ApplicationController
  include ApiKeyAuthenticatable

  prepend_before_action :authenticate_with_api_key!, only: %i[index show create team_wallet_create]

  def index
    withdrawals = Transaction.where(from_wallet_id: current_bearer.wallet.id, trx_type: "withdrawal")
    render json: withdrawals, status: 200
  end

  def show
    withdrawal = Transaction.find_by(id: params[:id], from_wallet_id: current_bearer.wallet.id, trx_type: "withdrawal")
    render json: withdrawal, status: 200
  end

  def create
    wallet_to = current_bearer.wallet
    withdrawal_amount = withdrawal_params[:amount]
    withdrawal_from_wallet_id = withdrawal_params[:from_wallet_id]
    withdrawal = Transaction.new(
      to_wallet_id: wallet_to.id,
      from_wallet_id: withdrawal_from_wallet_id,
      trx_type: "withdrawal",
      amount: withdrawal_amount
    )
    wallet_from = Wallet.find(withdrawal_from_wallet_id)
    ActiveRecord::Base.transaction do
      withdrawal.save!
      wallet_from.update!(amount: wallet_from.amount - withdrawal_amount.to_i)
      wallet_to.update!(amount: wallet_to.amount + withdrawal_amount.to_i)
    end
    render json: withdrawal, status: 200
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def team_wallet_create
    team = Team.find_by(leader_id: current_bearer.id)
    wallet_from = Wallet.find_by(owner_id: team&.id, wallet_type: "Team")
    wallet_to = current_bearer.wallet
    withdrawal_amount = withdrawal_params[:amount]
    withdrawal = Transaction.new(
      to_wallet_id: wallet_to.id,
      from_wallet_id: wallet_from.id,
      trx_type: "withdrawal",
      amount: withdrawal_amount
    )
    ActiveRecord::Base.transaction do
      withdrawal.save!
      wallet_from.update!(amount: wallet_from.amount - withdrawal_amount.to_i)
      wallet_to.update!(amount: wallet_to.amount + withdrawal_amount.to_i)
    end
    render json: withdrawal, status: 200
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private
  def withdrawal_params
    params.require(:withdrawal).permit([
      :from_wallet_id,
      :amount
    ])
  end
end
