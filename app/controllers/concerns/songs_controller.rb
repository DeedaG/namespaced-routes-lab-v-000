class SongsController < ApplicationController
  def index
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      if @artist.nil?
        redirect_to artists_path, alert: "Artist not found"
      else
        @songs = @artist.songs
      end
    else
      @songs = Song.all
    end
  end

  def show
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      @song = @artist.songs.find_by(id: params[:id])
      if @song.nil?
        flash[:alert] = "Song not found."
        redirect_to artist_songs_path(@artist)
      end
    else
      @song = Song.find(params[:id])
    end
  end

  def new
    if Preference.create(allow_create_songs: false)
      redirect_to songs_path, alert: "You do not have permission to create song."
      else
      @song = Song.new
    end
  end

  def create
    @song = Song.new(song_params)

      if @song.save
        redirect_to @song
      else
        render :new
      end
   end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name)
  end
end
