module ApplicationHelper

  def create_tab(text,path)
    klass = request.fullpath.include?(path) ? 'active' : ''
    "<li class=#{klass}>#{link_to(text,path)}</li>".html_safe
  end
end
