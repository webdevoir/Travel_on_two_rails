class Blog < ApplicationRecord
  belongs_to :user
  has_many :posts

  def self.search(search)
    if search
      @found_blogs = Blog.where('blog_name LIKE ?', "%#{search}%")
    else
      @found_blogs = Blog.all
    end
  end
end
