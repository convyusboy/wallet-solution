class Api::V1::TransactionsController < ApplicationController
  def index
    transactions = Transaction.all
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
    puts e
    render json: {error: e.record.errors.full_messages}, :status => :unprocessable_entity
  end

  def deposit
    transaction_amount = transaction_params[:amount]
    transaction_to_wallet_id = transaction_params[:to_wallet_id]
    transaction_from_wallet_id = 1
    transaction = Transaction.new(
      to_wallet_id: transaction_to_wallet_id,
      from_wallet_id: transaction_from_wallet_id,
      trx_type: 'deposit',
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
    puts e
    render json: {error: e.record.errors.full_messages}, :status => :unprocessable_entity
  end

  def withdraw
    transaction_amount = transaction_params[:amount]
    transaction_to_wallet_id = 1
    transaction_from_wallet_id = transaction_params[:from_wallet_id]
    transaction = Transaction.new(
      to_wallet_id: transaction_to_wallet_id,
      from_wallet_id: transaction_from_wallet_id,
      trx_type: 'withdraw',
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
    puts e
    render json: {error: e.record.errors.full_messages}, :status => :unprocessable_entity
  end

  def show
    transaction = Transaction.find(params[:id])
    if transaction
      render json: transaction, status: 200
    else
      render json: {error: 'Transaction Not Found.'}
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
