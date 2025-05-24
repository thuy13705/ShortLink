module Api::V1
    class UrlsController < ApplicationController
          skip_before_action :verify_authenticity_token

        def encode
             original_url = params[:url]
            if original_url.blank?
                return render json: { error: 'url is required' }, status: :bad_request
            end

            unless UrlValidator.valid_format?(original_url)
                return render json: { error: 'invalid url format' }, status: :bad_request
            end

            unless UrlValidator.safe_public_url?(original_url)
                return render json: { error: 'blocked: private or unsafe URL' }, status: :bad_request
            end

            url = ShortUrl.find_or_create_by(original_url: original_url)
            render json: { short_url: "#{request.base_url}/#{url.short_code}" }, status: :ok
        end

        def decode
            short_url = params[:url]

            if short_url.blank?
                return render json: { error: 'short_url is required' }, status: :bad_request
            end

            code = short_url.split('/').last
            url = ShortUrl.find_by(short_code: code)

            if url
                render json: { original_url: url.original_url }, status: :ok
            else
                render json: { error: 'Not found' }, status: :not_found
            end
        end
    end
end