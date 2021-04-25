class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  # def all_ratings
  #   %w(G PG PG-13 NC-17 R)
  # end
  
  def index
    #@movies = Movie.all #first version
    #### Version below is deprecated due to issues on params to_h in current Rails 5  
    #### For more detais, see https://stackoverflow.com/questions/34949505/unable-to-retrieve-hash-values-from-parameter/34951198#34951198?newreg=0d502608c9d148b0893decf2995fe3d2
    # params.permit(:sort, :ratings)
    # sort = params[:sort] || session[:sort]
    # case sort
    # when 'title'
    #   ordering,@title_header = {:title => :asc}, 'hilite'
    # when 'release_date'
    #   ordering,@date_header = {:release_date => :asc}, 'hilite'
    # end
    #  @all_ratings = Movie.all_ratings
    #  #As for Ruby version = 5
    #  @selected_ratings = params.permit([:ratings]).to_h || session.permit([:ratings]).to_h || {}
    #  #As for Ruby version <=4
    #  #@selected_ratings = params[:ratings]|| session[:ratings] || {}

    #  if @selected_ratings == {}
    #    @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    #  end

    #  if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
    #    session[:sort] = sort
    #    session[:ratings] = @selected_ratings
    #    redirect_to :sort => sort, :ratings => @selected_ratings and return
    #  end
    # #@movies = Movie.order(ordering)
    # @movies = Movie.where(rating: @selected_ratings.keys).order(ordering)
  
    @movies = Movie.all 
    sort = params[:sort_by] || session[:sort_by]
    case sort
    when 'title'
      ordering,@title_header = {:title => :asc}, 'hilite'
    when 'release_date'
      ordering,@date_header = {:release_date => :asc}, 'hilite'
    end

    @all_ratings = Movie.all_ratings
    params.permit([:ratings]).to_h


    if (params[:sort_by])
      session[:sort_by] = params[:sort_by]
      if (session[:ratings])
        @selected_ratings = session[:ratings]
      end
    elsif (params[:ratings])
      session[:ratings] = params[:ratings]
      @selected_ratings = params[:ratings]
    else
      session[:sort_by] = nil
      session[:ratings] = nil
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    @movies = Movie.where(rating: @selected_ratings.keys).order(ordering)
  end

  def new
    # default: render 'new' template
  end

  def create
    #params.permit!
    #@movie = Movie.create!(params[:movie])
    Movie.create(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    params.permit!
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