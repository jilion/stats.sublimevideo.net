module VideoIdentifiable
  extend ActiveSupport::Concern

  included do
    field :s, as: :site_token
    field :u, as: :video_uid
    field :t, as: :time, type: Time

    index site_token: 1, video_uid: 1, time: -1
  end
end
