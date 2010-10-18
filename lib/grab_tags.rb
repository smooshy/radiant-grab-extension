require 'hpricot'
require 'open-uri'

module GrabTags
  include Radiant::Taggable

  desc %Q{Grabs HTML from a source and displays it in a div    
    *Usage:*
    
    <pre><code><r:grab url="http://som-url.com" [select="xpath or css"] [class="your-class"] [id="your-id"] /></code></pre>
  }
  tag "grab" do |tag|
    gid = "id=\"#{tag.attr['id']}\" " unless tag.attr['id'].nil?
    gclass = tag.attr['class'] || 'grabbag'
    url = tag.attr['url']

    grabbed = open(url) { |f| Hpricot(f) } unless url.nil?

    select = tag.attr['select'] || ''
    
    unless grabbed.nil?
      if select =~ /^[\/]/
        elements = grabbed.search(select)
      else 
        elements = (grabbed/"#{select}")
      end
    end
    
    output = %{<div #{gid}class="#{gclass}">}
    output += elements.to_html unless elements.nil?
    output += "</div>"
  end
end
