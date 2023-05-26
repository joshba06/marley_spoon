class RecipesController < ApplicationController
  def index
    @recipies = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
  end
end
