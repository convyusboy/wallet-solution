class Api::V1::StockPricesController < ApplicationController
  include ApiKeyAuthenticatable

  prepend_before_action :authenticate_with_api_key!, only: %i[price_all price]

  def price_all
    price_all = LatestStockPrice.price_all
    render json: price_all, status: 200
  end

  def prices
    prices = LatestStockPrice.prices
    render json: prices, status: 200
  end

  def price
    price = LatestStockPrice.price(params[:search])
    render json: price, status: 200
  end
end
