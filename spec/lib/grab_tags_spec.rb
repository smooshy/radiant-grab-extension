require "hpricot"
require "open-uri"

require File.dirname(__FILE__) + '/../spec_helper'

describe 'GrabTags' do
  dataset :pages

  describe '<r:grab>' do
    it 'should return an empty box if no url supplied' do
      tag = '<r:grab/>'

      expected = %{<div class="grabbag"></div>}

      pages(:home).should render(tag).as(expected)
    end

    it 'should use a custom class if supplied' do
      tag = '<r:grab class="thediv"></r:grab>'

      expected = %{<div class="thediv"></div>}

      pages(:home).should render(tag).as(expected)
    end

    it 'should use a custom id if supplied' do
      tag = '<r:grab id="thediv" class="theclass"></r:grab>'

      expected = %{<div id="thediv" class="theclass"></div>}

      pages(:home).should render(tag).as(expected)
    end

    it 'should return all of the content from a file' do
      tag = "<r:grab url=\"#{File.dirname(__FILE__) + '/../example.html'}\"/>"

      expected = %{<div class="grabbag"><p>sometext</p>
</div>}

      pages(:home).should render(tag).as(expected)
    end

    it 'should return all of the content from a url' do
      url = "http://www.smooshylab.com/poo.html"
      tag = "<r:grab url=\"#{url}\"/>"

      expected_doc = open(url) { |f| Hpricot(f) }
      expected = %{<div class="grabbag">#{(expected_doc).inner_html}</div>}

      pages(:home).should render(tag).as(expected)
    end

    it 'should return only the content from an xpath' do
      select_xpath = "//a[@class='watchIntroVideoLink']"
      tag = %{<r:grab url="#{File.dirname(__FILE__) + '/../bigger_example.html'}" select="#{select_xpath}"/>}

      expected = %{<div class=\"grabbag\"><a href=\"#introVideoDisplayBox\" class=\"watchIntroVideoLink\"><img class=\"fix-transparency\" src=\"/assets/518/monitor-new.png\" height=\"54\" alt=\"monitor-new\" style=\"position: absolute; right: 48px; bottom: 140px; z-index: 10;\" width=\"146\" /></a></div>}

      pages(:home).should render(tag).as(expected)
    end

    it 'should return only the element for a css selector' do
      select = "#learnMore"
      tag = %{<r:grab url="#{File.dirname(__FILE__) + '/../bigger_example.html'}" select="#{select}"/>}

      expected = %{<div class=\"grabbag\"><img class=\"hover-image\" src=\"/assets/335/learn_more_sm_off.png\" id=\"learnMore\" height=\"18\" width=\"100\" /></div>}

      pages(:home).should render(tag).as(expected)
    end

    it 'should return only the elements for a css selector' do
      select = "a.block-link"
      tag = %{<r:grab url="#{File.dirname(__FILE__) + '/../bigger_example.html'}" select="#{select}"/>}

      expected = %{<div class=\"grabbag\"><a href=\"/home\" class=\"block-link\">\n  <img class=\"alignright hero\" src=\"/assets/185/woman-box-small.png\" height=\"132\" alt=\"woman-box-small\" width=\"91\" />\n  </a><a href=\"/pro\" class=\"block-link\">\n  <img class=\"alignright hero\" src=\"/assets/186/doctor-small.png\" height=\"136\" alt=\"doctor-small\" style=\"margin-left: -17px; margin-top: -4px;\" width=\"90\" />\n  </a><a href=\"/landing/win-2\" class=\"block-link\">\n  <img class=\"alignright hero\" src=\"/assets/438/ver_2_0_badge.png\" height=\"84\" alt=\"2.0-badge\" style=\"position: absolute; bottom: 14px; right: 5px;\" width=\"101\" />\n  </a><a href=\"http://mozy.com/blog\" class=\"block-link\">\n  </a></div>}

      pages(:home).should render(tag).as(expected)
    end
  end
end
