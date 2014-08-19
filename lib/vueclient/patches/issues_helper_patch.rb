require_dependency 'issues_helper'


module  Vueclient
  module  Patches
    module IssuesHelperPatch
      def self.included(base)
        base.extend(ClassMethods)

        base.send(:include, InstanceMethods)

        base.class_eval do
          alias_method_chain :render_issue_tooltip, :filter

        end
      end
    end

    module ClassMethods
    end

    module InstanceMethods

      def render_issue_tooltip_with_filter(issue)
        @cached_label_status ||= l(:field_status)
        @cached_label_start_date ||= l(:field_start_date)
        @cached_label_due_date ||= l(:field_due_date)
        @cached_label_assigned_to ||= l(:field_assigned_to)
        @cached_label_priority ||= l(:field_priority)
        @cached_label_project ||= l(:field_project)

        user=User.current
	str=link_to_issue(issue) + "<br /><br />".html_safe+
            "<strong>#{@cached_label_project}</strong>: #{link_to_project(issue.project)}<br />".html_safe

        unless issue.disabled_core_fields.include?('status_id') || issue.hidden_attribute?('status_id', user)
          str+="<strong>#{@cached_label_status}</strong>: #{h(issue.status.name)}<br />".html_safe
        end
        unless issue.disabled_core_fields.include?('start_date') || issue.hidden_attribute?('start_date', user)
        str+="<strong>#{@cached_label_start_date}</strong>: #{format_date(issue.start_date)}<br />".html_safe
        end
        unless issue.disabled_core_fields.include?('due_date') || issue.hidden_attribute?('due_date', user)
        str+="<strong>#{@cached_label_due_date}</strong>: #{format_date(issue.due_date)}<br />".html_safe
        end

        unless issue.disabled_core_fields.include?('assigned_to_id') || issue.hidden_attribute?('assigned_to_id', user)
          str+="<strong>#{@cached_label_assigned_to}</strong>: #{h(issue.assigned_to)}<br />".html_safe
        end
        unless issue.disabled_core_fields.include?('priority_id') || issue.hidden_attribute?('priority_id', user)
          str+= "<strong>#{@cached_label_priority}</strong>: #{h(issue.priority.name)}".html_safe
        end
        str
      end
    end
  end
end
