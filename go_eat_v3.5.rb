require 'optparse'

# This will hold the options we parse
options = {}

OptionParser.new do |parser|

  parser.banner = "Usage: go_eat_v3.rb [options]"

  parser.on("-h", "--help", "Show this help message") do ||
    puts parser
    exit
  end

  # Whenever we see -m or --map, with an
  # argument, save the argument.
  parser.on("-m", "--map MAP", "The size of the generated map.") do |m|
    options[:map] = m.to_i
  end

  # Whenever we see -p or --position, with two
  # argument, save the argument
  parser.on("-p", "--position X,Y",Array, "The user's coordinate.") do |p|
    options[:x_axis] = p[0].to_i
    options[:y_axis] = p[1].to_i
  end

  parser.on("-f", "--file Filename", "The name of input file.") do |f|
    options[:input_file] = f
  end

end.parse!

#Set default driver name, store name, and store menu
$drivers_name = ["Upin","Ipin","Mail","Jarjit","Firzi"]
$stores_name = [["Hanamasa", {"Shrimp" => 10,"Meat" => 20,"Beef" => 30}], ["Shabu Hachi", {"Shabu" => 5, "Soup" => 7, "Tempura" => 9}], ["Pak Gembus", {"Ayam Paha" => 12, "Ayam Dada" => 15, "Ayam Kampus" => 18}]]

class Map
    #Set and get method
    attr_accessor :map_size, :map

    #Define initialize
    def initialize(size=20)
        @map_size = size
        map = Array.new(size+2) { Array.new(size+2) {' '} }
        for i in 0..(size+1)
            for j in 0..(size+1)
                if (i==0 || j==0 || i==(size+1) || j==(size+1))
                    map[i][j] = '.'
                end
            end
        end
        @map = map
        map
    end

    #Define show map method
    def show_map(map=@map)
        puts "This is your map"
        for i in 0..(map.size-1)
            for j in 0..(map.size-1)
                if j==map.size-1
                    puts map[i][j]
                else
                    print map[i][j]
                    STDOUT.flush
                end
            end
        end
    end

end

