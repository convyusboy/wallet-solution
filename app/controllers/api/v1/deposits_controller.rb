class Api::V1::DepositsController < ApplicationController
  include ApiKeyAuthenticatable

  prepend_before_action :authenticate_with_api_key!, only: %i[index show create]

  def index
    deposits = Transaction.where(from_wallet_id: current_bearer.wallet.id, trx_type: "deposit")
    render json: deposits, status: 200
  end

  def show
    deposit = Transaction.find_by(id: params[:id], from_wallet_id: current_bearer.wallet.id, trx_type: "deposit")
    render json: deposit, status: 200
  end

  def create
    wallet_from = current_bearer.wallet
    deposit_amount = deposit_params[:amount]
    deposit_to_wallet_id = deposit_params[:to_wallet_id]
    deposit = Transaction.new(
      to_wallet_id: deposit_to_wallet_id,
      from_wallet_id: wallet_from.id,
      trx_type: "deposit",
      amount: deposit_amount
    )
    wallet_to = Wallet.find(deposit_to_wallet_id)
    ActiveRecord::Base.transaction do
      deposit.save!
      wallet_from.update!(amount: wallet_from.amount - deposit_amount.to_i)
      wallet_to.update!(amount: wallet_to.amount + deposit_amount.to_i)
    end
    render json: deposit, status: 200
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private
  def deposit_params
    params.require(:deposit).permit([
      :to_wallet_id,
      :amount
    ])
  end
end
