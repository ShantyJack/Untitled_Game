
//state template
//1. direction input
//2. check if state changed
//3. check buffer
//


//standing state - checks to see if any other state is input
function standing(){
	slowMeth();
	standingFunc();
}


//running state
function running(){
	
	if (directionInput() == pointer_invalid){ 
		doStand();
		
	}else{
		playerMove();
		
	}
	
	checkAttack();
	checkItemUse();
	checkDodge();

}


//dodging state
function dodging(){
	
	stateTimer -= 1;
	
	if (stateTimer > 0){
		playerTranslate(dodgeSpd, lastdirection); 
		
	}else{
		doRoll();
			
	}
	
	//bufferedAttack();
	bufferedDodge();
	checkItemUse();
		
}


//rolling state
function rolling(){
	
	stateTimer -= 1;
	image_index = (image_index + rollSpd/13) % 4;
	
	if (stateTimer > 0){
		playerTranslate(rollSpd, lastdirection); 
		
	}else{
		useBuffer();
			
	}
	
	
	//bufferedAttack();
	bufferedDodge();
	checkItemUse();
}


//charging state
function charging(){
	stateTimer ++;
	
	/**
	currentSpeed = chargeArray[stateTimer]; 
	player_translateMovementVariables();
	player_updateRunningSprite()
	*/
	
	if (stateTimer >= attackTime - 1){
		doAttack();
	}else{
		checkAttackLifted();
	}
	
	//inrement state value
	//check if timer runout, or if attack lifted
	
}


function rushing(){
	player_translateMovementVariables();
	stateTimer --;
	
	if (stateTimer <= 0){
		doRecoil();
	}
}


//it's actually the recoil state
function attacking(){
	
	/**
	player_translateMovementVariables();
	stateTimer -= 1;
	//image_index -= .05;
	
	if (stateTimer < 0){
		player_draw = draw_self;
		player_yOffset = 0;
		useBuffer();	
	}
	
	//increase y sprite offset
	player_yOffset = recoilJumpArray[stateTimer + stateValue+1] - stateModifier;
	
	*/
	if (stateTimer <= 0){
		useBuffer();
	}else{	
		checkDodge();
	}
	
	stateTimer --;
	
}




//unbalanced state
unbalanced = function(){
	checkIfBalanced();
	unbalancedSway();
	checkUnBalancedDodge();
	bufferedAttack();
	
}


//unbalanced dodging state
unbalancedDodging = function(){
	
		stateTimer -= 1;
	
	if (stateTimer > rollTime){
		playerTranslate(dodgeSpd, lastdirection); 
		
	}else if (stateTimer > 0){
		playerTranslate(rollSpd, lastdirection); 
		
	}else{
		doFall(balanceMag*dodgingFallMultiplier);
		balanceMag = 0;
			
	}
	
	bufferedAttack();
	bufferedDodge();
	checkItemUse();

	
}


//fallen state
fallen = function(){
	
	if (stateTimer < 1){
		useBuffer();	
		
	}else{
		checkItemUse();
		bufferedAttack();
		bufferedDodge();
		slowMeth();
		
		stateTimer -= 1;
		
	}
}



//hitstun state
function hitstun(){

	if (stateTimer < 1){
		useBuffer();
		
	}else{
		currentSpeed = hitstunArray[stateTimer];
		player_translateMovementVariables();
		stateTimer--;
		
	}
	
}
