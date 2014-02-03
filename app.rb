#!/usr/bin/env ruby
require 'rubygems'
require 'erb'
require 'sinatra'

# TODO: rewrite it to class
Form = <<TEXT
<form action="/post" method="POST">
Name: <input name="name" value="" size="10"><br/> 
Message: <input name="msg" value="" size="140"><br/>
<input type="submit">
</form>
<br/>
<a href=\"/stream/\">Look a stream!</a>
TEXT
Home = "<a href=\"/\">Go to home!</a>"
# General array of messages
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
		s << (erb :page, :locals => {:n => n, :page => :message,:title => "Page #{n}"})
	else
		s = "Page not found!#{Home}"
	end
	s
end

get '/' do
#  draw a form to input message
	Form
end

post '/post' do
  # check information, sended in form, to valid
	time = Time.now
	unless params[:name].empty? and params[:msg].empty?
	  if params[:msg].length <= 140 and params[:name]. length <= 10
	    # if every right, added in array messages
	    $msgs << [h(params[:name]), time,h(params[:msg])]
	    "Send success!#{Home}"
	  else
	    "Error! Big message or name: #{params[:name]} say \"#{params[:msg]}\"<br/>#{Home}}"
	  end
	else
	  "Empty!#{Home}"
	end
end

get '/stream/:page' do
	page_messages(params[:page])
end

# Browse message in array.
get('/stream/') { redirect to('/stream/1') }
