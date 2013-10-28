StatsSublimeVideo::Application.routes.draw do
  root to: redirect('http://sublimevideo.net')

  namespace :private_api do
    resources :last_plays, only: [:index]
    resources :last_site_stats, only: [:index]
    resources :last_video_stats, only: [:index]
    resources :site_stats, only: [:index] do
      get :last_days_starts, on: :collection
    end
    resources :video_stats, only: [:index] do
      get :last_days_starts, on: :collection
    end
    resources :site_admin_stats, only: [:index] do
      get :last_days_starts, on: :collection
      get :last_pages, on: :collection
      get :global_day_stat, on: :collection
      get :last_30_days_sites_with_starts, on: :collection

      get :migration_totals, on: :collection
    end
  end
end
