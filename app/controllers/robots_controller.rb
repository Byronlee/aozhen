# -*- coding: utf-8 -*-
require 'builder'
require 'xmlsimple'
class RobotsController < ApplicationController

  def index
  #  @config = XmlSimple.xml_in(Settings.xml_path)   
    @config = File.open(Settings.xml_path).readlines()
  end

  def create
    write_file(create_xml("defalut",params))
    redirect_to :action => 'index'
  end
  

  def command        
    send_http_request(create_xml("command",params[:optionsRadios]))
    redirect_to :action => 'index'
  end


  private
  def write_file xml_data
    open(Settings.xml_path,'w') do |f|  
      f.puts xml_data  
    end  
  end

  def send_http_request command_xml
    EventMachine.run {
      http = EventMachine::HttpRequest.new(Settings.http_request_path).post :body => command_xml
      http.errback { flash[:error]="响应请求失败！，命令没执行，从从新发送！" ; EM.stop }
      http.callback {
        flash[:success] ="响应请求成功，命令成功执行！"
        write_file http.response
        EventMachine.stop
      }
    }
  end


  def create_xml tyle,data
    xml = Builder::XmlMarkup.new( :indent => 2 )
    xml.instruct! :xml, :encoding => "UTF-8"    
    return xml.command {|d| d.value data} if tyle.eql? "command"
    xml.defalut_config do |d|
      d.length data[:lenght]
      d.widht  data[:widht]
      d.x      data[:x]
      d.y      data[:y]
      d.d      data[:d]
    end
  end
end
