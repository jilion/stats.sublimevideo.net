StatsSublimeVideo::Application.routes.draw do
  root to: redirect('http://sublimevideo.net')

  namespace :private_api do
    scope "sites/:site_token" do
      resources :last_plays, only: [:index]
      resources :site_stats, only: [] do
        get 'last_days_starts', on: :collection
      end

      scope "videos/:video_uid" do
        resources :last_plays, only: [:index]
        resources :video_stats, only: [:index] do
          get 'last_days_starts', on: :collection
        end
      end
    end
  end
end
