StatsSublimeVideo::Application.routes.draw do
  root to: redirect('http://sublimevideo.net')

  namespace :private_api do
    resources :site_stats, only: [] do
      get 'last_days_starts', on: :member
    end
    scope "/sites/:site_token" do
      resources :video_stats, only: [] do
        get 'last_days_starts', on: :member
      end
    end
  end

  resources :last_plays, only: [:index], path: 'plays'
end
