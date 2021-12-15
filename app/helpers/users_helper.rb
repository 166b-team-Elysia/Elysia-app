module UsersHelper

  # Returns the Gravatar for the given user.
  def gravatar_for(user, options = { size: 80 })
    size         = options[:size]
    gravatar_id  = Digest::MD5::hexdigest(user.name.downcase)
    if user.is_a? Product
      gravatar_url = user.cover.url
    else
      gravatar_url = user.avatar.url
    end
    gravatar_url ||= "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(asset_path(gravatar_url), alt: user.name, class: "gravatar img-thumbnail", size: 80)
  end
end