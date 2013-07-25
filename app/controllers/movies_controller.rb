class MoviesController < ApplicationController
 
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
   
  def self.getRatings
    Movie.find(:all, :select => "rating").group_by(&:rating).keys.sort
  end
 
  def index
    sortSession = false
    if(params.has_key?(:sort) and (params[:sort].length > 0))
       @sort = params[:sort]
       session[:sort] = @sort
    else
       @sort = session[:sort]
       sortSession = true      
    end
    @all_ratings = MoviesController.getRatings
    @ratingString = ""
    ratingsSession = false   
    if(params.has_key?(:ratings))
       @ratings = params[:ratings]
       @ratingString = @ratings.keys.join(",")
       session[:ratingString] = @ratingString
       @condition = {:rating => @ratings.keys}           
   else if (params.has_key?(:ratingString) and (params[:ratingString].length > 0))
        @ratingString = params[:ratingString]
        @ratings = Hash.new
        @ratingString.split(",").each {|rating| @ratings[rating] = 1}
        session[:ratingString] = @ratingString
        @condition = {:rating => @ratings.keys}
        else if (@ratingString.length == 0) and (session[:ratingString])
              @ratingString = session[:ratingString]
              @ratings = Hash.new
              @ratingString.split(",").each {|rating| @ratings[rating] = 1}
              @condition = {:rating => @ratings.keys}
              if(sortSession)
                  redirect_to :ratingString=>@ratingString, :sort=>@sort
              end
           end 
        end        
   end
   #if(sortSession and ratingsSession and @sort and (@ratingString.length > 0))
   #  redirect_to :ratingString=>@ratingString, :sort=>@sort
   #else
   @movies = Movie.find(:all, <img src="http://s1.wp.com/wp-includes/images/smilies/icon_surprised.gif?m=1129645325g" alt=":o" class="wp-smiley"> rder => @sort, :conditions =>@condition) 
   #end
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
