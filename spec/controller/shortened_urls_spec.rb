require 'rails_helper'
RSpec.describe ShortenedUrlsController, type: :controller do
  describe "POST #create" do
    context "when creating a new short URL" do
      let(:original_url) { "http://example.com/long/url" }

      it "creates a new ShortenedUrl and redirects to the shortened URL" do
        post :create, params: { original_url: original_url }
        expect(response).to redirect_to(shortened_path(short_url: ShortenedUrl.last.short_url))
      end

      it "saves the sanitized URL" do
        expect do
          post :create, params: { original_url: original_url }
        end.to change(ShortenedUrl, :count).by(1)
        expect(ShortenedUrl.last.original_url).to eq(original_url)
      end
    end

    context "when a short URL already exists for the original URL" do
      let!(:existing_url) { ShortenedUrl.create(original_url: "http://example.com/long/url") }
      let(:original_url) { existing_url.original_url }

      it "redirects to the existing short URL" do
        post :create, params: { original_url: original_url }
        expect(flash[:notice]).to eq("A short link for this URL already exists")
        expect(response).to redirect_to(shortened_path(short_url: existing_url.short_url))
      end

      it "does not create a new ShortenedUrl" do
        expect do
          post :create, params: { original_url: original_url }
        end.not_to change(ShortenedUrl, :count)
      end
    end
  end

  describe "GET #shortened" do
    let!(:shortened_url) { ShortenedUrl.create(original_url: "https://example.com/long/url") }

    it "assigns the sanitized and short URL" do
      get :shortened, params: { short_url: shortened_url.short_url }
      expect(assigns(:original_url)).to eq(shortened_url.sanitize_url)
      expect(assigns(:short_url)).to eq(request.base_url + '/' + shortened_url.short_url)
    end
  end

  describe "GET #redirect_to_original_url" do
    let!(:shortened_url) { ShortenedUrl.create(original_url: "http://example.com/long/url") }

    it "redirects to the original URL" do
      get :redirect_to_original_url, params: { short_url: shortened_url.short_url }
      expect(response).to redirect_to(shortened_url.original_url)
    end
  end
end
