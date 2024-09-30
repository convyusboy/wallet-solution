class Api::V1::TransactionsController < ApplicationController
  include ApiKeyAuthenticatable

  prepend_before_action :authenticate_with_api_key!, only: %i[index show create]

  def index
    wallet = current_bearer.wallet
    transactions = Transaction.where(from_wallet_id: wallet.id)
    render json: transactions, status: 200
  end

  def create
    transaction_amount = transaction_params[:amount]
    transaction_to_wallet_id = transaction_params[:to_wallet_id]
    transaction_from_wallet_id = transaction_params[:from_wallet_id]
    transaction = Transaction.new(
      to_wallet_id: transaction_to_wallet_id,
      from_wallet_id: transaction_from_wallet_id,
      trx_type: transaction_params[:trx_type],
      amount: transaction_amount
    )
    wallet_from = Wallet.find(transaction_from_wallet_id)
    wallet_to = Wallet.find(transaction_to_wallet_id)
    ActiveRecord::Base.transaction do
      transaction.save!
      wallet_from.update!(amount: wallet_from.amount - transaction_amount.to_i)
      wallet_to.update!(amount: wallet_to.amount + transaction_amount.to_i)
    end
    render json: transaction, status: 200
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def show
    transaction = Transaction.find_by(id: params[:id], from_wallet_id: current_bearer.wallet.id)
    if transaction
      render json: transaction, status: 200
    else
      render json: { error: "Transaction is not found or not yours." }
    end
  end

  private
  def transaction_params
    params.require(:transaction).permit([
      :to_wallet_id,
      :from_wallet_id,
      :amount,
      :trx_type
    ])
  end
end
