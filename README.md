# GoEat
You are going to make a command line app called “Go-Eat”. The app consists of drivers, stores, and a user. Every driver rated in the form of decimal number in the range of 0.0 to 5.0 and they will initially have 0 point of rating when the program runs for the first time. Each store has a menu which consists of item(s). The map which the user, drivers, and stores are placed on will be generated randomly and must be guaranteed that there is at least a path that can be taken for each driver to go to every store before finally proceeding to the user. Any additional logical assumptions is allowed.<br />
[https://github.com/ditdittdittt/goeat](https://github.com/ditdittdittt/goeat)

## Assumptions:
- One place for one store or one driver or user
- Driver will be generated to driver's first coordinate after finish the order
- Choosen driver is the one that has shortest distance to the choosen store
- If store or user has no way condition, tha app will generate new random coordinate inside the map
- Order history will be generated once the app is closed
- Output histoy file will be generated every app's session
- Driver using BFS for the routes taken to the store and user
- If coordinate that user give is not available, the app will generate new random coordinate

## Design Decision Explanation:
- Using 2D Array to save the map so I have full control of all the coordinate in the array
- Using Array to save all of the Driver Class, so I have unique id for all the drivers and I can access it with the index<br />
Ex: `driver[0].driver_name`
- Using Array to save all of the Store Class, aso I have unique id for all the stores and I can access it with the index<br />
Ex: `store[0].store_menu`
- Using Hash to save all of the menu that store have as 'store menu', because every menu has unique name as key, and the price as value<br />
Ex: `('Shrimp' => 20, 'Meat' => 30)`
- Using Hash to save all of the menu that user choose as 'user basket', save the menu name as key, and the quantity as value<br />
Ex: `('Shrimp' => 2, 'Meat' => 2)`
- So I can call the price and quantity that user order in one code with menu name as the key
- Save all of the user order, like menu name, quantity, price and delivery fee as an Array so it has index that always incremental<br />
Ex: `order[['Shrimp',20,2,60],['Meat',30,2,60]]`
- Save all the order information as an Array that contain 'choosen driver name','choose store name','user basket','total price'<br />
Ex: `order_information['Upin','Hanamasa',user_basket,total_price]`
- Create the user order history with Array, so I can easily access the history from first to last order<br />
Ex: `user_history[0]`
- Save the taken routes by driver to the store as an Array, and to the user as an Array, and make the Hash with keys 'To Store' with values taken routes to the store, and 'To User; with values taken routes to the user


## Function:
2.1 Show Map
- The app will display the map and show where the user, stores, drivers are. 

2.2 Order Food
- Display the name of available stores to the user
- Ask user's store of choice
- User input the choice
- Display the menu that available in the choosen store
- Ask user to order
- User input all the order with the amount of the item
- Finish order
- Confirm order, if not user will input the order again and give needed changes
- Display the order information with delivery fee
- Show the taken routes by choosen driver
- User give rating to the driver
- Check driver's rating, removed if the rating under 3
- Write down the order history to text file 'history.txt'

2.3 View History
- After the app is close, the app will display all the order history

# Version Control:

## GoEat V3

### NameFile: go_eat_v3.rb

### Update: go_eat_v3.5.rb
- Fixes bug in closing the app

### Update: go_eat_v3.4.rb
- Fixes bug in write history file

### Update: go_eat_v3.3.rb
- Coordinate generator bug has been fixed
- BFS Method bug has been fixed

### Update: go_eat_v3.2.rb
- Case senstive bug fixed
- What if analysis has been applied
- Driver using BFS method to take routes to the store and user, so there no will be 'crash'

### Update: go_eat_v3.1.rb
- Case sensitive in menu order fixed to not sensitive
- Bug fixes in generating user, store, driver location inside the map

### Notes:
- The app can be executed with no arguments
- The app can be executed with 3 arguments, if only 1 argument the app will be executed with no arguments
- The app can be execited with passing filename as arguments

### Usage:
- `ruby go_eat_v3.rb`
- `ruby go_eat_v3.rb -m 25 -p 15,13`
- `ruby go_eat_v3.rb -f input.txt`
- `ruby go_eat_v3.rb -h`
```
Usage: go_eat_v3.rb [options]
-h, --help                         Show this help message
-m, --map MAP                      The size of the generated map.
-p, --position X,Y                 The user's coordinate.
-f, --filename Filename            The name of input file
```

### Input File Format:
```
Map's Size
User' Coordinate
Total Drivers
Driver's Name,Driver's Coordinate
Total Stores
Store's Name,Store's Coordinate
Total Store's Menus
Menu's Name, Menu's Price
```

### Input File Example:
```
25
10,10
4
Spiderman,3,5
Captain America,5,7
Black Panther,15,15
Black Widow,19,23
3
Sushi Tei,25,25
2
Ikan Kembung,25
Ikan Laut,20
Yoshinoya,13,15
3
Tempura,9
Ebi Furai,11
Yakiniku,13
Mujigae,23,9
4
Ramyeon,6
Topoki,8
Bibimbab,4
Kimchi,2
```
## GoEat V2

### NameFile: go_eat_v2.rb

### Notes:
- The app can be executed with no arguments
- The app can be executed with 3 arguments, if only 1 argument the app will be executed with no arguments

### Usage:
- `ruby go_eat_v2.rb`
- `ruby go_eat_v2.rb -m 25 -p 15,13`
- `ruby go_eat_v2.rb -h`
```
Usage: go_eat_v2.rb [options]
-h, --help                         Show this help message
-m, --map MAP                      The size of the generated map.
-p, --position X,Y                 The user's coordinate.
```
## GoEat V1

### NameFile: go_eat_v1.rb

### Notes:
- The app only can be executed with no arguments
