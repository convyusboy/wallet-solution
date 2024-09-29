class Api::V1::TeamsController < ApplicationController
  def index
    teams = Team.all
    render json: teams, status: 200
  end

  def create
    team = Team.new(
      leader_id: team_params[:leader_id]
    )
    if team.save
      render json: team, status: 200
    else
      render json: { error: "Error creating team." }
    end
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
      :leader_id
    ])
  end
end
