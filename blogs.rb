require 'sinatra'
require 'data_mapper'

DataMapper.setup(
	:default,
	'mysql://root@localhost/da_blog'
)

class Blog
	include DataMapper::Resource
	property :id, Serial
	property :title, String
	property :date, String
	property :content, Text #Text, :length => 500000
end

DataMapper.finalize.auto_upgrade!

get '/' do
	@page_title = "My Blog"
	@blogs= Blog.all
	erb :index	
end

get '/new' do
	@page_title = "Create a New Blog Entry"
	erb :create_blog
end

post '/create_blog' do
	# p params
	@blog = Blog.new
	@blog.title = params[:title]
	@blog.date = params[:date]
	@blog.content = params[:content]
	@blog.save
	redirect to '/'

end

get '/blog/:id' do
	@blog = Blog.get params[:id]
	@page_title = "Blog Entry"
	erb :display_blog
end

delete '/delete_blog/:id' do
	@blog = Blog.get params[:id]
	@blog.destroy
	redirect to '/'
end

get 'update_blog/:id' do
	@blog = Blog.get params[:id]
	@page_title = "Blog Edit"
	erb :update_blog
end

patch '/update/:id' do
	@blog = Blog.get params[:id]
	@blog.update title:params[:title]
	@blog.update date:params[:date]
	@blog.update content:params[:content]
	redirect to '/'
end
