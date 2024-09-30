class Api::V1::WalletsController < ApplicationController
  include ApiKeyAuthenticatable

  prepend_before_action :authenticate_with_api_key!, only: %i[index team_wallet_index]

  def index
    wallet = Wallet.find_by(owner_id: current_bearer.id, wallet_type: "User")
    render json: wallet, status: 200
  end

  def team_wallet_index
    team = Team.find_by(leader_id: current_bearer.id)
    wallet = Wallet.find_by(owner_id: team&.id, wallet_type: "Team")
    if wallet
      render json: wallet, status: 200
    else
      render error: { error: "Team wallet not found" }, status: :unprocessable_entity
    end
  end
end
