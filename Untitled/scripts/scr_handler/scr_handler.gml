


//main dialogue function. Draws the white text, then the red prompts over it.
//when alarm0 is at 0, it will place all of the prompt objects
function drawDialogue(){
	
	drawWhiteText();
	
	drawPromptTexts();
	
	if (alarm[0] == 0) instantiatePrompts();
	
}

//called once at the end of drawing places prompt objects
function instantiatePrompts(){
		

	for (var i=0; i<array_length(global.currentDialogue.promptArray); i++){	

		var numOfPromptLines = numberOfNewlines(promptFromCurrentArray(i)) + 1;
		
		//iterates through number of lines that prompt occupies
		for (var j=0; j<numOfPromptLines; j++){
			
			if (j == 0){
				var promptX = getPromptX(i);
			}else{
				var promptX = 0;
			}
			
			var promptY = getPromptY(i) + j*textHeight;
			
			var promptText = getPromptLine(promptFromCurrentArray(i), j);
			
			var promptText = getPromptLine(promptFromCurrentArray(i), j);
			
			var promptID = instance_create_layer(0, 0, "Instances", obj_prompt);
			
			with (promptID){
				spawnX = promptX;
				spawnY = promptY;
				height = string_height(promptText);
				width = string_width(promptText);
				promptHolder = global.currentDialogue.promptArray[i];
			}
			
		}

	}
	
}


//draws the text of the prompts in red over the dialogue white text
function drawPromptTexts(){

	var numPrompts = promptsToDraw();

	//iterates through number of prompts
	for (var i=0; i<numPrompts; i++){	
		
		var numOfPromptLines = numberOfNewlines(promptFromCurrentArray(i)) + 1;
		
		//iterates through number of lines that prompt occupies
		for (var j=0; j<numOfPromptLines; j++){
			
			//if it's not the start of the prompt, then the x will always be at the start of a new line
			if (j == 0){
				var promptX = getPromptX(i);
			}else{
				var promptX = 0;
			}
			

			var promptY = getPromptY(i) + j*textHeight;
			
			var promptText = getPromptLine(promptFromCurrentArray(i), j);
			
			draw_text_color(
				textStartX + promptX, 
				textStartY + promptY, 
				promptText, 
				c_red, c_red, c_red, c_red, 1);
				
		}
		
	}
	
}


//scans a given piece of text for the number of newlines
function numberOfNewlines(text){
	var newlineCount = 0;
	
	for (var i=0;i<string_length(text);i++){
		if (isNewlineHere(text, i)){
			newlineCount++;
		}
	}
	
	return newlineCount;
}

//if a prompt is broken up by newlines, return the requested section, starting at 0
function getPromptLine(prompText, sectionNumber){
	
	var startdex = 0;
	
	var endex = string_length(prompText);


	for (var i=0;i<string_length(prompText);i++){
		
		if (isNewlineHere(prompText, i)){
			
			if (sectionNumber == 0){
				endex = i;
				break;
			}
			
			if (sectionNumber == 1){
				startdex = i+1;
				sectionNumber--;
			}
			
			if (sectionNumber > 1){
				sectionNumber--;
			}
			
		}
	}
	
	return getSectionOfText(startdex, endex, prompText);
	
}



//you don't need to add a +1 to the index in the function call because it is done in here
function isNewlineHere(text, index){
	if (ord(string_char_at(text, index+1)) == 10){
		return true;
	}else{
		return false;
	}
}


//draws the main paragraph from current dialogue.
//only prints the first 'x' characters according to the alarm0
//as alarm0 counts down, more letter appear until text is fully shown, this creates a typerwriter effect
function drawWhiteText(){
	
	draw_text(textStartX, textStartY, string_delete(
		global.currentDialogue.text,
		string_length(global.currentDialogue.text) - alarm[0]/global.dialogueSpeed + 1,
		alarm[0]/global.dialogueSpeed + 1));
}


//returns the number of prompts to be drawn
function promptsToDraw(){
	var numPrompts = 0;
	
	for (var i=0; i<array_length(global.currentDialogue.promptArray); i++){
		if (global.currentDialogue.promptArray[i].startIndex <= string_length(global.currentDialogue.text) - alarm[0]/global.dialogueSpeed + 1){
			numPrompts = i+1;
		}
	}
	
	return numPrompts;
}


//returns the x coordinate of the current dialogue text, at the start of prompt
function getPromptX(promptIndex){
	var beforePrompt = upToPromptStart(promptIndex);
	var lastline = 0; 
	
	for (var i=0;i<string_length(beforePrompt);i++){
		if (isNewlineHere(beforePrompt, i)){
			lastline = i;
			
		}
	}
	return string_width(string_delete(beforePrompt, 1, lastline));
}


//returns the y coordinate of the current dialogue text, at the start of prompt
function getPromptY(promptIndex){
	
	return string_height(upToPromptStart(promptIndex)) - textHeight;
}


//returns string with all text after the start of the prompt clipped
function upToPromptStart(promptIndex){
	
	return string_delete(
		global.currentDialogue.text, 
		global.currentDialogue.promptArray[promptIndex].startIndex + 1, 
		string_length(global.currentDialogue.text) - global.currentDialogue.promptArray[promptIndex].startIndex + 1);
}


//returns prompt text as selected from the current prompt array
function promptFromCurrentArray(index){
		return getSectionOfText(global.currentDialogue.promptArray[index].startIndex, 
		global.currentDialogue.promptArray[index].endIndex, 
		global.currentDialogue.text);
}


//returns width of a section of text in pixels
function lengthOfSection(startSection, endSection, fullText){
	
	return string_width(getSectionOfText(startSection, endSection, fullText));
}


//returns section of text
function getSectionOfText(startSection, endSection, fullText){
	//figure it out yourself, it just works like this
	return string_delete(string_delete(
				fullText, 
				endSection + 1, 
				string_length(fullText) - endSection + 1), 
			1,
			startSection)
	
}


function setDialogueTimer(){
	//
	obj_handler.alarm[0] = string_length(global.currentDialogue.text)*global.dialogueSpeed;
}

function doNothing(){
	
}

function openDialogue(newDialogue){
	obj_handler.GUIState = drawDialogue;
	global.currentDialogue = newDialogue;
	
	setDialogueTimer();
	
}

function closeDialogue(){
	obj_handler.GUIState = doNothing;
}