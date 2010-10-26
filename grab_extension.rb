# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class GrabExtension < Radiant::Extension
  version "1.0"
  description "Grabs stuff from somewhere"
  url "http://github.com/smooshy/radiant-grab-extension"
  
  def activate
    Page.send :include, GrabTags
  end
  
  def deactivate
  end
  
end
