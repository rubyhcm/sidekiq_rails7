class Api::V1::TeamsController < ApplicationController
  def index
    teams = Team.select(:id, :name, :rating)
    render json: { data: teams }
  end

  def show
    team = Team.where(id: team_params[:id]).select(:id, :name, :rating)
    BuyTimeWorker.perform_async(team.first.name, team.first.rating)
    render json: { data: team }
  end

  private

  def team_params
    params.permit(:id)
  end
end
