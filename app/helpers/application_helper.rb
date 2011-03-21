module ApplicationHelper

  def create_tab(text,path)
    if path == '/'
      klass = request.fullpath == path ? 'active' : ''
    else
      klass = request.fullpath.include?(path) ? 'active' : ''
    end
    "<li>#{link_to(text,path,:class => klass)}</li>".html_safe
  end
end
