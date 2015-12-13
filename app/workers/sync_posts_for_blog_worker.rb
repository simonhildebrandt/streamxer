class SyncPostsForBlogWorker
  include Sidekiq::Worker

  def perform(blog_id)
    Blog.find(blog_id).tap do |blog|
      blog.update_posts!
      blog.update_attributes! syncing: false
    end
  end
end
