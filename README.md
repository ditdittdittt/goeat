# GoEat
You are going to make a command line app called “Go-Eat”. The app consists of drivers, stores, and a user. Every driver rated in the form of decimal number in the range of 0.0 to 5.0 and they will initially have 0 point of rating when the program runs for the first time. Each store has a menu which consists of item(s). The map which the user, drivers, and stores are placed on will be generated randomly and must be guaranteed that there is at least a path that can be taken for each driver to go to every store before finally proceeding to the user. Any additional logical assumptions is allowed.

## GoEat V1

### NameFile: go_eat_v1.rb

### Notes:
The app only can be executed with no arguments

### Function:
2.1 Show Map<br/>
The app will display the map and show where the user, stores, drivers are. 

2.2 Order Food<br/>
Display the name of available stores to the user<br/>
Ask user's store of choice<br/>
User input the choice<br/>
Display the menu that available in the choosen store<br/>
Ask user to order<br/>
User input all the order with the amount of the item<br/>
Finish order<br/>
Confirm order, if not user will input the order again and give needed changes<br/>
Display the order information with delivery fee<br/>
Show the taken routes by choosen driver<br/>
User give rating to the driver<br/>
Check driver's rating, removed if the rating under 3<br/>
Write down the order history to text file 'history.txt'<br/>

2.3 View History<br/>
After the app is close, the app will display all the order history 