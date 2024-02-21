


function a_init_pathfinder(){
	
	a_reset_pathfinder();
	
	collisionMap = layer_tilemap_get_id(layer_get_id("collision_layer"));
	a_weights = [1, infinity, 6/2, 6/7, 6/7, 6/4, 6/5]; //magic numbers
	a_heuristic = a_getHeuristicTable();
	
}


function a_reset_pathfinder(isNear){
	a_init_grid(isNear);
	a_init_heap();
}


function a_updatePath(isNear){
	
	a_reset_pathfinder(isNear)
	
	goal = targetFunc();
	
	var start = a_getStart();
	a_grid[start[0]][start[1]][ap.calculated] = 0;
	a_heap_insert(start[0], start[1]);
	
	var looping = true;
	var current = a_heap_getMin();
	var neighbors = [0]; //supposed to be like this
	
	//show_debug_message("start: (" + string(start[0]) + ", " + string(start[1]) + ")");
	//show_debug_message("goal: (" + string(a_getGoal()[0]) + ", " + string(a_getGoal()[1]) + ")");
	//show_debug_message("");
	
	while (looping){
		
		//show_debug_message("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
		//show_debug_message("");
		//show_debug_message("current: (" + string(current[0]) + ", " + string(current[1]) + ")");														//debug
		//show_debug_message("G score: " + string(a_getGridEstimate(current[0], current[1])));
		//show_debug_message("");
		//updating current node happens at the end of the loop
		
		neighbors = a_getNeighbors(current[0], current[1]);
		
		for (var i = 0; i < array_length(neighbors); i++){
			
			//show_debug_message("neighbor" + string(i) + ": (" + string(neighbors[i][0]) + ", " + string(neighbors[i][1]) + ")");						//debug
			
			if (a_isNotTraversibleOrClosed(neighbors[i][0], neighbors[i][1])){
									
			}else{
				var heapIndex = a_isInHeap(neighbors[i][0], neighbors[i][1]);
				
				if (heapIndex != -1){//where did it all go so wrong
					//show_debug_message("cell is in heap");																								//debug
					if (a_pathIsShorter(neighbors[i][0], neighbors[i][1], a_getGridEstimate(neighbors[i][0], (neighbors[i][1])))){
						a_setCalculated(current[0], current[1], neighbors[i][0], neighbors[i][1]);
						a_heap_bubbleUp(heapIndex);
						
						//show_debug_message("new path is shorter");																						//debug
						//show_debug_message("new G score: " + string(a_getGridEstimate(neighbors[i][0], (neighbors[i][1]))));	
						
						
					}else{
						//show_debug_message("new path is NOT shorter");																					//debug
					}
				}else{
					a_setCalculated(current[0], current[1], neighbors[i][0], neighbors[i][1]);
					a_heap_insert(neighbors[i][0], neighbors[i][1]);
					//show_debug_message("cell is NOT in heap");																							//debug
					//show_debug_message("G score: " + string(a_getGridEstimate(neighbors[i][0], (neighbors[i][1]))));	
					
				}
			}
			//show_debug_message("");																														//debug
		}
		
		current = a_heap_getMin();
		
		if (current[0] == goal[0] && current[1] == goal[1]){
			looping = false;
		}
		
	}
	
	a_findPath(start);
	
}

//return boolean based on whether given tile is in closed or not traversible
function a_isNotTraversibleOrClosed(xCoord, yCoord){
	if (a_grid[xCoord][yCoord][ap.discovered] == 2	or 
		a_getWeight(xCoord, yCoord) == infinity		or 
		a_isOnEdge(xCoord, yCoord)){
		
		if (a_grid[xCoord][yCoord][ap.discovered] == 2) show_debug_message("already closed");
		
		if (a_getWeight(xCoord, yCoord) == infinity	or a_isOnEdge(xCoord, yCoord)) show_debug_message("not traversible");	
		
		return true;
	}else{
		return false;
	}
}





function a_isOnEdge(xCoord, yCoord){
	if (xCoord == 0					or
		xCoord == a_gridSizeX - 1	or
		yCoord == 0					or
		yCoord == a_gridSizeY - 1){
	
		return true;
	}else{
		return false;	
	}
	
}


//check if given coordinates are in the heap, return coordinates, or -1 if not in heap
function a_isInHeap(xCoord, yCoord){
	return a_grid[xCoord][yCoord][ap.heapIndex];
}

//check if the value is smaller than the calculated path at the given coords
function a_pathIsShorter(xCoord, yCoord, value){
	if (value < a_getGridEstimate(xCoord, yCoord)){
		return true;
	}else{
		return false;
	}
}


function a_getHeuristicTable(){
	var table = array_create(a_gridSizeX - 1, []);
	
	for (var i = a_gridSizeX - 1; i >= 0; i--){
		var column = array_create(a_gridSizeY, 0);
		table[i] = column;
		
		for (var j = a_gridSizeY - 1; j>= 0; j--){
			table[i][j] = a_distance(i, j);
		}
	}
	
	return table;
}


function a_distance(length, height){
	return sqrt(length*length + height*height);
	
}

//follows the calculated path back, then breaks it into segments, then returns an array of points
function a_findPath(startPoint){
	//start by getting set of points that lead back
	//then create a new list containing only the corner coords
	//then update the points based on where they lead and return that array
	
	path = array_create(1, [0,0]);
	path[0] = goal;
	
	var looping = true;
	
	while (looping){
		var neighbors = a_getNeighbors(path[array_length(path) - 1][0], path[array_length(path) - 1][1]);
		var place = 0;
		var val = infinity;
		
		for (var i = 0; i < 4; i++){
			if (a_grid[neighbors[i][0]][neighbors[i][1]][ap.calculated] < val){
				val = a_grid[neighbors[i][0]][neighbors[i][1]][ap.calculated];
				place = i;
			}
			
		}
		
		path[array_length(path)] = [neighbors[place][0], neighbors[place][1]];
		show_debug_message("(" + string(neighbors[place][0]) + ", " + string(neighbors[place][1]));
		
		
		if (path[array_length(path) - 1][0] == startPoint[0] && path[array_length(path) - 1][1] == startPoint[1]){
			looping = false;
		}
	}
	
	//prune hallways
	
}