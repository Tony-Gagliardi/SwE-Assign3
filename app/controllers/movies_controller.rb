class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    save_settings
    filters = session[:table_filters]
    @order = filters[:order]
    @ratings = (filters[:ratings]) ? filters[:ratings].values : []
    @all_ratings = Movie.ratings

   if Movie.column_names.include? @order
     @movies = Movie.find(:all, :order => @order, :conditions => ['rating in (?)', @ratings])
   else 
     @movies = Movie.find(:all, :conditions => ['rating in (?)', @ratings])
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
    flash[:notice] = "#{@movie.title} was successfully deleted."
    redirect_to movies_path
  end

  private
  def save_settings
    if session[:table_filters].nil?
      session[:table_filters] = {} 
    end
    if params[:order] != session[:table_filters][:order] || params[:ratings] != session[:table_filters][:ratings]
      redirect = true
    end
    session[:table_filters][:order] = params[:order] unless params[:order].nil?
    session[:table_filters][:ratings] = params[:ratings] unless params[:ratings].nil?
    flash.keep
    if redirect
      redirect_to movies_path(session[:table_filters])
    end
  end
end

