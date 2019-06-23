def valid(a,v,r,c)
    return r>=0 && r < 10 && c>=0 && c < 10 && a[r][c] && (v[r][c]==0)
   end
   #read n,m which is no of rows and columns
   n = 10  
   m = 10
   #Read the matrix
   a = [
     [ ' ', ' ', ' ', ' ', ' ', 'X', 'X', ' ', ' ', ' ' ],
     [ 'X', ' ', ' ', ' ', ' ', ' ', 'X', ' ', 'X', ' ' ],
     [ 'X', 'X', ' ', 'X', ' ', ' ', ' ', 'X', 'X', ' ' ],
     [ ' ', 'X', ' ', ' ', ' ', 'X', ' ', ' ', 'X', ' ' ],
     [ 'X', 'X', 'X', ' ', 'X', 'X', 'X', ' ', 'X', ' ' ],
     [ ' ', 'X', ' ', ' ', ' ', 'X', 'X', ' ', ' ', 'X' ],
     [ 'X', 'X', 'X', 'X', ' ', 'X', 'X', ' ', 'X', ' ' ],
     [ 'X', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'X', 'X' ],
     [ ' ', ' ', ' ', ' ', ' ', 'X', 'X', ' ', ' ', ' ' ],
     [ 'X', 'X', ' ', 'X', 'X', ' ', ' ', 'X', 'X', ' ' ],
    ]
   #Here r and c arrays which are used to access the adjacent elements #in the matrix i.e (i+1,j),(i-1,j)(i,j+1),(i,j-1)
   r = [1,-1,0,0]
   c = [0,0,1,-1]
   #Read the source node or starting point in the matrix
   si = 0
   sj = 0
   #Read the destination point in the matrix
   di = 9 
   dj = 9
   #Create an empty array(In ruby array can be used as queue)
   q = []
   #Create an nxm matrix to store wheter the node is visited or not and #initialize its elemnts to 0
   v = Array.new(n){Array.new(m,0)}
   #Mark the starting or sorce node as Visited
   v[si][sj]=1
   #push the starting node in the queue with distance as 0
   q.push([si,sj,0])
   #Initialise min_dist variable to a maximium value
   min_dist= 1<<64
   #while queue q is not empty dequeue the starting node in the queue
   while(q != nil) do 

    tq = q.shift
   #Here tq[0]and tq[1] denotes the position in the matrix and tq[2] #denotes the distance from the starting point or node

   #If the current position the destination return min_dist and break
   if tq[0]==di&&tq[1]==dj
     min_dist = tq[2]
     break
   end
   #push the adjacent elements into the queue and repeat the process #until the destination is reached
   for k in 0...4 
     if valid(a,v,tq[0]+r[k],tq[1]+c[k])
      v[tq[0]+r[k]][tq[1]+c[k]] = 1
      q.push([tq[0]+r[k],tq[1]+c[k],tq[2]+1])
     end
    end
   end
   if min_dist != 1<<64
    puts min_dist
   else
    puts "No path exists"
   end