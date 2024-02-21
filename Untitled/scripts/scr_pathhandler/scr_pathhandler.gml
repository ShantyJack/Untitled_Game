


function init_pathHandler(){
	state = pathHandlerFunction;
	
	sightDistance = 500;
	stateTimer = 0;
	
	maxCapacity = 15;
	
	pathLoopCount = 30
	
	nearQueue = array_create(maxCapacity+1, pointer_null);
	nearQuantity = 0;
	nearPlace = 0;
		
	farList = array_create(maxCapacity+1, pointer_null);
	farQuantity = 0;
	
	combatList = array_create(maxCapacity+1, pointer_null);
	combatQuantity = 0;
	
	postedList = array_create(maxCapacity+1, pointer_null);
	postedQuantity = 0;
	
	agentHolder = pointer_null;
	functionIndex = 0;
	

	handlerArray = array_create(pathLoopCount, doNothing);
	
	handlerArray[0] = sortFar;
	handlerArray[round(pathLoopCount/2)] = pathForAgent;

	
}


function pathHandlerFunction(){
	handlerArray[functionIndex]();
	
	functionIndex = (functionIndex + 1) % pathLoopCount;
	
}


function pathForAgent(){
	if (agentHolder == pointer_null){
		pathforNear();
		
	}else{
		pathForFar();
		agentHolder = pointer_null;
		
	}
	
}


function pathforNear(){
	var agentID = popOffAgent();
	
	if (withinGrid(agentID)){
		with (agentID){
			a_updatePath(true);
		}
	}else{
		addTofar(agentID);
		yoinkFromNear((nearPlace + 14)%15);
		
	}
	
	
}


function pathForFar(){
	with (agentHolder){
		a_updatePath(false);
		
	}
	
}


//sorts the far list, checks if posted sees, and if nearlist is close enough
function sortFar(){
	
	
	for (var i=0; i<farQuantity; i++){
		var agentID = farList[i];
		
		if (withinGrid(agentID)){
			yoinkFromFar(i);
			addToNear(agentID);
		}
	}
	
	
	for (var i=0; i<postedQuantity; i++){
		var agentID = postedList[i];
		
		if (point_distance(player.x, player.y, agentID.x, agentID.y) < sightDistance){
			with (agentID){
				if (lineOfSight()){
					ai_doChase();
					
				}
			}
		}
	}
	
	
	for (var i=0; i<nearQuantity; i++){
		var agentID = nearQueue[i];
		
		if (point_distance(player.x, player.y, agentID.x, agentID.y) < agentID.attackDist){
			with (agentID){
				if (lineOfSight()){
					ai_doAttack();
					
				}
			}
		}
	}
	
}

//pleas work please work please work pelase work pleas ework
function withinGrid(agentID){
	with (agentID){	//parendthases
		if (	(a_gridSizeX - 1)/2 + 2 < abs((x - (x%global.collisionTileSize)) - (player.x - (player.x%global.collisionTileSize))) / global.collisionTileSize  ||
				(a_gridSizeY - 1)/2 + 2 < abs((y - (y%global.collisionTileSize)) - (player.y - (player.y%global.collisionTileSize))) / global.collisionTileSize){
			return false;
			
		}else{
			return true;
			
		}
		
	}
	
}



function popOffAgent(){
	var agentID = nearQueue[nearPlace];
	
	nearPlace = (nearPlace + 1) % nearQuantity;
	
	return agentID;
	
}


function removeFromNear(agentID){
	
	for (var i=0; i<farQuantity; i++){//get the agents place
		if (agentID == nearQueue[i]){
			break;
		}
	}
	
	if (nearPlace > i) nearPlace--;
	
	for (; i<nearQuantity; i++){//then remove it
		nearQueue[i] = nearQueue[(i+1)];
	}
	
	nearQuantity--;

}


function yoinkFromNear(agentIndex){
	for (; agentIndex<nearQuantity; agentIndex++){
		nearQueue[agentIndex] = nearQueue[(agentIndex+1)];
	}
	
	nearQuantity--;
	
}


function addToNear(agentID){
	nearQueue[nearQuantity] = agentID;
	nearQuantity++;
	
}


function removeFromFar(agentID){
	
	for (var i=0; i<farQuantity; i++){//get the agents place
		if (agentID == farList[i]){
			break;
		}
	}
	
	
	for (; i<farQuantity; i++){//then remove it
		farList[i] = farList[(i+1)];
	}
	
	farQuantity--;
	
}


function yoinkFromFar(agentIndex){
	for (; agentIndex<farQuantity; agentIndex++){//then remove it
		farList[agentIndex] = farList[agentIndex+1];
	}
	
	farQuantity--;
	
}


function addTofar(agentID){
	farList[farQuantity] = agentID;
	farQuantity++;
	
}


function removeFromCombat(agentID){
	
	for (var i=0; i<combatQuantity; i++){//get the agents place
		if (agentID == combatList[i]){
			break;
		}
	}
	
	
	for (; i<combatQuantity; i++){//then remove it
		combatList[i] = combatList[(i+1)];
	}
	
	combatQuantity--;
	
}


function addToCombat(agentID){
	combatList[combatQuantity] = agentID;
	combatQuantity++;
	
}




