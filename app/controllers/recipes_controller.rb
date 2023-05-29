class RecipesController < ApplicationController
  before_action :update_recipes

  def index
    @recipies = Recipe.all


  end

  def show
    @recipe = Recipe.find(params[:id])
    if /youtube.com\/watch\?v=\w+\)/.match(@recipe.description)
      @video_id = /youtube.com\/watch\?v=\w+\)/.match(@recipe.description)[0].split("=").last.split(")").first
      subtract_string = /\[VIDEO]\(https:\/\/www.youtube.com\/watch?\?v=\w+\)/.match(@recipe.description)[0]
      @recipe.description.slice! subtract_string
    end

  end

  private

  def update_recipes
    @time_last_recipe_update = SidekiqLog.order(job_performed: :desc).first.nil? ? "Never" : ( -((SidekiqLog.order(job_performed: :desc).first.job_performed - Time.now.utc)/60).to_i)
    FetchApiJob.perform_later
  end
end
