class Api::V1::StocksController < ApplicationController
  def index
    stocks = Stock.all
    render json: stocks, status: 200
  end

  def create
    stock = Stock.new(
      amount: stock_params[:amount],
      price: stock_params[:price],
      owner_id: stock_params[:owner_id]
    )
    if stock.save
      render json: stock, status: 200
    else
      render json: { error: "Error creating stock." }
    end
  end

  def show
    stock = Stock.find(params[:id])
    if stock
      render json: stock, status: 200
    else
      render json: { error: "Stock Not Found." }
    end
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
