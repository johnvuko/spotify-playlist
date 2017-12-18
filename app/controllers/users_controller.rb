class UsersController < ApplicationController

  def update
    current_user.update(user_params)
    redirect_to root_url
  end

private

  def user_params
    params.require(:user).permit(:check_playlists, :check_saved_tracks) if params[:user]
  end

end
