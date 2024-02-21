


//adds attack to buffer if right mouse is clicked
//call from a state when attack can't be used in current state
function bufferedAttack(){
	if (mouse_check_button_pressed(mb_right) && buffer != doDodge){ 
		buffer = doAttack;
		
	}
}



//adds dodge to buffer if space and direction are input
//call from a state when dodge can't be performed in current state
function bufferedDodge(){
	if (keyboard_check_pressed(vk_space) && directionInput() != pointer_invalid){
		buffer = doDodge;
		lastdirection = directionInput();
	}
}


//use when action finishes
function useBuffer(){
	
	if (buffer != pointer_null){
		
		buffer();
		
		buffer = pointer_null;
		
	}else{
	
	doStand();
	}
}
