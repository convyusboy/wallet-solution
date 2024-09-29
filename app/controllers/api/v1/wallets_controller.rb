class Api::V1::WalletsController < ApplicationController
  include ApiKeyAuthenticatable

  prepend_before_action :authenticate_with_api_key!, only: %i[index show create]

  def index
    wallets = Wallet.where(owner_id: current_bearer.id)
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
    wallet = Wallet.find_by(id: params[:id], owner_id: current_bearer.id)
    if wallet
      render json: wallet, status: 200
    else
      render json: { error: "Wallet is not found or not yours." }
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
