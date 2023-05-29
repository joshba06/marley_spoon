require 'rails_helper'

AVAIL_TAGS =  %W(vegan gluten-free no-diary vegetarian top-rated)

RSpec.describe Recipe, type: :model do
  title = "#{Faker::Emotion.adjective.capitalize} #{Faker::Food.dish}"

  subject { Recipe.new(title: title, chef: Faker::Name.name, description: Faker::Food.description, tags: AVAIL_TAGS.sample(3), image_url: "http://someurl.com", contentful_id: rand(123)) }

  before { subject.save }

  it 'title should be present' do
    subject.title = nil
    expect(subject).to_not be_valid
  end

  it 'title cannot be blank' do
    subject.title = ""
    expect(subject).to_not be_valid
  end

  it 'description should be present' do
    subject.description = nil
    expect(subject).to_not be_valid
  end

  it 'description cannot be blank' do
    subject.description = ""
    expect(subject).to_not be_valid
  end

  it 'image url should be present' do
    subject.image_url = nil
    expect(subject).to_not be_valid
  end


  it 'contentful_id cannot be blank' do
    subject.contentful_id = ""
    expect(subject).to_not be_valid
  end

  it 'chef should be present' do
    subject.chef = nil
    expect(subject).to_not be_valid
  end

  it 'chef cannot be blank' do
    subject.chef = ""
    expect(subject).to_not be_valid
  end

  it 'tags may not be nil' do
    subject.tags = nil
    expect(subject).to_not be_valid
  end

  it 'tags may be an empty array' do
    subject.tags = []
    expect(subject).to be_valid
  end

  it 'tags must by default be an empty array' do
    subject.tags = "Hello"
    expect(subject.tags).to eq([])
  end

  it 'should not allow two recipes with the same title to be saved' do
    subject.title = "My new recipe"
    subject.save
    recipe_two = Recipe.new(title: "My new recipe", chef: Faker::Name.name, description: Faker::Food.description, tags: AVAIL_TAGS.sample(3), image_url: "http://someurl.com", contentful_id: rand(123))
    expect(recipe_two).to_not be_valid
  end

  it 'should not allow two recipes with the same contentful_id to be saved' do
    subject.contentful_id = 4
    subject.save
    recipe_two = Recipe.new(title: "My new recipe", chef: Faker::Name.name, description: Faker::Food.description, tags: AVAIL_TAGS.sample(3), image_url: "http://someurl.com", contentful_id: 4)
    expect(recipe_two).to_not be_valid
  end

  it 'should append tags to an existing recipe' do
    subject.tags << 'delicious'
    subject.tags << 'wonderful'

    expect(subject.tags.include?('delicious') && subject.tags.include?('wonderful')).to eq(true)
  end
end
