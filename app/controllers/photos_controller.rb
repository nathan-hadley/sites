class PhotosController < ApplicationController
  def index
    photo_paths = Dir["app/assets/images/photos/*"]
    @photos = photo_paths.map { |file| File.basename(file) }
  end
end
