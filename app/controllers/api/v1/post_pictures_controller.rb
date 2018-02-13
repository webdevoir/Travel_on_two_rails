class Api::V1::PostPicturesController < Api::V1::BaseController

  def create
    @post = Post.find(params[:post_id])
    @post_picture = PostPicture.new
    @post_picture.picture = params[:file]
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

  def require_permission
    if current_user != Trip.find(params[:trip_id]).user
      redirect_to root_path
    end
  end

end
