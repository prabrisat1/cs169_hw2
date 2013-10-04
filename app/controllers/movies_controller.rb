class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_all_ratings()
    @all_checked_boxes = params[:ratings]
    sortOption = params[:sortOption]

    if !@all_checked_boxes
      @all_checked_boxes = session[:ratings]
      sortOption = session[:sortOption]
    end

    if !sortOption
      sortOption = session[:sortOption]
    end

    if(@all_checked_boxes)
      session[:ratings] = @all_checked_boxes
      keys = @all_checked_boxes.keys

      @all_ratings.each_with_index{ |item, index| 
        if !@all_checked_boxes.include?(item[0])
          value = item[1] =false
        end
      }
    end

    if keys
      if keys.size != 0
        allMovies = Movie.find_all_by_rating(keys)
      else
        allMovies = Movie.all 
      end
    else 
      allMovies = Movie.all
    end

    if sortOption
      if sortOption == 'title'
        @movies = allMovies.sort!{|a,b|
          a.title.downcase <=> b.title.downcase
        }
        @sortOption = 'title'
        session[:sortOption] = 'title'
      elsif sortOption == 'date'
        @movies = allMovies.sort!{|a,b|
          a.release_date <=> b.release_date
        }
        @sortOption = 'date'
        session[:sortOption] = 'date'
      else
        @movies = allMovies
      end
    else
      @movies = allMovies
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
