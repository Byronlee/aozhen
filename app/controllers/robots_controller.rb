require 'builder'
require 'xmlsimple'
class RobotsController < ApplicationController

  def index
    @config = XmlSimple.xml_in('/home/simlegate/aozhen/app/controllers/foo.xml')    
  end

  def create
    xml = Builder::XmlMarkup.new( :indent => 2 )
    xml.instruct! :xml, :encoding => "UTF-8"
    xml = xml.defalut_config do |d|
      d.length params[:lenght]
      d.widht  params[:widht]
      d.x      params[:x]
      d.y      params[:y]
      d.d      params[:d]
    end
    open('/home/simlegate/aozhen/app/controllers/foo.xml','w') do |f|  
      f.puts xml  
    end  

    redirect_to :action => 'index'
  end


  def command
    
    xml = Builder::XmlMarkup.new( :indent => 2 )
    xml.instruct! :xml, :encoding => "UTF-8"
    xml = xml.command do |d|
      d.value params[:optionsRadios]
    end

    EventMachine.run {
      http = EventMachine::HttpRequest.new('http://google.com/').post :body => xml
      http.errback { p 'Uh oh'; EM.stop }
      http.callback {
        p http.response_header.status
        p http.response_header
        p http.response
        EventMachine.stop
        p "________"
      }
    }
    redirect_to :action => 'index'
  end
  
end
