
enum ap {
	heapIndex,
	calculated,
	discovered
}

function a_init_grid(isNear = true){
	
	a_gridSizeX = 11;
	a_gridSizeY = 11;
	//world coordinates of the center of (0,0), alligned with the collisionMap
	//a_gridLocation = [(x - a_gridSizeX * global.collisionTileSize / 2) + (x - a_gridSizeX * global.collisionTileSize / 2) % global.collisionTileSize + global.collisionTileSize/2,
	//				  (y + a_gridSizeY * global.collisionTileSize / 2) - (y + a_gridSizeY * global.collisionTileSize / 2) % global.collisionTileSize + global.collisionTileSize/2];
	
	if (isNear){
		targetFunc = a_getGoal;
	}else{
		targetFunc = a_getGoalFar;
	}

	
	a_gridLocation = [(x - x % global.collisionTileSize) - (a_gridSizeX - a_gridSizeX % 2 + 1) * global.collisionTileSize / 2,
					  (y + y % global.collisionTileSize) - (a_gridSizeY + a_gridSizeY % 2 - 1) * global.collisionTileSize / 2];
					  
					  
	var pathGoal = a_getGoal(); //don't change this line
	var pathStart = a_getStart();
	
	var pathXOffset = pathGoal[0] - pathStart[0];
	var pathYOffset = pathGoal[1] - pathStart[1];
	
	a_gridLocation[0] += sign(pathXOffset) * min(2, abs(pathXOffset));
	a_gridLocation[1] += sign(pathYOffset) * min(2, abs(pathYOffset));
	
	
	for (var i = a_gridSizeX - 1; i >= 0; i--){
		for (var j = a_gridSizeY - 1; j >= 0; j--){
			a_grid[i][j][ap.discovered] = 0;
			a_grid[i][j][ap.calculated] = infinity;
			a_grid[i][j][ap.heapIndex] = -1;

			
		}
	}
	
}

//return the heuristic + calculated of given index from the heap
function a_getEstimate(index){
	if (index > a_heapCapacity - 1){
		return infinity;
	}else{
		return a_getGridEstimate(a_heapX[index], a_heapY[index]);
	}
}

//return estimate based on coords
function a_getGridEstimate(xCoord, yCoord){
	return a_grid[xCoord][yCoord][ap.calculated] + a_getHeuristic(xCoord, yCoord);
}


//gets the initial weight by finding it from the specified coords in the collisionMap
function a_getWeight(xCoord, yCoord){
	return a_weights[
			tilemap_get_at_pixel(collisionMap, 
								a_gridLocation[0] + xCoord * global.collisionTileSize, 
								a_gridLocation[1] + yCoord * global.collisionTileSize)]
}


//returns the agent's current location in the pathfinding grid
function a_getStart(){
	return [round((x - a_gridLocation[0]) / global.collisionTileSize),
			round((y - a_gridLocation[1]) / global.collisionTileSize)];
}


//modifies discovered layer of grid
function a_addToOpen(xCoord, yCoord){
	a_grid[xCoord][yCoord][ap.discovered] = 1;
	
}

//modifies discovered layer of grid
function a_setClosed(xCoord, yCoord){
	a_grid[xCoord][yCoord][ap.discovered] = 2;
}

//doesn't account for arrayOutOfBounds because all the borders are impassable
function a_getNeighbors(xCoord, yCoord){
	return [[xCoord + 1, yCoord], 
		[xCoord, yCoord + 1], 
		[xCoord - 1, yCoord], 
		[xCoord, yCoord - 1]];
	
}

//set the calculated distance of the given tile
function a_setCalculated(fromX, fromY, toX, toY){
	a_grid[toX][toY][ap.calculated] = a_grid[fromX][fromY][ap.calculated] + a_getWeight(toX, toY);
}


function a_getHeuristic(xCoord, yCoord){ //multiplying by the weight makes it prefer lower weighted paths
	return a_heuristic[abs(goal[0] - xCoord)][abs(goal[1] - yCoord)] * a_getWeight(xCoord, yCoord);
}


function a_getGoal(){
	return [round((player.x - a_gridLocation[0]) / global.collisionTileSize),
			round((player.y - a_gridLocation[1]) / global.collisionTileSize)];
}


function a_getGoalFar(){
	var farGoal = a_getGoal();
	
	if (farGoal[0] < 1)					farGoal[0] = 1;
	if (farGoal[0] > a_gridSizeX - 2)	farGoal[0] = a_gridSizeX - 2;
	
	if (farGoal[1] < 1)					farGoal[1] = 1;
	if (farGoal[1] > a_gridSizeY - 2)	farGoal[1] = a_gridSizeY - 2;
	
	//todo if goal is blocked, randomly move it until it is open
	
	return farGoal;
}


