class UserPublisher

  # The new message templates are supported as well
  # First, create a method that contains your templates:
  # You may include multiple one line story templates and short story templates but only one full story template
  #  Your most specific template should be first
  #
  # Before using, you must register your template by calling register. For this example
  #  You would call UserPublisher.register_endorsement
  #  Registering the template will store the template id returned from Facebook in the
  # facebook_templates table that is created when you create your first publisher
  
  def endorsement_template
#    one_line_story_template "{*actor*} studdi <a href='{*priority_url*}'>{*priority_name*}</a> í mikilvægisröð {*position*} á <a href='{*government_url*}'>{*government_name*}</a>"
#    short_story_template "{*actor*} studdi <a href='{*priority_url*}'>{*priority_name*}</a> í mikilvægisröð {*position*} á <a href='{*government_url*}'>{*government_name*}</a>", render(:partial => "priority")
#    action_links action_link("Skoða betur","{*priority_url*}")
  end

  def create_bottom_text(priority)
    if priority
      er_up_text = priority.up_endorsements_count > 1 ? "eru" : "er"
      er_down_text = priority.down_endorsements_count > 1 ? "eru" : "er"
      er_up_text = "eru" if priority.up_endorsements_count == 0
      er_down_text = "eru" if priority.down_endorsements_count == 0
      "Þessi hugmynd er núna númer #{priority.position}, #{priority.up_endorsements_count} #{er_up_text} með og #{priority.down_endorsements_count} #{er_down_text} á móti."
    else
      ""
    end
  end

  # To send a registered template, you need to create a method to set the data
  # The publisher will look up the template id from the facebook_templates table
  def endorsement(facebook_session, endorsement, priority)
    send_as :publish_stream
    txt_message = "#{facebook_session.user.name} studdi hugmyndina #{priority.name} á Skuggaborg. "+create_bottom_text(priority)
    from facebook_session.user
    message ''
    attachment :name => priority.name, :href => priority.show_url, :description => txt_message
    action_links [ :text => 'Rökræða hugmynd', :href => "#{priority.show_url}/top_points"]
  end

  def opposition_template
#    one_line_story_template "{*actor*} er á móti <a href='{*priority_url*}'>{*priority_name*}</a> í mikilvægisröð {*position*} á <a href='{*government_url*}'>{*government_name*}</a>"
#    short_story_template "{*actor*} er á móti <a href='{*priority_url*}'>{*priority_name*}</a> í mikilvægisröð {*position*} á <a href='{*government_url*}'>{*government_name*}</a>", render(:partial => "priority")
#    action_links action_link("Skoða betur","{*priority_url*}")
  end

  # To send a registered template, you need to create a method to set the data
  # The publisher will look up the template id from the facebook_templates table
  def opposition(facebook_session, endorsement, priority)
    send_as :publish_stream
    txt_message = "#{facebook_session.user.name} er á móti hugmyndinni #{priority.name} á Skuggaborg. "+create_bottom_text(priority)
    from facebook_session.user
    #target facebook_session.user
    message ''
    attachment :name => priority.name, :href => priority.show_url, :description => txt_message
    action_links [ :text => 'Rökræða hugmynd', :href => "#{priority.show_url}/top_points"]
  end  
  
  def comment_template
#    one_line_story_template "{*actor*} <a href='{*comment_url*}'>skrifaði athugasemd</a> við <a href='{*object_url*}'>{*object_name*}</a> á <a href='{*government_url*}'>{*government_name*}</a>"
#    short_story_template "{*actor*} <a href='{*comment_url*}'>skrifaði athugasemd</a> við <a href='{*object_url*}'>{*object_name*}</a> á <a href='{*government_url*}'>{*government_name*}</a>", "{*short_comment_body*}"
#    full_story_template "{*actor*} <a href='{*comment_url*}'>skrifaði athugasemd</a> við <a href='{*object_url*}'>{*object_name*}</a> á <a href='{*government_url*}'>{*government_name*}</a>", "{*comment_body*}"  
#    action_links action_link("Svara","{*comment_url*}")      
  end
  
  def self.create_comment(current_facebook_user, comment, activity)
    priority = activity.priority if activity.has_priority?
    if activity.has_question?
      object_url = activity.question.show_url
      object_name = activity.question.name
    elsif activity.has_document?
      object_url = activity.document.show_url
      object_name = activity.document.name
    elsif activity.has_priority?
      object_url = activity.priority.show_url
      object_name = activity.priority.name
    else
      object_url = comment.show_url
      object_name = activity.name
    end
    name = "#{object_name}"
    description = comment.content
    current_facebook_user.fetch
    current_facebook_user.feed_create(
    Mogli::Post.new(:name => name,
                    :link=>object_url,
                    :description=>description))
  end

  def point_template
#    one_line_story_template "{*actor*} bætti við <a href='{*point_url*}'>rökum</a> við <a href='{*priority_url*}'>{*priority_name*}</a> á <a href='{*government_url*}'>{*government_name*}</a>"
#    short_story_template "{*actor*} bætti við <a href='{*point_url*}'>rökum</a> við <a href='{*priority_url*}'>{*priority_name*}</a> á <a href='{*government_url*}'>{*government_name*}</a>", render(:partial => "title_and_body")
#    action_links action_link("Skoða betur","{*point_url*}")      
  end 
  
  def question(facebook_session, question)
    send_as :publish_stream
    txt_message = "#{facebook_session.user.name} bætti við spurningu: #{question.name_with_type} - #{question.content}"
    from facebook_session.user
    message ''
    attachment :name => question.name_with_type, :href => question.show_url, :description => txt_message
#    action_links [ :text => 'Rökræða hugmynd', :href => "#{priority.show_url}/top_points"]
#    data :priority_url => priority.show_url, :priority_name => priority.name, :point_url => point.show_url, :government_url => Government.current.homepage_url, :government_name => Government.current.name, :body => point.content, :source => point.website_link, :title => point.name_with_type
  end
  
  def document_template
#    one_line_story_template "{*actor*} bætti við <a href='{*document_url*}'>skjali</a> to <a href='{*priority_url*}'>{*priority_name*}</a> á <a href='{*government_url*}'>{*government_name*}</a>"
#    short_story_template "{*actor*} bætti við <a href='{*document_url*}'>skjali</a> to <a href='{*priority_url*}'>{*priority_name*}</a> á <a href='{*government_url*}'>{*government_name*}</a>", render(:partial => "title_and_body")
#    action_links action_link("Skoða betur","{*document_url*}")  
  end
  
  def document(facebook_session, document)
    send_as :publish_stream
    txt_message = "#{facebook_session.user.name} bætti við erindi: #{document.name} - #{truncate(document.content, :length => 400)}"
    from facebook_session.user
    message ''
    attachment :name => document.name, :href => document.show_url, :description => txt_message
#    action_links [ :text => 'Rökræða hugmynd', :href => "#{priority.show_url}/top_points"]
#    data :priority_url => priority.show_url, :priority_name => priority.name, :document_url => document.show_url, :government_url => Government.current.homepage_url, :government_name => Government.current.name, :body => truncate(document.content, :length => 400), :title => document.name_with_type
  end  
  
end
