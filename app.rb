#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
form = <<TEXT
<form action="/post" method="POST">
Name: <input name="name" value="" size="10"><br> 
Message: <input name="msg" value="" size="140"><br>
<center><input type="submit"></center>
</form>
<br\>
<a href=\"/stream/\">Look a stream!</a>
TEXT
$msgs = Array.new

get '/' do
#	"<a href=\"/h/Alex\">Press here!</a>"
	form
end

post '/post' do
	unless params[:name].empty? and params[:msg].empty?
	  if params[:msg].length <= 140 and params[:name]. length <= 10
	    $msgs << [params[:name],params[:msg]]
	    "Send success!<a href=\"/\">Go to home!</a>"
	  else
	    "Error! Big message or name: #{params[:name]} say \"#{params[:msg]}\"<br/><a href=\"/\">Go to home!</a>}"
	  end
	else
	  "Empty!<a href=\"/\">Go to home!</a>"
	end
end

class Stream
	def each
		$msgs.each { |i| yield "#{i[0]} say #{i[1]}<br\>" }
	end
end

get('/stream/') { Stream.new }

get '/ty/:name' do
	"Thank you, #{params[:name]}"
end
get '/h/:name' do |n|
	# hello world with user-frienly url
	"Hello #{n}!"
end