class User
    attr_accessor :x_axis, :y_axis, :user_basket, :user_history

    #Define initialize
    def initialize(x_axis,y_axis)
        @x_axis = x_axis
        @y_axis = y_axis
        @user_basket = {}
        @user_history = []
    end

    #Define generate location method
    def generate_location(map)
        #If conditonal "noway"
        while (map[@x_axis-1][@y_axis] != " " && map[@x_axis+1][@y_axis] != " " && map[@x_axis][@y_axis-1] != " " && map[@x_axis][@y_axis+1] != " ") || (map[@x_axis][@y_axis] != " ")
            @x_axis = rand(1..map.size)
            @y_axis = rand(1..map.size)
        end

        #Generate coordinate in map
        map[@x_axis][@y_axis] = "User"
        map
    end

    #Define ask user where to buy method
    def choose_store(stores)
        i=0
        puts "Where do you want to buy?"
        stores.each do |store|
            puts "#{i+1}. #{store.store_name}"
            i+=1
        end
        puts "0. Exit"
        puts "Insert the number:"
        user_choice_index = gets.chomp.to_i
        if user_choice_index == 0
            #View History
            view_history

            #Save the output text file
            write_output_file(Driver.routes_taken)
            exit
        end
        choosen_store = stores[user_choice_index-1]
        puts "You choose #{choosen_store.store_name}"
        puts "\n"
        choosen_store
    end

    #Define order menu method
    def order_menu
        puts "Insert Menu Name|Quantity: (Shabu|2) and 'Ok' if you're done or 'Cancel' if you want to cancel the order"
        input = gets.chomp
        while input.capitalize != "Ok"
            if input.capitalize == 'Cancel'
                @user_basket.clear()
                #View History
                view_history

                #Save the output text file
                write_output_file(Driver.routes_taken)
                exit
            end
            order = input.split("|")
            menu = order[0].capitalize
            quantity = order[1].to_i
            @user_basket[menu] = quantity
            input = gets.chomp
        end
        puts "\n"
        @user_basket
    end

    #Define show order with quantity
    def show_basket(menu,distance)
        while @user_basket == {}
            puts "You didn't order anything yet, please order first"
            order_menu
        end
        order = []
        puts "Your Basket"
        puts "Menu|Price|Quantity|Delivery Fee"
        @user_basket.each_key do |keys|
            if menu[keys] == nil
                puts "#{keys} is not available in menu and will be remove from basket"
                @user_basket.delete(keys)
            else
                order << [keys, menu[keys], @user_basket[keys], menu[keys]*distance]
                puts "#{keys}|#{menu[keys]}|#{@user_basket[keys]}|#{menu[keys]*distance}"
            end
        end
        order
    end

    #Define store distance to the user
    def store_distance(store)
        distance = (store.x_axis - @x_axis).abs + (store.y_axis - @y_axis).abs
        distance
    end

    #Generate total price of the user's order
    def get_total_price(orders)
        total_price = 0
        orders.each do |order|
            total_price += order[1]*order[2] + order[3]
        end
        puts "Total Price: #{total_price}"
        total_price
    end

    #Ask user to finish order
    def finish_order
        puts "Are you sure with the order?[Y/N]"
        answer = gets.chomp
        if answer.capitalize == "Y"
            output = false
        elsif answer.capitalize == "N"
            output = true
        end
        puts "\n"
        output
    end

    #Get information of the order
    def get_order_information(store,driver,distance,basket,total_price)
        order = []
        order << driver.driver_name << store.store_name << basket << total_price 
        puts "Your choosen store is #{store.store_name} and located in #{store.x_axis},#{store.y_axis}"
        puts "Your location is #{@x_axis},#{@y_axis} and distance to the store is #{distance}"
        puts "Your driver name is #{driver.driver_name} with rating #{'%.2f' %driver.average_rating} and located in #{driver.x_axis},#{driver.y_axis}"
        puts "Your order:"
        puts "Name|Price|Quantity|Delivery Fee"
        basket.each do |item|
            puts "#{item[0]}|#{item[1]}|#{item[2]}|#{item[3]}"
        end
        puts "Your total price is #{total_price}"
        puts "\n"
        order
    end

    #Insert order to history
    def insert_to_history(order)
        @user_history << order
        @user_history
    end

    #Give rating to the driver
    def give_rating
        puts "Please give rating to our driver: (0.0 - 5.0)"
        @user_basket.clear
        rating = gets.chomp.to_f
        while rating < 0 || rating > 5.0
            puts "Please give valid rating from 0.0 - 5.0"
            rating = gets.chomp.to_f
        end
        rating
    end

    #See history
    def view_history
        i=1
        @user_history.each do |order|
            puts "Orderan ke: #{i}"
            puts "Restaurant: #{order[1]}"
            puts "Driver: #{order[0]}"
            puts "Your Item:"
            puts "Name|Price|Quantity|Delivery Fee"
            order[2].each do |item|
                puts "#{item[0]}|#{item[1]}|#{item[2]}|#{item[3]}"
            end
            puts "Total Price: #{order[3]}"
            puts "\n"
            i+=1
        end
        @user_history
    end

    #Write an output file
    def write_output_file(routes)
        file = File.open('history.txt','w')        
        i=1
        @user_history.each do |order|
            file.puts "Orderan ke: #{i}"
            file.puts "Restaurant: #{order[1]}"
            file.puts "Driver: #{order[0]}"
            file.puts "Your Item:"
            file.puts "Name|Price|Quantity|Delivery Fee"
            order[2].each do |item|
                file.puts "#{item[0]}|#{item[1]}|#{item[2]}|#{item[3]}"
            end
            file.puts "Total Price: #{order[3]}"
            file.puts "Routes:"
            routes[i-1].each do |id,route|
                file.puts "#{id}: #{route}"
            end
            file.puts "\n"
            i+=1
        end
        file.close
        file
    end

