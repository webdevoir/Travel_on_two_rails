class PostGroupSerializer < ActiveModel::Serializer
  attributes :id, :month, :year, :image, :trip_id, :max_post_group_id, :min_post_group_id

  has_many :posts
  belongs_to :trip

  def max_post_group_id
    post_groups = object.trip.post_groups.sort_by {|obj| Date::MONTHNAMES.index(obj.month) && obj.year.to_i }
    index = post_groups.find_index(object)
    if index == post_groups.length
      return nil
    elsif post_groups == []
      return nil
    else
      max_post_group = post_groups[index+1]
      return max_post_group
    end
  end

  def min_post_group_id
    post_groups = object.trip.post_groups.sort_by {|obj| Date::MONTHNAMES.index(obj.month) && obj.year.to_i }
    index = post_groups.find_index(object)
    if index == 0
      return nil
    elsif post_groups == []
      return nil
    else
      min_post_group = post_groups[index-1]
      return min_post_group
    end
  end

end
