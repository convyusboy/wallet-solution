class Api::V1::StocksController < ApplicationController
  include ApiKeyAuthenticatable

  prepend_before_action :authenticate_with_api_key!, only: %i[index sell]

  def index
    stock = current_bearer.stock
    render json: stock, status: 200
  end

  def price_all
    price_all = LatestStockPrice.price_all
    render json: price_all, status: 200
  end

  def sell
    stock = current_bearer.stock
    wallet = current_bearer.wallet
    stock_amount = stock_params[:amount]
    ActiveRecord::Base.transaction do
      stock.update!(amount: stock.amount - stock_amount.to_i)
      wallet.update!(amount: wallet.amount + stock_amount.to_i * stock.price)
    end
    render json: stock, status: 200
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private
  def stock_params
    params.require(:stock).permit([
      :amount,
      :price,
      :owner_id
    ])
  end
end
