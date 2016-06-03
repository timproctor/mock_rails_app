require 'rails_helper'

describe "A movie" do
  it "requires a title" do
    movie = Movie.new(title: "")
    
    movie.valid? # populates errors
    
    expect(movie.errors[:title].any?).to eq(true)
  end
  
  it "requires a description" do
    movie = Movie.new(description: "")
    
    movie.valid?

    expect(movie.errors[:description].any?).to eq(true)
  end
  
  it "requires a released on date" do
    movie = Movie.new(released_on: "")
    
    movie.valid?

    expect(movie.errors[:released_on].any?).to eq(true)
  end
  
  it "requires a duration" do
    movie = Movie.new(duration: "")
    
    movie.valid?

    expect(movie.errors[:duration].any?).to eq(true)
  end
  
  it "requires a description over 24 characters" do
    movie = Movie.new(description: "X" * 24)
    
    movie.valid?

    expect(movie.errors[:description].any?).to eq(true)
  end
  
  it "accepts a $0 total gross" do
    movie = Movie.new(total_gross: 0.00)

    movie.valid?

    expect(movie.errors[:total_gross].any?).to eq(false)
  end
  
  it "accepts a positive total gross" do
    movie = Movie.new(total_gross: 10000000.00)

    movie.valid?

    expect(movie.errors[:total_gross].any?).to eq(false)
  end
  
  it "rejects a negative total gross" do
    movie = Movie.new(total_gross: -10000000.00)

    movie.valid?

    expect(movie.errors[:total_gross].any?).to eq(true)
  end
  
  it "accepts properly formatted image file names" do
    file_names = %w[e.png movie.png movie.jpg movie.gif MOVIE.GIF]
    file_names.each do |file_name|
      movie = Movie.new(image_file_name: file_name)
      movie.valid?
      expect(movie.errors[:image_file_name].any?).to eq(false)
    end
  end
  
  it "rejects improperly formatted image file names" do
    file_names = %w[movie .jpg .png .gif movie.pdf movie.doc]
    file_names.each do |file_name|
      movie = Movie.new(image_file_name: file_name)
      movie.valid?
      expect(movie.errors[:image_file_name].any?).to eq(true)
    end
  end
  
  it "accepts any rating that is in an approved list" do
    ratings = %w[G PG PG-13 R NC-17]
    ratings.each do |rating|
      movie = Movie.new(rating: rating)
      movie.valid?
      expect(movie.errors[:rating].any?).to eq(false)
    end
  end
  
  it "rejects any rating that is not in the approved list" do
    ratings = %w[R-13 R-16 R-18 R-21]
    ratings.each do |rating|
      movie = Movie.new(rating: rating)
      movie.valid?
      expect(movie.errors[:rating].any?).to eq(true)
    end
  end
  
  it "is valid with example attributes" do
    movie = Movie.new(movie_attributes)
    
    expect(movie.valid?).to eq(true)
  end
  
  it "is a flop if the total gross is less than $50M" do
    movie = Movie.new(total_gross: 40000000)

    expect(movie).to be_flop
  end
  
  it "is not a flop if the total gross is greater than $50M" do
    movie = Movie.new(total_gross: 60000000)

    expect(movie).not_to be_flop
  end
  
  it "has many reviews" do
    movie = Movie.new(movie_attributes)

    review1 = movie.reviews.new(review_attributes)
    review2 = movie.reviews.new(review_attributes)

    expect(movie.reviews).to include(review1)
    expect(movie.reviews).to include(review2)
  end

  it "deletes associated reviews" do
    movie = Movie.create!(movie_attributes)

    movie.reviews.create!(review_attributes)

    expect { 
      movie.destroy
    }.to change(Review, :count).by(-1)
  end
  
  it "calculates the average number of review stars" do
    movie = Movie.create!(movie_attributes)

    movie.reviews.create!(review_attributes(stars: 1))
    movie.reviews.create!(review_attributes(stars: 3))
    movie.reviews.create!(review_attributes(stars: 5))
    
    expect(movie.average_stars).to eq(3)
  end
  
  context "released query" do
    it "returns the movies with a released on date in the past" do
      movie = Movie.create!(movie_attributes(released_on: 3.months.ago))

      expect(Movie.released).to include(movie)
    end

    it "does not return movies with a released on date in the future" do
      movie = Movie.create!(movie_attributes(released_on: 3.months.from_now))

      expect(Movie.released).not_to include(movie)
    end

    it "returns released movies ordered with the most recently-released movie first" do
      movie1 = Movie.create!(movie_attributes(released_on: 3.months.ago))
      movie2 = Movie.create!(movie_attributes(released_on: 2.months.ago))
      movie3 = Movie.create!(movie_attributes(released_on: 1.months.ago))

      expect(Movie.released).to eq([movie3, movie2, movie1])
    end
  end

  context "hits query" do
    it "returns movies with a total gross of at least 300_000_000" do
      movie1 = Movie.create!(movie_attributes(total_gross: 300_000_000))
      movie2 = Movie.create!(movie_attributes(total_gross: 9_000_000))

      expect(Movie.hits).to eq([movie1])
    end
  end

  context "flops query" do
    it "returns movies with a total gross less than 50_000_000" do
      movie1 = Movie.create!(movie_attributes(total_gross: 300_000_000))
      movie2 = Movie.create!(movie_attributes(total_gross: 49_000_000))

      expect(Movie.flops).to eq([movie2])
    end
  end
  
end
