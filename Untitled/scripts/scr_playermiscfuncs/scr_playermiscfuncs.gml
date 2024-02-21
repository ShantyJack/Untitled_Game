


#region ARRAYS --------------------------------------------------------------------------------------------


function getStunArray(){
	var hitstunArray = array_create(60, 0);
	
	for (var i=0; i<60; i++){
		//might need adjusting
		hitstunArray[i] = -sqrt(i)/2;
		
	}
	
	return hitstunArray;
}


function getChargeArray(){
	var chargeArray = array_create(attackTime, 0);
	
	for (var i=0; i<attackTime; i++){
		//magic numbers
		chargeArray[i] = power(1.05, i)*8/349;
	}
	
	return chargeArray;
}


//for the distance to travel
function getRecoilArray(){
	var recoilArray = array_create(attackTime, 0);
	
	for (var i=1; i<attackTime; i++){
		recoilArray[i] = recoilArray[i-1] + chargeArray[i];

	}
	
	return recoilArray;
}

// dont even sweat
function getRecoilJumpArray(){
	var jumpheight = 96;
	var a = 4*jumpheight/jumpArrayLength/jumpArrayLength;
	var b = 4*jumpheight/jumpArrayLength;
	//it just works
	
	var recoilJumpArray = array_create(jumpArrayLength + 1, 0);
	
	for (var i=1; i<jumpArrayLength; i++){
		recoilJumpArray[i] = -a*i*i + b*i;
	}
	
	return recoilJumpArray;
	
}


#endregion



function gameOver(){
	audio_play_sound(snd_die, 10, false);
	room_restart();
}


#region PAUSING -------------------------------------------------------------------------------


function pauseActions(){
	stateHolder = state;
	state = function(){
		return 0;	
	}
	paused = true;
	
}


function unpauseActions(){
	state = stateHolder;
	//don't need to empty stateholder, because it will just be written over
	paused = false;

}


function togglePause(){
	if (paused){
		unpauseActions();
		
	}else{
		pauseActions();
	
	}
}

#endregion



#region DRAWING --------------------------------------------------------------------------------------


function player_drawSelfOffset(){
	draw_sprite(sprite_index, image_index, x, y - player_yOffset);
	
}


#endregion


