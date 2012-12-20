# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require "current_project_helpers"
require 'carmen'
include Carmen

MM = ["1","2","3","4","5","6","7","8","9","10","11","12"]
# MM = ["Jan","Feb","Mar","Apr","May","June","July","Aug","Sept","Oct","Nov","Dec"]
TT = [ "Scat", "Skin", "Muscle", "Bone", "Brain", "Kidney", "Heart", "Other" ]
DD = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]
YY = ["2007","2008","2009","2010","2011","2012","2013","2014","2015"]
ACC = ['Very Accurate (to 2m)', 'Accurate (to 10m)', 'Reliable (to 100m)','Approximate (to 500m)','Moderate (to 1000m)', 'General (to 10,000m)', 'Vague (to 100,000m)']
LMM = [ 'Random', 'Measured', 'Centroid']
PP = ["Canada","U.S."]
SCAT = ["A+ = scat was wet, shiny, steaming", 
        "A  = scat was wet, shiny but at ambient temperature",
        "B  = scat was dry but shiny with almost no fur sticking out",
        "C  = scat was dry with minimal fur sticking out",
        "D  = scat was dry and looked mostly like a furry animal",
        "E  = scat was dry and looked like clay"]
AGE = ["<12 hours","<24 hours","<36 hours","<48 hours",">48 hours","Unknown"]
YN = ["Yes","No"]  

  def nice_date_display(the_date)
    return (the_date ? the_date.strftime('%Y.%m.%d') : '')
  end

class TrueClass
  def yesno
    "Yes"
  end
end

class FalseClass
  def yesno
    "No"
  end
end
class NilClass
  def yesno
    " "
  end
end

class ActiveRecord::Base
  def self.find_all_by_example(record, *attributes)
    conditions = Array.new
    query = Array.new
    for attribute in attributes.flatten.uniq
      query << "#{self.connection.quote_column_name(attribute.to_s)} = ?"
      conditions << record.send(attribute)
#      conditions << record[attribute]
    end
    self.find(:all, :conditions => [query.join(' AND ')] + conditions)
  end
end

class ApplicationController < ActionController::Base
   helper :all # include all helpers, all the time

#  # Pick a unique cookie name to distinguish our session data from others'
#  session :session_key => '_nrdpfc_session_id'
  include AuthenticatedSystem
#  include CurrentProjectHelper
#  include InPlaceEditing

  prepend_before_filter :set_project, :login_required  
  

  # This isn't working, I'm not quite sure why...
  # something isn't scoped right...

  def self.is_project_manager
    user = current_user
    return false if ! user
    return false if ! session[:project_id]
    project = Project.find_by_id(session[:project_id])
    return false if ! project
    @project_manager = (project.user_id == user.id)
  end

  def download_table
    # Horizontals use magic to define their tables so we have to use
    # reverse magic to figure it out
    table_name = self.class.respond_to?(:target_table_name) ?
                   self.class.target_table_name.to_s :
                   active_scaffold_config.model.table_name

    table = table_name.intern
    q = QueryBuilder.new(:parent => table, :tables => [ table ], :fields => { table => "*" })
    q.filter_by_project(current_project_id) unless (table == :projects)

    csv_string = FasterCSV.generate do |csv|
      csv << q.column_headers
      q.results.each {|result| csv << result }
    end

    send_data csv_string, :filename => "#{table_name}.csv"
  end


# set the project id if part of the url
def set_project
  @host = request.host

  if @host == 'localhost'
    @prid=64
    @pr_name = 'MEC'
    @pr_desc = 'Eastern Wolf Survey - Searching for Eastern Wolves in Southern Ontario and Quebec'
    return '64'
  end

  if @host =~ /7/ 
    @prid = 7
    @pr_name = 'CAN'
    @pr_desc = 'Wolf and Coyote DNA Bank'
    return '7' 
  else
    if @host =~ /64/
      @prid = 64
      @pr_name = 'MEC'
      @pr_desc = 'Eastern Wolf Survey - Searching for Eastern Wolves in Southern Ontario and Quebec'
    return '64'
    else
      @prid = 0
      @pr_desc = 'unknown project zero'
      return ''
    end
  end
end



end
