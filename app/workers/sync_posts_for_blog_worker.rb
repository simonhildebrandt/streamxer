class SyncPostsForBlogWorker
  include Sidekiq::Worker

  def perform(blog_id)
    Blog.find(blog_id).tap do |blog|
      blog.update_posts!
      blog.finished_post_sync!
    end
  end
end
