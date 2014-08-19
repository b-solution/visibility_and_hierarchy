visibily_and_hierarchy
======================
PLugin created for redmine 2.3.x to make an hierarchy for the project in case where the parents of the specific project are innacessible and there is an occurence of 2 projet with the same name in more than 1 project.

Add this hook into projects/index.html.erb: <%= call_hook(:view_projects_index_top, :projects => @projects) %>
