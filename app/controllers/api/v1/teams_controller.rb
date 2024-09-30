class Api::V1::TeamsController < ApplicationController
  include ApiKeyAuthenticatable

  prepend_before_action :authenticate_with_api_key!, only: %i[index show create]

  def index
    teams = Team.all
    render json: teams, status: 200
  end

  def create
    team = Team.new(
      leader_id: team_params[:leader_id],
      name: team_params[:name]
    )
    team.save!
    render json: team, status: 200
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def show
    team = Team.find(params[:id])
    if team
      render json: team, status: 200
    else
      render json: { error: "Team Not Found." }
    end
  end

  private
  def team_params
    params.require(:team).permit([
      :leader_id,
      :name
    ])
  end
end
