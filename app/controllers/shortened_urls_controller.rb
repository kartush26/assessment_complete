class ShortenedUrlsController < ApplicationController
  before_action :find_url, only: :shortened

  def new
    @url =ShortenedUrl.new
  end

  def create
    @url= ShortenedUrl.new(original_url: params[:original_url])
    @url.sanitize

    if @url.new_url?
      if @url.save
        redirect_to shortened_path(short_url: @url.short_url)
      else
        render 'new'
      end
    else
      flash[:notice] = "A short link for this URL already exists"
      @url =  ShortenedUrl.find_by(original_url: params[:original_url])
      redirect_to shortened_path(short_url: @url.short_url)
    end
  end

  def shortened
    host = request.base_url
    @original_url = @url.sanitize_url
    @short_url = host+ '/'+ @url.short_url
  end

  def redirect_to_original_url
    url = ShortenedUrl.find_by_short_url(params[:short_url])
    redirect_to url.sanitize_url
  end

  private

  def find_url
    @url= ShortenedUrl.find_by_short_url(params[:short_url])
  end

  def url_params
    params.require(url).permit(:original_url)
  end
end
