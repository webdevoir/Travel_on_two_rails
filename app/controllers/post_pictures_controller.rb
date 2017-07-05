class PostPicturesController < ApplicationController

  def new
    @post = Post.find(params[:post_id])
    @trip = Trip.find(params[:trip_id])
    @post_group = @post.post_group
    @post_picture = PostPicture.new
  end

  def fetch_images
    @post = Post.find(params[:post_id])
    @trip = Trip.find(params[:trip_id])
    @image_url = []
    @post_picture_ids = []
    @post_pictures = @post.post_pictures
    @post_pictures.each do |post_picture|
      @image_url << post_picture.picture.thumb.url
      @post_picture_ids << post_picture.id
    end

    render json: { message: "success", image_url: @image_url, post_picture_ids: @post_picture_ids }
  end

  def create
    @post = Post.find(params[:post_id])
    @post_picture = PostPicture.create(upload_params)
    @post_picture.post_id = @post.id
    if @post_picture.save
      render json: { message: "success", fileID: @post_picture.id }, :status => 200
    else
      #  you need to send an error header, otherwise Dropzone
          #  will not interpret the response as an error:
      render json: { error: @post_picture.errors.full_messages.join(',')}, :status => 400
    end
  end

  def destroy
    @post_picture = PostPicture.find(params[:id])
    if @post_picture.destroy
      render json: { message: "File deleted from server" }
    else
      render json: { message: @post_picture.errors.full_messages.join(',') }
    end
  end

  private
  def upload_params
  	params.require(:upload).permit(:picture)
  end

end
