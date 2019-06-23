require 'pathing'
class Interface
    SIZE = 32
  
    # gets an array of neighbors for the given node key
    # for this example, the node key is passed in as an array like so: [x, y]
    def neighbors_for(node_key)
      x, y = *node_key
      neighbors = []
      
      neighbors << [x-1, y] if x > 0
      neighbors << [x, y-1] if y > 0
      neighbors << [x+1, y] if x < SIZE-1
      neighbors << [x, y+1] if y < SIZE-1
      
      neighbors
    end
    
    # gets the cost for moving from node1 to node2
    def edge_cost_between(node1_key, node2_key)
      1
    end
end

graph = Pathing::Graph.new(Interface.new)
graph.path([0,0], [15, 20])

