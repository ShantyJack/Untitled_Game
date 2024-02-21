

function a_init_heap(){
	
	for (var i = a_gridSizeX * a_gridSizeY - 1; i >= 0; i--){
			a_heapX[i] = infinity;
	}
	
	for (var i = a_gridSizeX * a_gridSizeY - 1; i >= 0; i--){
			a_heapY[i] = infinity;
	}
	
	a_heapCapacity = 0;
}


function a_heap_insert(insertX, insertY){
	
	//insert at end, then bubble up until reached top
	a_heapX[a_heapCapacity] = insertX;
	a_heapY[a_heapCapacity] = insertY;
	a_grid[insertX][insertY][ap.heapIndex] = a_heapCapacity;
	a_heapCapacity++;
	
	a_heap_bubbleUp();
	
	//show_debug_message("discovered = " + string(a_grid[insertX][insertY][ap.discovered]));
	
	a_addToOpen(insertX, insertY);
	
	//show_debug_message("discovered = " + string(a_grid[insertX][insertY][ap.discovered]));

}
	
//Error HAS to be here or else I don't know what's real anymore
function a_heap_getMin(){
	//return min, put most recent node at top, then bubble down, swapping with smallest
	var coords = [a_heapX[0], a_heapY[0]];
	a_setClosed(coords[0], coords[1]);
	
	a_heap_swap(0, a_heapCapacity - 1);
	a_heap_deletelast();
	
	a_heap_bubbleDown();
	
	return coords;
	
}


function a_heap_bubbleUp(index = a_heapCapacity - 1){
	//bubbles from bottom
	var bubbling = true;
	
	if (index == 0) bubbling = false;
	
	while (bubbling){
		if (a_heap_isParentlarger(index)){
			
			a_heap_swap(index, a_heap_parentIndex(index));
			index = a_heap_parentIndex(index);
			
			if (index == 0) bubbling = false;
			
		}else{
			bubbling = false;
			
		}
	}
	
}



function a_heap_bubbleDown(){
	
	var bubbling = true;
	var index = 0;
	
	bubbling = a_heap_checkBubbled(index);
	
	while (bubbling){
		
		var heapleft = a_heap_leftIndex(index);
		var heapRight = a_heap_rightIndex(index);
		
		var indexEst = a_getEstimate(index);
		var leftEst = a_getEstimate(heapleft);
		var rightEst = a_getEstimate(heapRight);
		
		if (leftEst > indexEst && rightEst > indexEst){
			bubbling = false;
			
		}else if (leftEst < rightEst){
			a_heap_swap(index, heapleft);
			index = heapleft;
			bubbling = a_heap_checkBubbled(index);
			
		}else{
			a_heap_swap(index, heapRight);
			index = heapRight;
			bubbling = a_heap_checkBubbled(index);
			
		}
		
	}
}


function a_heap_checkBubbled(index){
	if (floor(log2(index + 1)) >= floor(log2(a_heapCapacity))){
		return false;
	}else{
		return true;
	}
}


function a_heap_isParentlarger(index){
	if (a_getEstimate(index) < a_getEstimate(a_heap_parentIndex(index))){
		return true;
	}else{
		return false;	
	}
}


function a_heap_parentIndex(index){
	return floor((index - 1)/2);
}


function a_heap_leftIndex(index){
	return index*2 + 1;
}


function a_heap_rightIndex(index){
	return index*2 + 2;
}


function a_heap_swap(a, b){

	//swaps places in the heap
	a_swapFunction(a_heapX, a, b);
	a_swapFunction(a_heapY, a, b);
	
	//swaps the references to the heap in the pathfinding grid
	a_gridSwap(a, b);
	
	
}


function a_swapFunction(array, a, b){
	var holder = array[a];
	array[@ a] = array[b];
	array[@ b] = holder;
}


function a_gridSwap(a, b){//here
	
	var holder = a_grid[a_heapX[a]][a_heapY[a]][ap.heapIndex];
	
	a_grid[a_heapX[a]][a_heapY[a]][ap.heapIndex] = a_grid[a_heapX[b]][a_heapY[b]][ap.heapIndex];
	
	a_grid[a_heapX[b]][a_heapY[b]][ap.heapIndex] = holder;
}


function a_heap_deletelast(){
	a_heapX[a_heapCapacity - 1] = infinity;
	a_heapY[a_heapCapacity - 1] = infinity;
	
	a_heapCapacity--;
}
