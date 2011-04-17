I18n::Backend::Simple.send(:include, I18n::Backend::Cascade)

ActionController::Base.class_eval do
  def translate(key, options = {})
    super(key, options.merge(:cascade => true))
  end
  alias t translate
end

ActionView::Base.class_eval do
  def translate(key, options = {})
    super(key, options.merge(:cascade => true))
  end
  alias t translate
end
