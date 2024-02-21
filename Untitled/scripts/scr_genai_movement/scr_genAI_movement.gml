


function gen_movingToPoint(){
	//gen_checkPath();
	//target[0] = mouse_x;
	//target[1] = mouse_y;
	
	var straightDir = (point_direction(x, y, target[0], target[1])) % 360;
	
	var angleDif = angle_difference(currentDir, straightDir);
	var dirOffset = dsin(angleDif) * currentSpeed;
	
	
			
	if (abs(dirOffset) <= accel[currentTile]){
		var accelerationDir = ((180 + straightDir + 90 * gen_sign(dirOffset)) + (90 - arcsin(abs(dirOffset) / accel[currentTile])) * gen_sign(dirOffset)); //bet you cant figure it out lmao
		
	}else{
		var accelerationDir = (straightDir - sign(dirOffset) * 90);
		//var accelerationDir = straightDir;
		//currentSpeed = 0;
		
	}
	
	accelerationDir = accelerationDir % 360;
	var directionReflector = floor(abs(accelerationDir - straightDir) / 180) * 180;
	//drawDir = (straightDir + accelerationDir)/2;
	
	//gen_addAccel((straightDir * scooby + accelerationDir * (1 - scooby)), accel[currentTile]);
	gen_addAccel((straightDir*scooby + accelerationDir*(1-scooby)) + directionReflector, accel[currentTile]);
	
	gen_moveForward();
	
	
}


function gen_sign(num){
	num = num & -1;
	num = num | 1;
	
	return num;
}


function gen_checkPath(){ 
	if (point_distance(x, y, target[0], target[1]) < global.collisionTileSize / 2){
		point++;
		target = path[point];
		
	}
	
}


function gen_addAccel(dir, accel){
	//drag has to be first
	gen_addDrag();
	
	var x1 = currentSpeed * dcos(currentDir) + accel * dcos(dir);
	var y1 = -currentSpeed * dsin(currentDir) - accel * dsin(dir);
	
	currentSpeed = point_distance(0, 0, x1, y1);
	currentDir = point_direction(0, 0, x1, y1);
	
}


function gen_addDrag(){
	
	if (currentSpeed > topSpeed[currentTile]){
		
		currentSpeed -= min(
			abs(currentSpeed)*currentSpeed * drag[currentTile],
			currentSpeed - topSpeed[currentTile] + accel[currentTile]);
		
	}else{ 
		currentSpeed -= abs(currentSpeed)*currentSpeed*drag[currentTile];
		
	}
	
	
}


function gen_moveForward(){
	
	var xMove = gen_checkX(currentSpeed * dcos(currentDir));
	var yMove = gen_checkY(currentSpeed * dsin(currentDir));
	
	
	x += xMove;
	y -= yMove;
	
	
	currentTile = tilemap_get_at_pixel(collisionMap, x, y);
}


function gen_checkX(xMove){
	if (tilemap_get_at_pixel(collisionMap, x + xMove, y) == 1){
		
		x -= x mod global.collisionTileSize;
		
		if (sign(xMove) == 1) x += global.collisionTileSize - 1;
		
		xMove = 0;
	}
	
	return xMove;
	
}


function gen_checkY(yMove){
	if (tilemap_get_at_pixel(collisionMap, x, y - yMove) == 1){
		
		y -= y mod global.collisionTileSize;
		
		if (sign(yMove) == -1) y += global.collisionTileSize - 1;
		
		yMove = 0;
	}
	
	return yMove;
	
}