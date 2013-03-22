module CustomizedId
  extend ActiveSupport::Concern

  included do
    field :_id, type: Hash, default: -> {
      { 't' => attributes.delete('time'),
        's' => attributes.delete('site_token') }
    }
  end

  def time
    p id['t'].class
    id['t']
  end

  def site_token
    id['s']
  end
end
