#!/usr/bin/env ruby
require 'erb'
require 'sinatra'
require_relative 'posts'

enable :sessions

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

def notification(text)
	session[:notification] = text
end

get '/' do
	redirect to('/stream')
end

get '/notification/' do
	session[:notification] = nil
	redirect to('/stream/1')
end

post '/post' do
	unless (params[:name].empty?) or (params[:msg].empty?)
		if params[:msg].length <= 140 and params[:name].length <= 10
			added_message(h(params[:name]), h(params[:msg]))
			session[:name] = params[:name]
			notification("Send success!")
		else
			notification("Big message or name!<br/>")
			session[:name] = params[:name]
			session[:msg] = params[:msg]
		end
	else
		notification("Empty!")
	end
	redirect to('/stream/')
end
# Stream messages page
get '/stream/:page' do
	n = params[:page].to_i
	if last_post_id == nil
		erb :form, :locals => { :title => "Added a first message!" }
	elsif (n.integer?) and (n>0) and (last_post_id >= ((n-1) * 10))
		@messages = get_posts(last_post_id-(last_post_id*(n-1))-10..last_post_id-(last_post_id*(n-1))).reverse
		erb :stream, :locals => {:n => n, :title => "Page #{n}"}
	else
		halt 404
	end
end

get('/stream/?') { redirect to('/stream/1') }

error 404 do
	erb :not_found, :layout => false
end
