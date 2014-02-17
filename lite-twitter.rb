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
	session[:name] = params[:name]
	unless (params[:name].empty?) or (params[:msg].empty?)
		if params[:msg].length <= 140 and params[:name].length <= 10
			added_message(h(params[:name]), h(params[:msg]))
			notification("Send success!")
			redirect to('/stream/')
		else
			erb :post, :locals => {:msg => params[:msg], :error => "Big message or name!<br/>", :title => "Error!" }
		end
	else
		erb :post, :locals => {:msg => params[:msg], :error => "Empty!", :title => "Error!" }
	end
end
# Stream messages page
get '/stream/:page' do
	page = params[:page].to_i
	if last_post_id == nil
		erb :form, :locals => { :title => "Added a first message!" }
	elsif (page.integer?) and (page>0) and (last_post_id >= ((page-1) * 10))
		@messages = get_posts(last_post_id-(last_post_id*(page-1))-10..last_post_id-(last_post_id*(page-1))).reverse
		erb :stream, :locals => {:page => page, :title => "Page #{page}"}
	else
		halt 404
	end
end

get('/stream/?') { redirect to('/stream/1') }

error 404 do
	erb :not_found, :layout => false
end