end

class Driver
    attr_accessor :driver_name, :x_axis, :y_axis, :average_rating, :trip
    @@routes_taken = []

    #Define initialize
    def initialize(driver_name,x_axis,y_axis)
        @driver_name = driver_name
        @x_axis = x_axis
        @y_axis = y_axis
        @average_rating = 0
        @trip = 0
        @rating = []
    end

    #Define generate location method
    def generate_location(map)
        #Check valid or not
        def valid(coordinate)
            output = coordinate == ' ' || coordinate == '.'
            output
        end

        #If conditonal "noway"
        while (!valid(map[@x_axis-1][@y_axis]) || !valid(map[@x_axis+1][@y_axis]) || !valid(map[@x_axis][@y_axis-1]) || !valid(map[@x_axis][@y_axis+1]) || !valid(map[@x_axis-1][@y_axis-1]) || !valid(map[@x_axis-1][@y_axis+1]) || !valid(map[@x_axis+1][@y_axis-1]) || !valid(map[@x_axis+1][@y_axis+1])) || (map[@x_axis][@y_axis] != " ")
            @x_axis = rand(1..map.size-2)
            @y_axis = rand(1..map.size-2)
        end

        #Generate coordinate in map
        map[@x_axis][@y_axis] = @driver_name
        map
    end

    #Routes_taken
    def self.routes_taken
        @@routes_taken
    end

    #Routes taken by driver
    def take_route(store,user,map)

        #Create validation from the coordinate function
        def valid(a,v,r,c)
            output = r>=0 && r < a.size && c>=0 && c < a.size && a[r][c] && (v[r][c] == 0)
            output
        end

        #Initialize empty array for BFS Method
        routes = []

        #Initialize core map and size
        a = map[0..map.size-1][0..map.size-1]
        n = a.size
        m = a.size

        #Create r and c arrays which are used to access the adjacent elements
        r = [1,-1,0,0]
        c = [0,0,1,-1]

        #Create source and destination coordinate
        si = @x_axis
        sj = @y_axis

        di = store.x_axis
        dj = store.y_axis

        #To the store
        #Create array as queue for BFS
        q = []

        #Create an matrix to store wheter the node is visited or not
        v = Array.new(n) { Array.new(m,0) }

        #Mark the starting point as visited
        v[si][sj] = 1

        #Push the starting point to the queue with distance 0
        q.push([si,sj,0])

        #Initialize min_dist variable to a maximum value
        min_dist = 1<<64

        #While queue q is not empty dequeue the starting node in the queue
        while (q != nil) do
            #Pop the node
            tq = q.shift

            #Insert the coordinate that taken to the array
            routes << [tq[0],tq[1],tq[2]]

            #If the current position same with the destination break
            if tq[0] == di && tq[1] == dj
                min_dist = tq[2]
                break
            end

            #Push the adjacent elements into the queue and repeat the process
            for k in 0...4
                if valid(a,v,tq[0]+r[k],tq[1]+c[k])
                    v[tq[0]+r[k]][tq[1]+c[k]] = 1
                    q.push([tq[0]+r[k],tq[1]+c[k],tq[2]+1])
                end
            end
        end

        #Create all needed array
        routes_taken = []
        routes = routes.reverse
        parent = [di,dj,min_dist]

        #Save the routes takaen to the array
        for i in 0..routes.size-1
            if routes[i][2] == parent[2]-1 && (routes[i][0] == parent[0]-1 || routes[i][0] == parent[0]+1 || routes[i][0] == parent[0]) && (routes[i][1] == parent[1]-1 || routes[i][1] == parent[1]+1 || routes[i][1] == parent[1])
                routes_taken << [routes[i][0],routes[i][1]]
                parent = [routes[i][0],routes[i][1],routes[i][2]]
            end
        end

        #Print the information of the routes taken
        store_taken_routes = []
        routes_taken.reverse.each do |route|
            if route[0] == si && route[1] == sj
                puts "driver is on the way to the store, start at (#{route[0]},#{route[1]})"
            else
                puts "go to (#{route[0]},#{route[1]})"
            end
            store_taken_routes << [route[0],route[1]]
        end
        puts "go to (#{di},#{dj}), driver arrived at the store!"
        store_taken_routes << [di,dj]

        #To the user
        routes = []

        a = map[0..map.size-1][0..map.size-1]
        n = a.size
        m = a.size
        
        r = [1,-1,0,0]
        c = [0,0,1,-1]

        si = store.x_axis
        sj = store.y_axis

        di = user.x_axis
        dj = user.y_axis

        q = []

        v = Array.new(n) { Array.new(m,0) }
        v[si][sj] = 1

        q.push([si,sj,0])

        min_dist = 1<<64

        while (q != nil) do
            tq = q.shift

            routes << [tq[0],tq[1],tq[2]]

            if tq[0] == di && tq[1] == dj
                min_dist = tq[2]
                break
            end

            for k in 0...4
                if valid(a,v,tq[0]+r[k],tq[1]+c[k])
                    v[tq[0]+r[k]][tq[1]+c[k]] = 1
                    q.push([tq[0]+r[k],tq[1]+c[k],tq[2]+1])
                end
            end
        end

        routes_taken = []
        routes = routes.reverse
        parent = [di,dj,min_dist]

        for i in 0..routes.size-1
            if routes[i][2] == parent[2]-1 && (routes[i][0] == parent[0]-1 || routes[i][0] == parent[0]+1 || routes[i][0] == parent[0]) && (routes[i][1] == parent[1]-1 || routes[i][1] == parent[1]+1 || routes[i][1] == parent[1])
                routes_taken << [routes[i][0],routes[i][1]]
                parent = [routes[i][0],routes[i][1],routes[i][2]]
            end
        end

        user_taken_routes = []
        routes_taken.reverse.each do |route|
            if route[0] == si && route[1] == sj
                puts "driver has bought the item(s), start at (#{route[0]},#{route[1]})"
            else
                puts "go to (#{route[0]},#{route[1]})"
            end
            user_taken_routes << [route[0],route[1]]
        end
        puts "go to (#{di},#{dj}), driver arrived at your place!"
        user_taken_routes << [di,dj]

        puts "\n"
        all_routes_taken = {"To store" => store_taken_routes, "To user" => user_taken_routes}
        @@routes_taken << all_routes_taken
        @@routes_taken
    end

    #Get rating from user
    def get_rating(rate)
        @rating << rate
        @trip += 1
        @average_rating = @rating.sum / @rating.size
        puts "Thank you"
        puts "\n"
        @average_rating
    end

     
