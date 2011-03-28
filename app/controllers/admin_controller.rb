class AdminController < ApplicationController
  
  before_filter :admin_required
  
  def all_flagged
    @all = [] 
    @all += Priority.published.flagged
    @all += Point.published.flagged
    @all += Comment.published.flagged
    @all += Document.published.flagged
    @all = @all.sort_by {|s| s.created_at}
    @page_title = tr("All Flagged Content", "controller/admin")
  end

  def all_deleted
    #TODO: Rethink this as the list of deleted comments grows
    @all = [] 
    @all += Priority.unpublished
    @all += Question.unpublished
    @all += Comment.unpublished
    @all += Document.unpublished
    @all = @all.sort_by {|s| s.updated_at}.reverse
    @page_title = tr("All Deleted Content", "controller/admin")    
    render :action=>:all_flagged
  end

  def random_user
    if User.adapter == 'postgresql'
      users = User.find(:all, :conditions => "status = 'active'", :order => "RANDOM()", :limit => 1)
    else
      users = User.find(:all, :conditions => "status = 'active'", :order => "rand()", :limit => 1)
    end
    self.current_user = users[0]
    flash[:notice] = tr("You are now logged in as {user_name}", "controller/admin", :user_name => users[0].name)
    redirect_to users[0]    
  end

  def picture
    @page_title = tr("Change logo for {government_name}", "controller/admin", :government_name => tr(current_government.name,"Name from database"))
  end

  def picture_save
    @government = current_government
    respond_to do |format|
      @government = unfrozen_instance(@government)
      if @government.update_attributes(params[:government])
        flash[:notice] = tr("Picture uploaded successfully", "controller/admin")
        format.html { redirect_to(:action => :picture) }
      else
        format.html { render :action => "picture" }
      end
    end
  end

  def fav_icon
    @page_title = tr("Change favicon for {government_name}", "controller/admin", :government_name => tr(current_government.name,"Name from database"))
  end

  def fav_icon_save
    @government = current_government
    respond_to do |format|
      @government = unfrozen_instance(@government)
      if @government.update_attributes(params[:government])
        flash[:notice] = tr("Picture uploaded successfully", "controller/admin")
        format.html { redirect_to(:action => :fav_icon) }
      else
        format.html { render :action => "fav_icon" }
      end
    end
  end
  
  def buddy_icon
    @page_title = tr("Change buddy icon for {government_name}", "controller/admin", :government_name => tr(current_government.name,"Name from database"))
  end

  def buddy_icon_save
    @government = current_government
    respond_to do |format|
      @government = unfrozen_instance(@government)
      if @government.update_attributes(params[:government])
        flash[:notice] = tr("Picture uploaded successfully", "controller/admin")
        format.html { redirect_to(:action => :buddy_icon) }
      else
        format.html { render :action => "buddy_icon" }
      end
    end
  end  

end
