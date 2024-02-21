



//if space is pressed, then set state to dodge
//call from a state when it is immediately possible to dodge
function checkDodge(){
	if (keyboard_check(vk_space)){
		if (directionInput() != pointer_invalid) lastdirection = directionInput();
		doDodge();
	}
}


//calls whichever variable function is stored in 'item', and sets item to null
//call from state when immediately possible to use item
function checkItemUse(){
	if (keyboard_check(vk_shift) && item != pointer_null){
		item();
		item = pointer_null;
	}
}


//if right mouse is pressed, then changes state to attacking
//call from state when it is immediately possible to attack
function checkAttack(){
	if (mouse_check_button(mb_right)){
		doCharge();
	}
}


function checkAttackLifted(){
	//watch the 'not'
	if (!mouse_check_button(mb_right)){
		stateValue = stateTimer;
		doAttack();
	}
	
}


//check if balance has crossed threshhold to stand
function checkIfBalanced(){
	if (balanceMag < balanceThresh){
		audio_play_sound(snd_getup, 10, false);
		doStand();
		
	}
}


//check if balance has crossed the shrekhold to be unbalanced
function checkIfUnBalanced(){
	if (balanceMag > balanceThresh){
		doUnbalance();
		
	}
}


//check if balance has crossed threshhold to fall
function checkIfFallen(){
	if (balanceMag > unbalanceThresh){
		doFall(balanceMag);
		
	}
}


//check if spacebar is pressed and then dodge in direction of balance
function checkUnBalancedDodge(){
	if (keyboard_check(vk_space)){
		doUnbalancedDodge();
	}
}