end

class Store
    attr_accessor :store_name, :x_axis, :y_axis, :store_menus

    #Define initialize
    def initialize(store_name, x_axis, y_axis)
        @store_name = store_name
        @x_axis = x_axis
        @y_axis = y_axis
        @store_menus = {}
    end

    #Define generate location method
    def generate_location(map)
        #Check valid or not
        def valid(coordinate)
            output = coordinate == ' ' || coordinate == '.'
            output
        end

        #If conditonal "noway"
        while (!valid(map[@x_axis-1][@y_axis]) || !valid(map[@x_axis+1][@y_axis]) || !valid(map[@x_axis][@y_axis-1]) || !valid(map[@x_axis][@y_axis+1]) || !valid(map[@x_axis-1][@y_axis-1]) || !valid(map[@x_axis-1][@y_axis+1]) || !valid(map[@x_axis+1][@y_axis-1]) || !valid(map[@x_axis+1][@y_axis+1])) || (map[@x_axis][@y_axis] != " ")
            @x_axis = rand(1..map.size-2)
            @y_axis = rand(1..map.size-2)
        end

        #Generate coordinate in map
        map[@x_axis][@y_axis] = @store_name
        map
    end

    #Define generate store menu
    def generate_menu(menus)
        menus.each do |menu,price|
            @store_menus[menu.capitalize] = price
        end
        @store_menus
    end

    #Define show menu method
    def show_menu
        puts "#{@store_name} Menu"
        puts "Menu|Price"
        @store_menus.each do |menu,price|
            puts "#{menu}|#{price}"
        end
    end
       
