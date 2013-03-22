module CustomizedId
  extend ActiveSupport::Concern

  included do
    field :_id, type: Hash, default: ->{
      time       = attributes.delete('time')
      site_token = attributes.delete('site_token')
      { t: time, s: site_token }
    }
  end

  def time
    id[:t]
  end

  def site_token
    id[:s]
  end
end
