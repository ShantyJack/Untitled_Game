


function init_genAI(){
	path = [[688, 501], [755, 360], [659, 773], [903, 862], [1050, 593]];
	point = 0;
	target = path[point];
	collisionMap = layer_tilemap_get_id(layer_get_id("collision_layer"));
	
	attackDist = 200;
	
	currentTile = 0;
	currentDir = 0;
	currentSpeed = 0;
	
	scooby = 0.5; // 0 - 1
	
	accel = [0.5, 0, 1.5, 0.05, 0.05, 1.5, 0.15];
	topSpeed = [6, 1, 2, 7, 7, 4, 5];
	#region dragcalc
	drag = array_create(array_length(topSpeed), 0);
	for (var i = 0; i < array_length(drag); i++){
		drag[i] = accel[i]/topSpeed[i]/topSpeed[i];
	}
	#endregion
	
	AddToHandler();
	
	state = ai_posted;
	
	slowMeth = doNothing;
	
	
}


function AddToHandler(){
	
	
}


function lineOfSight(){

}