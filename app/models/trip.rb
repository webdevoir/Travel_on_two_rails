class Trip < ApplicationRecord
  belongs_to :user
  has_many :posts


  def self.search(search)
    if search
      @found_trips = Blog.where('blog_name LIKE ?', "%#{search}%")
    else
      @found_trips = Blog.all
    end
  end
end
