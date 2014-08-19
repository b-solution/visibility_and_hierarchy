Redmine::Plugin.register :vueclient do
  name 'Vue client plugin'
  author 'KEDIDI Bilel'
  description ''
  version '0.0.1'

end

class Hooks < Redmine::Hook::ViewListener

  render_on :view_projects_index_top, :partial => 'projects/visibily_and_hierarchy', :layout => false

end

