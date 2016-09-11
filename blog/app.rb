require "sinatra"
require "sinatra/reloader"
require "data_mapper"


enable :sessions

DataMapper.setup(:default, "sqlite://#{Dir.pwd}/blog.db")

# table name should be pluralized;
# class name should be singal;
class Post
  include DataMapper::Resource

  property :id,Serial    # An auto-increment integer key
  property :title,String    # A varchar type string, for short strings
  property :message,Text  # A DateTime, for any date you might like.


end


# DataMapper.auto_upgrade!
DataMapper.auto_upgrade!

helpers do
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == ['admin', 'admin']
  end
end


get "/" do

end

get "/blog" do
  protected!
  @posts=Post.all
  erb(:blog, {layout: :default_layout})


end

get "/posts/new" do
  protected!
  erb(:new,{layout: :default_layout})

end

post "/posts/new" do
  protected!
  Post.create(params)
  redirect to('/blog')


  # @name=params[:name]
  # erb(:thank_you,{layout: :default_layout})

end



get "/posts/:id" do |id|
  protected!
  @post=Post.get(id)

  erb(:post_detail,{layout: :default_layout})


end

get '/foo' do
  session[:message] = 'Hello World!'
  redirect to('/bar')
end

get '/bar' do
  session[:message]   # => 'Hello World!'
end

get "/lang/:language" do |language|
  session[:language]=language
  redirect to ("/blog")
end