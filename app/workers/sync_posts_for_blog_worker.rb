class SyncPostsForBlogWorker
  include Sidekiq::Worker

  def perform(blog_id)
    Blog.find(blog_id).update_posts!
  end
end
