# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class GreedyPageExtension < Radiant::Extension
  version "1.0"
  description "A page that will return for any url that implies a child page"
  url "http://code.trike.com.au/svn/radiant/extensions/greedy_page"
  
  def activate
    GreedyPage
  end
  
  def deactivate
  end
  
end
