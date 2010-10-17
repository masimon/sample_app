module UsersHelper
  def gravatar_for(user, options = { :size => 50 })
    #image_tag("pass.png", :alt => "Placeholder Avatar", :class => "gravatar")
    gravatar_image_tag(user.email.downcase, :alt => user.name,
                                            :class => 'gravatar',
                                            :gravatar => options)
  end
end