end

def generate_user(map_size,*coordinate)
    if coordinate != []
        while coordinate[0] > map_size || coordinate[1] > map_size
            coordinate[0] = rand(1..map_size)
            coordinate[1] = rand(1..map_size)
        end
        user = User.new(coordinate[0],coordinate[1])
    else
        user = User.new(rand(1..map_size),rand(1..map_size))
    end
    user
end

def generate_driver(map_size,count=5)
    drivers = Array.new(count)
    for i in 0..count-1
        drivers[i] = Driver.new($drivers_name[i],rand(1..map_size),rand(1..map_size))
    end
    drivers
end

def generate_driver_location(drivers,map)
    drivers.each do |driver|
        map = driver.generate_location(map)
    end
    map
end

def generate_store(map_size,count=3)
    stores = Array.new(count)
    for i in 0..count-1
        stores[i] = Store.new($stores_name[i][0].capitalize,rand(1..map_size),rand(1..map_size))
        stores[i].generate_menu($stores_name[i][1])
    end
    stores
end

def generate_store_location(stores,map)
    stores.each do |store|
        map = store.generate_location(map)
    end
    map
end

def generate_nearest_driver(drivers,store)
    distance = []
    drivers.each do |driver|
        distance << (driver.x_axis - store.x_axis).abs + (driver.y_axis - store.y_axis).abs
    end
    nearest_driver = drivers[distance.index(distance.min)]
    nearest_driver
end

def check_driver_rating_map(drivers, map)
    drivers.each do |driver|
        if (driver.average_rating < 3.0) && (driver.trip != 0)
            map[driver.x_axis][driver.y_axis] = " "
        end
    end
    map
end

def check_driver_rating_driver(drivers)
    drivers.each do |driver|
        if driver.average_rating < 3.0 && driver.trip != 0
            drivers.delete(driver)
        end
    end
    drivers
end

def ask_repeat_order
    puts "Close the app?[y/n]"
    repeat_order = gets.chomp
    puts "\n"
    if repeat_order == "y"
        repeat_order = false
    else
        repeat_order = true
    end
    repeat_order
end

def read_map_size(file)
    map_size = file.gets.chomp.to_i
    map_size
end

def generate_user_with_data(file,map_size)
    coordinate = file.gets.chomp.split(",")
    while coordinate[0].to_i > map_size || coordinate[1].to_i > map_size
        coordinate[0] = rand(1..map_size)
        coordinate[1] = rand(1..map_size)
    end
    user = User.new(coordinate[0].to_i,coordinate[1].to_i)
    user
end

def read_drivers_total(file)
    drivers_total = file.gets.chomp.to_i
    drivers_total
end

def generate_drivers_with_data(total,file,map_size)
    drivers = Array.new(total)
    for i in 0..total-1
        driver_data = file.gets.chomp.split(",")
        while driver_data[1].to_i > map_size || driver_data[2].to_i > map_size
            driver_data[1] = rand(1..map_size)
            driver_data[2] = rand(1..map_size)
        end
        drivers[i] = Driver.new(driver_data[0].capitalize,driver_data[1].to_i,driver_data[2].to_i)
    end
    drivers
end

def read_stores_total(file)
    stores_total = file.gets.chomp.to_i
    stores_total
end

def generate_stores_with_data(total,file,map_size)
    stores = Array.new(total)
    for i in 0..total-1
        store_data = file.gets.chomp.split(",")
        while store_data[1].to_i > map_size || store_data[2].to_i > map_size
            store_data[1] = rand(1..map_size)
            store_data[2] = rand(1..map_size)
        end
        stores[i] = Store.new(store_data[0].capitalize,store_data[1].to_i,store_data[2].to_i)
        store_menu_total = file.gets.chomp.to_i
        menus = {}
        for j in 0..store_menu_total-1
            menu_data = file.gets.chomp.split(",")
            menus[menu_data[0].capitalize] = menu_data[1].to_i
        end
        stores[i].generate_menu(menus)
    end
    stores
