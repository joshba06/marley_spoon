# About

<h1>The task:</h1>
Fetch recipes from the contentful API and display an index page (all recipes, i.e. title and image) as well as a show page.

<h1>My approach:</h1>
To limit the number of API requests made by the website, I implemented logic that loads all content from the API (sidekiq) every 15 minutes, only if someone visits the website. Moreover, during database updates, the "last modified" field of recipes in the API response is checked and only if it is more recent than the one previously recorded, that recipe is updated in the database. The idea behind this approach was to save time by only reading from the database, instead of updating all fields of all recipes that exist in the database and API everytime.
Furthermore, since this is supposed to be a backend task, I set the requirement to allow front-end programmers to access recipe attributes simply using the respective keyword (e.g. @recipe.image_url) without them having to perform logic, such as checking if an entry exists and appending the http-part, in the views. Instead, all this is done in the background.
I have never worked with a sidekiq scheduler before, so instead of using another gem, I created a new model that stores schedule-related information. I believe that this might not be best practice... but it works.

I havent used the code here (https://www.contentful.com/developers/docs/ruby/tutorials/create-your-own-rails-app/) under "Contentful as a view helper" only because it seemed to me this would make the front-end (views) too complex, since they would have to include more logic. However, I am happy to show you that I can do that as well, if you would like me to.

Lastly, the .env file is only on Github to make it easier for you to test my code.

<h1>How to </h1>
1. git clone 
2. bundle install
3. rails db:create db:migrate db:seed
4. rails s or bin/dev + sidekiq in second terminal window
-> Seeded recipes will be displayed and as soon as you start sidekiq, these "old" recipes will be removed and ones from the api downloaded
