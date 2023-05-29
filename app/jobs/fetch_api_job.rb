class FetchApiJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # If last job was performed more than 15min ago, fetch from api in background
    update_database if check_job_timer
  end

  private

  def update_database
    puts "Fetching recipes from API"
    downloaded_recipies = Recipe.render_all
    downloaded_recipies.each { |recipe|  update_recipe_in_database(recipe) }
    remove_duplicates
    cleanup_database(downloaded_recipies)
    puts "Completed fetching recipes"
    SidekiqLog.create(job_name: "all_recipes_fetch", job_performed: Time.now.utc)
  end

  def update_recipe_in_database(recipe_api)

    update_required = false
    # If downloaded recipe exists in db and db entry is older than api entry update db
    recipe_local = Recipe.find_by(contentful_id: recipe_api.id)
    if recipe_local && (recipe_api.sys[:updated_at] > recipe_local.updated_at)
      puts "Updating recipe: #{recipe_local.title}"
      update_required = true
    # If it doesnt, add recipe to db
    elsif recipe_local.nil?
      recipe_local = Recipe.new
      recipe_local.contentful_id = recipe_api.id
      puts "Creating recipe: #{recipe_local.title}"
      update_required = true
    else
      puts "No db update required."
    end

    if update_required
      recipe_local.title = recipe_api.title.nil? ? "N/A" : recipe_api.title
      recipe_local.description = recipe_api.description.nil? ? "N/A" : recipe_api.description
      recipe_local.chef = recipe_api.chef.nil? ? "N/A" : Recipe.asset_by_id(recipe_api.chef.id).name
      recipe_local.tags = recipe_api.tags.nil? ? [] : recipe_api.tags.map! { |tag| Recipe.asset_by_id(tag.id).name }
      recipe_local.image_url = recipe_api.photo.nil? ? "N/A" : "http:#{recipe_api.photo.url}"
      recipe_local.save
    end


  end

  # Remove all recipies from database that API doesnt have
  def cleanup_database(downloaded_recipies)
    ids = downloaded_recipies.map {|recipe| recipe.id}
    Recipe.all.each do |recipe_local|
      unless ids.include? recipe_local.contentful_id
        puts "Deleting recipe: #{recipe_local.title}"
        recipe_local.destroy
      end
    end
  end

  def check_job_timer()
    time_now_utc = Time.now.utc
    if SidekiqLog.order(job_performed: :desc).first.nil? || ((-((SidekiqLog.order(job_performed: :desc).first.job_performed - Time.now.utc)/60).to_i) > 15)
      puts "Last job was performed more than 15 minutes ago."
      return true
    else
      return false
    end
  end

  def remove_duplicates()
    # If, for some reason, there are duplicated in the database, remove older version
    Recipe.all.each do |recipe|
      num_duplicates = Recipe.where(contentful_id: recipe.contentful_id).length
      if num_duplicates >= 2
        Recipe.where(contentful_id: recipe.contentful_id).order(updated_at: :desc).each_with_index do |dup_recipe, index|
          dup_recipe.destroy if index >= 1
          puts "Removed duplicate for recipe: #{dup_recipe}"
        end
      end
    end
  end

end
