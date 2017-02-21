require( 'sinatra' )
require( 'sinatra/contrib/all' )
require( 'pry-byebug' )
require_relative('./models/pizza.rb')

# RESTful routing.  REpresentational State Transfer a standard for writing routes, explained in table at https://gist.github.com/dideler/10020345

# REST - CRUD
#erb files should be named the same as the RESTful actions

# INDEX - READ - all

get '/pizzas' do # REST names are plurals
  @pizzas = Pizza.all() # calling the all method for the Pizza class.  Assigned to instance variable to make it availale to erb file
  erb(:index)
end


# NEW - CREATE - get form to enter details

get '/pizzas/new' do #matches specifically to pizzas/new
  erb(:new) #just go to the page with the HTML form
end

# CREATE - CREATE - submit form

post '/pizzas' do # when post ing to /pizzas instead of a get
  @pizza = Pizza.new(params) #Pizza.new should take strings as keys, params has symbols.  params is special and can convert between the two automatically
  @pizza.save 
  erb(:create) #go to a confirmation page
  #redirect to '/pizzas/' #would take the user to the list of all orders
end

# EDIT - UPDATE - create form for new details

get '/pizzas/:id/edit' do
  @pizza = Pizza.find(params[:id])
  erb(:edit)
end

# UPDATE - UPDATE - submit form

post '/pizzas/:id' do 
  pizza = Pizza.new(params) #create a new pizza from the edited form, params includes the old id which is put into the new object
  pizza.update() #updates the database at the pizza id with the edited values
  redirect to "/pizzas/#{pizza.id}" #needs "" for string interpolation
end

# DESTROY - DELETE

post '/pizzas/:id/delete' do
  pizza = Pizza.find(params[:id])
  pizza.delete()
  redirect to '/pizzas/:id'
end

# SHOW - READ - find by id

get '/pizzas/:id' do 
#puts id from address bar into params[:id] :id tells sinatra to put whatever is after that / in params as :id, just id will not work.  This could be anything, but we expect an id
  @pizza = Pizza.find(params[:id]) 
  #use the find method to find a pizza with the id matching the param id
  erb(:show)
end 
#at the bottom because sinatra reads top to bottom.  This route matches pizzas/ANYTHING, so this would block any pizzas/anything_else below it