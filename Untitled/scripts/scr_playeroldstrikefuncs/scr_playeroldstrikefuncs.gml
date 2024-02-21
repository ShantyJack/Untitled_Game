




//move balance in direction held, and reduce it some based on direction held,
function unbalancedSway(){
	
	//good luck figuring this one out lmao
	var dirInput = directionInput();
	
	
	if (dirInput == pointer_invalid){
		balanceMag -= rebalanceMultiplier
		
	}else{
		
		lastdirection = dirInput;
	
		var swayAngle = angle_difference(balanceDir, dirInput);
		var swayAmount = dsin(swayAngle);
	
		balanceDir -= swayMultiplier * swayAmount;
	
		balanceMag -= rebalanceMultiplier * (1 - abs(swayAmount));
	
		if (abs(swayAngle) <= 90){
			player_stumble(dcos(swayAngle));
		}
		

	}
}

//only called from unbalancedSway, dirction multiplier is how much the player is holding in the direction of imbalance
function player_stumble(directionMultiplier){
	
	var stumbleMag = 2 * accel[currentTile] * sqrt(directionMultiplier * abs((balanceMag - balanceThresh) / unbalanceThresh));
	
	playerTranslate(stumbleMag, balanceDir);
}


//calculates new vector for unbalance and checks to see if it has returned to normal
function postStrikeBalance(strength, strikeDir){
	
	var angleDif = angle_difference(strikeDir, balanceDir);
	
	//a strike in the direction of imbalance will directly increase the unbalance, 
	//but one perpindicular will result in none of the previous unbalance being added to the next state
	balanceMag = strength + balanceMag * dcos(angleDif);
	
	balanceDir = strikeDir;
	//perhaps move player a bit in the direction of balance and the strike, we'll see
	
	
}



function receiveStrike(strength, strikeDir, attackFrom){
	
	if (checkHitBlock(attackFrom) && state != fallen){
		
		postStrikeBalance(strength, strikeDir);
		
		currentSpeed = 0;
	
		checkIfUnBalanced();
		checkIfFallen();
	
	}else{
		
		gameOver();
		
	}
}


//consider making this better
function checkHitBlock(attackFrom){
	
	if (abs(angle_difference(lastdirection, attackFrom)) <= 75){
		
		return true;
		
	}else{
		
		return false;
		
	}
}



