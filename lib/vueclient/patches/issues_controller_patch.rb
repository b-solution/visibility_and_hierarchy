require 'issues_controller'

module  Vueclient
  module  Patches
    module IssuesControllerPatch
      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
          prepend_before_filter :check_tracker , :only=>:create
        end
      end
    end

    module ClassMethods
    end

    module InstanceMethods
      def check_tracker
        if params[:issue][:tracker_id].to_i==0
          flash[:error]="Tracher doit &egrave;tre renseign&eacute;.".html_safe
          issue=params[:issue]
          issue[:tracker_id]=1
          redirect_to :action =>:new, :issue => issue
        end
      end
    end
  end
end
