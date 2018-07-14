class Auth

  def initialize(sender_id)
    @sender_id = sender_id
  end

  def current_user
    find_or_initialize_by_sender_id(@sender_id)
  end

  def find_or_initialize_by_sender_id sender_id
    User.find_by(fb_id: sender_id) || User.create(fb_id: sender_id)
  end

end