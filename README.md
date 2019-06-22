# GoEat
You are going to make a command line app called “Go-Eat”. The app consists of drivers, stores, and a user. Every driver rated in the form of decimal number in the range of 0.0 to 5.0 and they will initially have 0 point of rating when the program runs for the first time. Each store has a menu which consists of item(s). The map which the user, drivers, and stores are placed on will be generated randomly and must be guaranteed that there is at least a path that can be taken for each driver to go to every store before finally proceeding to the user. Any additional logical assumptions is allowed.

## GoEat V1

### NameFile: go_eat_v1.rb

### Notes:
- The app only can be executed with no arguments

### Function:
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

### Function:
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

## GoEat V3

### NameFile: go_eat_v3.rb

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

### Function:
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