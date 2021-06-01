require "sinatra"
require "sinatra/reloader"

get "/" do
  body = request.body.read
  p body
end