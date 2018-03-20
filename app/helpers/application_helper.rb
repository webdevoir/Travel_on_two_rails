module ApplicationHelper
  def css_slug
    "#{params[:controller]}-#{params[:action]}"
  end

  def stripe_url
    "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=#{ENV['STRIPE_CLIENT_ID']}&scope=read_write"
  end

  def poi_categories
    [
      ["POI", "poi"],
      ["Caution", "caution"],
      ["Lodging", "lodging"],
      ["Groceries", "groceries"],
      ["WIFI", "wifi"],
      ["Bike Shop", "bike shop"]
    ]
  end

end
