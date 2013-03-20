StatsSublimeVideo::Application.routes.draw do
  root to: redirect('http://sublimevideo.net')

  namespace :private_api do
  end
end
