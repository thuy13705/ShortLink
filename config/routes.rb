Rails.application.routes.draw do
  root to: 'home#index'

  namespace :api do
    namespace :v1 do
      post 'encode', to: 'urls#encode'
      post 'decode', to: 'urls#decode'
    end
  end

  get '/:short_code', to: redirect { |params, req|
    short = ShortUrl.find_by(short_code: params[:short_code])
    short ? short.original_url : '/404'
  }
end
