
function init_blood(){
	bloodCapacity = 100000;
	blood = bloodCapacity;
	bloodflow = 0;
	
	bloodFunc = doNothing;
}


function doBleed(bleed){
	blood -= bleed;
	bloodflow += bleed;
	bloodFunc = bleeding;
	
}


function bleeding(){
	bloodflow -= 80 + bloodflow * 0.001; //magic numbers 
	
	checkInjuries();
}


function doBandage(){
	bloodFunc = healing;
}


function healing(){
	bloodflow -= 8;
	blood += 8;
	
	checkInjuries();
	
}


function checkInjuries(){
	if (bloodflow <= 0){
		bloodflow = 0;
		bloodFunc = doNothing;
	}
}

