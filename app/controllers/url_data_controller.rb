# frozen_string_literal: true

## URLs Controller ##
class UrlDataController < ApplicationController
  def new
    @url = UrlDatum.new
  end

  def create
    existing_url { return }
    if @url.save
      redirect_to root_path(token: @url.token)
    else
      redirect_to root_path, alert: @url.errors.full_messages.join(', ')
    end
  end

  def show
    url = UrlDatum.find_by(token: params[:token])
    if url.present?
      redirect_to url.source_url, status: :moved_permanently
    else
      redirect_to root_path
    end
  end

  private

  def url_data_params
    params.require(:url_datum).permit(:source_url)
  end

  def existing_url
    @url = UrlDatum.new(url_data_params)
    url = UrlDatum.find_by(sanitized_url: @url.sanitize_url)
    redirect_to(root_path(token: url.token)) && yield if url.present?
  end
end
