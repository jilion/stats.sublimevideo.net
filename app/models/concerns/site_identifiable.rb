module SiteIdentifiable
  extend ActiveSupport::Concern

  included do
    field :s, as: :site_token
    field :t, as: :time, type: Time

    index site_token: 1, time: -1
  end
end
