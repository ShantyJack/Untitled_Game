

//1. change state
//2. change variables
//3. change sprite
//4. play audio

//sets state to standing and sets sprite to match last input direction
//call from a state to change state to standing
function doStand(){	
	state = standing;
	balanceMag = 0;
	doSlow();
	sprite_index = walkingSprites[player_directionToSprite(lastdirection)];
}


function doSlow(){
	slowMeth = slowDownFunc;
}


function doRun(){
	state = running;
	balanceMag = 10;
}


//call to make player perform dodge
function doDodge(){
	state = dodging;
	dodgeTime = dodgeTimeArray[currentTile];
	dodgeSpd = dodgeSpdArray[currentTile];
	stateTimer = dodgeTime;
	sprite_index = fingus_newDodge;
	image_index = player_directionToSprite(lastdirection);
	audio_play_sound(snd_dodge, 10, false);
	
}


function doRoll(){
	state = rolling;
	rollTime = rollTimeArray[currentTile];
	rollSpd = rollSpdArray[currentTile];
	stateTimer = rollTime;
	sprite_index = dodgingSprites[player_directionToSprite(lastdirection)];
	
}


function doAttack(){
	
	state = rushing;
	
	/**
	stateTimer = round(recoilArray[stateTimer]/recoilSpeed);
	stateValue = round((jumpArrayLength-stateTimer)/2);
	stateModifier = recoilJumpArray[stateTimer + stateValue];
	
	sprite_index = dodgingSprites[player_directionToSprite(lastdirection)];
	player_draw = player_drawSelfOffset;
	
	currentSpeed = -recoilSpeed;
	*/
	
	currentSpeed = rushSpeed * stateTimer * stateTimer;
	//stateValue = stateTimer; // <= need this for recoil
	stateTimer = sqrt(stateTimer) / 2;
	
}


function doRecoil(){
	state = attacking;
	stateTimer = 30; //magic number
	currentSpeed = 0;
	//execcuteAttack();
	
}



function executeAttack(){
	
	audio_play_sound(snd_attack, 10, false);
		
	if (mouse_y < y){
		instance_create_layer(x,y,"wrench_layer",obj_slash);
		
	}else{
		instance_create_layer(x,y,"above",obj_slash);
		
	}
}


function doCharge(){
	state = charging;
	stateTimer = 0;
	//slowMeth = doNothing;
	lastdirection = point_direction(x, y, mouse_x, mouse_y);
	sprite_index = walkingSprites[player_directionToSprite(lastdirection)];
	
}


//
function doUnbalance(){
	state = unbalanced;
	audio_play_sound(snd_woah, 10, false);
}


function doUnbalancedDodge(){
	state = unbalancedDodging;
	lastdirection = balanceDir;
	stateTimer = 14;
	sprite_index = fingus_dodge;
	image_index = player_directionToSprite(lastdirection) * 4;
}


//change to falling state and set timer
function doFall(fallTime){
	state = fallen;
	doSlow();
	stateTimer = fallTime * fallTimeMultiplier;
	sprite_index = Sprite46;
}


function getHit(hitFactor, hitDirection){
	state = hitstun;
	stateTimer = hitFactor;
	
	sprite_index = fingus_rotate;
	image_index = player_directionToSprite(hitDirection);
}


