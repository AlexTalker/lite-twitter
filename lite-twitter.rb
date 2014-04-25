#!/usr/bin/env ruby
require 'erb'
require 'sinatra'
require_relative 'posts'

class LiteTwitter < Sinatra::Application
  enable :sessions
  
  # added a exploit guard
  helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end
  end
  
  # class Stream
  #   def each
  # #   $msgs.each_with_index { |item, index| yield "#{item[0]}<br/>#{item[1]}<br/>#{item[2]}<br/>---------------------------<br\>"}
  #     "<a href='/stream/1'>Go to first stream page!</a>"
  #   end
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
    posts = Posts.new
    session[:name] = params[:name]
    unless (params[:name].empty?) or (params[:msg].empty?)
      if params[:msg].length <= 140 and params[:name].length <= 10
        posts.added_message(h(params[:name]), h(params[:msg]))
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
    posts = Posts.new
    page = params[:page].to_i
    if posts.last_post_id == nil
      erb :form, :locals => { :title => "Added a first message!" }
    elsif (page.integer?) and (page>0) and (posts.last_post_id >= ((page-1) * 10))
      count = posts.last_post_id-(posts.last_post_id*(page-1))
      @messages = posts.get_posts(count - 10..count).reverse
      @last_post_id = posts.last_post_id
      erb :stream, :locals => {:page => page, :title => "Page #{page}"}
    else
      halt 404
    end
  end
  
  get '/name/:name/' do
    redirect to("/name/#{params[:name]}/1")
  end
  
  get '/name/:name/:page' do
    posts = Posts.new
    page = params[:page].to_i
    count = posts.last_user_post_id(params[:name])
    if count == nil
      notification("User not found!")
      redirect to('/stream/')
    elsif (page.integer?) and (page>0) and (count >= ((page-1) * 10))
      @messages = posts.get_posts_by_user(params[:name],page)
      erb :user, :locals => {:page => page, :title => "Page #{page}", :user_posts => count}
    else
      halt 404
    end
  end
  
  get('/stream/?') { redirect to('/stream/1') }
  
  error 404 do
    erb :not_found, :layout => false
  end
end
