




//returns the direction being input, returns null pointer if no direction held
function directionInput(){
	/**								[[[LEGACY]]]
	var keyDir = going.nowhere;
	
	if (keyboard_check(ord("D"))) keyDir += 1;

	if (keyboard_check(ord("A"))) keyDir -= 1;

	if (keyboard_check(ord("W"))) keyDir += 3;

	if (keyboard_check(ord("S"))) keyDir -= 3;

	return keyDir;
	*/
	
	var xDir = 0;
	var yDir = 0;
	
	
	if (keyboard_check(ord("D"))) xDir += 1;

	if (keyboard_check(ord("A"))) xDir -= 1;

	if (keyboard_check(ord("W"))) yDir -= 1;

	if (keyboard_check(ord("S"))) yDir += 1;
	
	if (xDir == 0 && yDir == 0){
		return pointer_invalid;
		
	}else{
		return point_direction(0, 0, xDir, yDir);
		
	}
}


function playerMove(){
	
	player_addAccelerationToMovementVariables(directionInput(), accel[currentTile]); 
	player_translateMovementVariables();
	
	sprite_index = walkingSprites[player_directionToSprite(lastdirection)];
	
	player_updateRunningSprite();
}


function player_updateRunningSprite(){
	image_index += currentSpeed * 0.02;
}


function player_addAccelerationToMovementVariables(newDir, newAccel){
	//drag has to be first
	player_addDragToMovementVariables();
	
	var x1 = currentSpeed * dcos(lastdirection) + newAccel * dcos(newDir);
	var y1 = -currentSpeed * dsin(lastdirection) - newAccel * dsin(newDir);
	
	currentSpeed = point_distance(0, 0, x1, y1);
	lastdirection = point_direction(0, 0, x1, y1);
}


function player_addDragToMovementVariables(){
	//abs function allows drag to be added to negative speeds
	//also this is dumb, good luck
	
	if (currentSpeed > topSpeed[currentTile]){
		
		currentSpeed -= min(
			abs(currentSpeed)*currentSpeed*drag[currentTile],
			currentSpeed - topSpeed[currentTile] + accel[currentTile]);
		
	}else{ 
		currentSpeed -= abs(currentSpeed)*currentSpeed*drag[currentTile];
		
	}
	
	
	
}


function player_translateMovementVariables(){
	playerTranslate(currentSpeed, lastdirection);
}


//change player translate to take x and y coords.
function playerTranslate(moveSpd, moveDirection){
	
	//		 weezer
	//
	//  0  0  0  0
	//  |  |  |  |
	//  /\ /\ /\ /\
	//
	var xMove = playerCheckXCollision(moveSpd * dcos(moveDirection));
	
	var yMove = playerCheckYCollision(moveSpd * dsin(moveDirection));
	
	
	x += xMove;
	y -= yMove;
	
	currentTile = tilemap_get_at_pixel(collisionMap, x, y);
}



//checks collision for x direction, returns updated x move speed
function playerCheckXCollision(xMove){
	if (tilemap_get_at_pixel(collisionMap, x + xMove, y) == 1){
		
		x -= x mod global.collisionTileSize;
		
		if (sign(xMove) == 1) x += global.collisionTileSize - 1;
		
		xMove = 0;
	}
	
	return xMove;
}


//checks collision for y direction, returns updated y move speed
function playerCheckYCollision(yMove){
	//if the y speed collides with tilemap
	if (tilemap_get_at_pixel(collisionMap, x, y - yMove) == 1){
		
		y -= y mod global.collisionTileSize;
		
		if (sign(yMove) == -1) y += global.collisionTileSize - 1;
		
		yMove = 0;
	}
	
	return yMove;
}


//converts a 0-360 direction into an integer 0-8
function player_directionToSprite(playerDir){
	return round((playerDir%360)/45);
	//doesnt acount for pointers
}


function standingFunc(){
	if (directionInput() != pointer_invalid){ 
		doRun();
	}
	
	checkAttack();
	checkItemUse();
	checkDodge();
}


function slowDownFunc(){
	//add sprite control in here at some point so it doesn't just look like player is sliding on the floor
	player_addDragToMovementVariables();
	player_translateMovementVariables();
	
	player_updateRunningSprite();
	
	if (currentSpeed < stopThreshold){
		currentSpeed = 0;
		slowMeth = doNothing;
		
		sprite_index = fingus_rotate;
		image_index = player_directionToSprite(lastdirection);
	}
}

