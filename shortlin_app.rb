# -*- coding: utf-8 -*-
# How to Build a Shortlink App with Ruby and Redis
# http://net.tutsplus.com/tutorials/ruby/how-to-build-a-shortlink-app-with-ruby-and-redis/
require 'sinatra'
require 'redis'
redis = Redis.new
helpers do
  include Rack::Utils
  alias_method :h, :escape_html # 在index.erb中使用了这个 h 简写
  def random_string(length)
    # 36 is the right base for alphanum (tested
    # http://stackoverflow.com/posts/3572953/revisions
    # http://blog.logeek.fr/2009/7/2/creating-small-unique-tokens-in-ruby
    rand(36**length).to_s(36)
  end
end
get '/' do
  erb :index
end
post '/' do
  # 我们这里无法让相同的url对应相同的shortcode
  # 因为shortcode是随机出来的，不是类似md5的算法那种只要输入一样输出就相同
  # 随机是输入相同输出也会不同
  # 这种方案不好的一点是，如果我post相同的一个url 100万次，就占用了100万个位置
  # 实际只需要一个
  # 这对生成验证码有好处，但对于真正的shorten url应用不合适
  # 解决这个问题，我们可以采用
  # 同时维护两个记录 url -> shortcode ;  shortcode -> url
  # like this:
=begin
  if params[:url] and not params[:url].empty?  
    if redis.get "url:#{params[:url]}"
      @shortcode = redis.get "url:#{params[:url]}"
    else
      @shortcode = random_string 5
      redis.setnx "links:#{@shortcode}", params[:url] # setnx: set if not exist
      redis.setnx "url:#{params[:url]}", @shortcode # setnx: set if not exist
    end
  end
=end
#=begin
  if params[:url] and not params[:url].empty?
    @shortcode = random_string 5
    redis.setnx "links:#{@shortcode}", params[:url] # setnx: set if not exist
  end
#=end
  erb :index
end
get '/:shortcode' do
  @url = redis.get "links:#{params[:shortcode]}"
  redirect "http://#{@url}" || '/'
  # || 是 or 啊。 
  # redirects to either the URL we grabbed out of Redis (if it exists), 
  # or redirects to the homepage if not.
end
