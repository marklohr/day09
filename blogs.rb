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
	property :content, String
end

DataMapper.finalize.auto_upgrade!

get '/' do
	@blogs = Blog.all
	erb :index	
end

get '/new' do
	erb :create_blog
end

post '/create_blog' do
	p params
	@blog = Blog.new
	@blog.title = params[:title]
	@blog.date = params[:date]
	@blog.content = params[:content]
	@blog.save
	redirect to '/'

end

get '/blog/:id' do
	@blog = Blog.get params[:id]
	erb :display_blog
end

delete 'delete_blog/:id' do
	@blog = Blog.get params[:id]
	@blog.destroy
	redirect to '/'
end
