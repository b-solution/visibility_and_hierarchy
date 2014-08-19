module VuclientHelper
  include ApplicationHelper
  def self.render_get_hidden_workflow(project, user)
    ########################################
    # Vue client 3: http://helpdesk.audaxis.com/issues/show/49367
    # Vue client 5: http://helpdesk.audaxis.com/issues/show/49372
    #======================================
    #
    # Workflow ( tracker_id| old_statut| new_statut| role_id| type="WorkflowTransition"| field_name| rule)
    #
    #######################################
    roles=User.current.roles_id_for_project(project,user)
    unless roles==[] or roles.nil?
      role_id=roles[0]
      trackers=Tracker.sorted.all
      #workflow contain all field that have at least on field hidden
     workflow = WorkflowRule.all(:conditions=>["role_id=? and rule=?",role_id,"hidden"]).uniq {|w| w.field_name }
      unless workflow==[]
        trackers.each{|tracker|
          issues=tracker.issue_statuses
          # wf contain the nbr of occurence in each field
          # eg: tracker=> evolution, role=> client, rule => hidden , issues.size=15
          # =>>> field name= privé = 14 times | facturé = 15 times
          # Conclusion: field privé is visible for ONE status so it have to be rejected from @workflow
          #  =============================
          # initiating Hash.new(0) for the default value
          wf=WorkflowRule.all(:conditions=>["tracker_id= ? and role_id=? and rule=?",
                                            tracker.id, role_id,"hidden"]).group_by(&:field_name).inject(Hash.new(0)) do |hash, (k,v)|
            hash[k] = v.size
            hash
          end
          #
          workflow.reject!{|w|
            if wf[w.field_name.to_s]!=0
              wf[w.field_name.to_s]!=issues.size
            else
              #if wf doen't contain the field name so his value is 0
              false
            end
          }
        }

      end
    end
    workflow||=[] # return [] if @workflow is null

    workflow

  end
  def render_get_hidden_workflow(project, user)
    return VuclientHelper.render_get_hidden_workflow(project, user)
  end
  def self.is_client?(user,issue)
    is_client=false
    clients=VuclientHelper.get_clients
    roles= issue.roles_id_for_project(issue.project, user)
    roles.each{|role|
      is_client=true  if clients.include?(role)
    }
    is_client
  end

  def is_client?(user,issue)
    return VuclientHelper.is_client?(user,issue)
  end

  def self.get_clients
    roles=Role.all(:conditions=>["builtin=?",0])# all roles except anonme and non member
    clients=Array.new
    unless roles==[]
      roles.each{|role|
        max=[Setting[:plugin_vueclient][role.name.to_sym].to_i, 0].max
        clients<< role.id    if max!=0
      }
    end
    clients
    end
  def self.can_view_timelog?(project)
    roles=User.current.roles_for_project(project)
    v_tm=roles.collect{|role|
      role.has_permission?("view_time_entries")
    }
   
    v_tm.include?(true)

  end
  def can_view_timelog?(project)
    return VuclientHelper.can_view_timelog?(project)
  end
end

