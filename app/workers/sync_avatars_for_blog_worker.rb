class SyncAvatarsForBlogWorker
  include Sidekiq::Worker

  def perform(blog_id)
    Blog.find(blog_id).update_avatars!
  end
end
