require "sinatra"
require "sinatra/reloader"
require "data_mapper"



DataMapper.setup(:default, "sqlite://#{Dir.pwd}/my_database.db")

# table name should be pluralized;
# class name should be singal;
class Contact
  include DataMapper::Resource

  property :id,Serial    # An auto-increment integer key
  property :name,String    # A varchar type string, for short strings
  property :email,String      # A text block, for longer string data.
  property :text,Text  # A DateTime, for any date you might like.


end


# DataMapper.auto_upgrade!
DataMapper.auto_upgrade!




get "/" do
  erb(:index, {layout: :default_layout})


end

get "/contact" do
  erb(:contact,{layout: :default_layout})

end

post "/contact" do
  contact=Contact.create(params)

  @name=params[:name]
  erb(:thank_you,{layout: :default_layout})

end

get "/contactall" do

  @contacts_array=Contact.all


  erb(:contactall,{layout: :default_layout})

end

get "/contact/:id" do |id|
  @contact=Contact.get(id)
  erb(:contact_detail,{layout: :default_layout})


end