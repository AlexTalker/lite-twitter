#!/usr/bin/env ruby
require 'rubygems'
require 'erb'
require 'sinatra'

$msgs = Array.new

# added a explot guard

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

# class Stream
# 	def each
# #		$msgs.each_with_index { |item, index| yield "#{item[0]}<br/>#{item[1]}<br/>#{item[2]}<br/>---------------------------<br\>"}
# 		"<a href='/stream/1'>Go to first stream page!</a>"
# 	end
# end

def page_messages(n)
	n = n.to_i
	s = String.new
	if n.integer? and n>0 and $msgs.length >= (n-1) * 10
		s << (erb :message, :layout => :page, :locals => {:n => n, :page => :message,:title => "Page #{n}"})
	else
		s = "Page not found!#{Home}"
	end
	s
end

get '/' do
#  draw a form to input message
	erb :form, :layout => :page
end

post '/post' do
	erb :post, :layout => :page, :locals => {:time => Time.now}
end

get '/stream/:page' do
	page_messages(params[:page])
end

# Browse message in array.
get('/stream/') { redirect to('/stream/1') }
