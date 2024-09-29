class Api::V1::WalletsController < ApplicationController
  def index
    wallets = Wallet.all
    render json: wallets, status: 200
  end

  def create
    wallet = Wallet.new(
      owner_id: wallet_params[:owner_id],
      amount: wallet_params[:amount]
    )
    if wallet.save
      render json: wallet, status: 200
    else
      render json: { error: wallet.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    wallet = Wallet.find(params[:id])
    if wallet
      render json: wallet, status: 200
    else
      render json: { error: "Wallet Not Found." }
    end
  end

  private
  def wallet_params
    params.require(:wallet).permit([
      :owner_id,
      :amount
    ])
  end
end