end


#Main Application

if options[:map] && options[:x_axis] && options[:y_axis] #If have 3 arguments

    #Define map
    map = Map.new(options[:map])
    map_size = map.map_size
    user_map = map.map

    #Define user
    user = generate_user(map_size,options[:x_axis],options[:y_axis])
    user_map = user.generate_location(user_map)

    #Define drivers
    drivers = generate_driver(map_size)
    user_map = generate_driver_location(drivers,user_map)
    

    #Define stores
    stores = generate_store(map_size)
    user_map = generate_store_location(stores,user_map)

elsif options[:input_file] #If file as arguments
    #Read file
    file = File.open('input.txt','r')

    #Define map
    size = read_map_size(file)
    map = Map.new(size)
    map_size = map.map_size
    user_map = map.map

    #Define user
    user = generate_user_with_data(file,map_size)
    user_map = user.generate_location(user_map)

    #Define drivers
    total_drivers = read_drivers_total(file)
    drivers = generate_drivers_with_data(total_drivers,file,map_size)
    user_map = generate_driver_location(drivers,user_map)

    #Define stores
    total_stores = read_stores_total(file)
    stores = generate_stores_with_data(total_stores,file,map_size)
    user_map = generate_store_location(stores,user_map)

    #Close file
    file.close

else #If have no arguments

    #Define map
    map = Map.new()
    map_size = map.map_size
    user_map = map.map

    #Define user
    user = generate_user(map_size)
    user_map = user.generate_location(user_map)

    #Define drivers
    drivers = generate_driver(map_size)
    user_map = generate_driver_location(drivers,user_map)

    #Define stores
    stores = generate_store(map_size)
    user_map = generate_store_location(stores,user_map)

end


#Repeat order
repeat_order = true
while repeat_order
    #Show the map
    map.show_map(user_map)

    #Let user choose the store
    choosen_store = user.choose_store(stores)
    
    #Show user distance to the store
    user_distance = user.store_distance(choosen_store)
    
    #Search nearest driver
    choosen_driver = generate_nearest_driver(drivers,choosen_store)
    
    #Loop function for user to order
    finish_order = true
    while(finish_order)
        #Show menu of the store
        choosen_store.show_menu
    
        #Let user order item
        user_order = user.order_menu
        
        #Let user see the basket
        user_basket = user.show_basket(choosen_store.store_menus,user_distance)
        
        #Show total pricer to user
        user_total_price = user.get_total_price(user_basket)
    
        #Ask user to change the menu
        finish_order = user.finish_order
    end
    
    #Show the user information of the driver
    user_fix_order = user.get_order_information(choosen_store,choosen_driver,user_distance,user_basket,user_total_price)
    
    #Insert order to history
    user_order_history = user.insert_to_history(user_fix_order)
    
    #Show routes taken by driver
    routes_taken = choosen_driver.take_route(choosen_store,user,user_map)
    
    #Ask user for rating
    given_rating = user.give_rating
    
    #Insert rating to the driver
    choosen_driver_rating = choosen_driver.get_rating(given_rating)
    
    #Check the average rating of all drivers
    user_map = check_driver_rating_map(drivers,user_map)
    drivers = check_driver_rating_driver(drivers)
 
    
    #Repeat order
    repeat_order = ask_repeat_order

    #If there are no drivers
    if drivers.size == 0
        puts "Looking for drivers!"
        #Define drivers
        drivers = generate_driver(map_size)
        user_map = generate_driver_location(drivers,user_map)
    end

end

#View History
fix_history = user.view_history

#Save the output text file
file = user.write_output_file(Driver.routes_taken)