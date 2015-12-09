class SyncBlogsForUserWorker
  include Sidekiq::Worker

  def perform(user_id)
    User.find(user_id).update_following!
  end
end
