

function Prompt(_startIndex, _endIndex, _promptFunc, _nextDialogue) constructor{
	startIndex = _startIndex;
	endIndex = _endIndex;
	promptFunc = _promptFunc;
	nextDialogue = _nextDialogue;
	
}


function Dialogue(_text, _promptArray) constructor{
	
	text = _text;
	promptArray = _promptArray;
	
	
	//spaceIndex stores the most recent space character in iteration
	var spaceIndex = 1;
	
	//this for loop iterates over the text from the dialogue struct, inserting newlines when the
	//width of the drawn string exceeds a maximum
	for (var i=0;i<string_length(text);i++){
		
			//if the current iteration exceeds the max width...
			if (string_width(string_delete(text, i + 1, string_length(text) - i + 1)) > global.lineLength){
				
				//if the length of the last space to current character exceeds the line length
				if (lengthOfSection(spaceIndex, i, text) > global.lineLength){
					
					//break up the current word by putting a newline in it
					text = string_insert("\n", text, i-1);
					
					//we do this so that updating the prompt indices is accurate
					spaceIndex = i;
					
				}else{
				
					//...then add a newline at the most recent space...
					text = string_insert("\n", text, spaceIndex - 1);
				}
				
				//...then update all the indices of the prompts because of the newline character
				for (var j=0; j<array_length(promptArray); j++){
					
					//you might need to add a "+1" to startIndex or spaceIndex
					if (promptArray[j].startIndex > spaceIndex) promptArray[j].startIndex++;
					
					if (promptArray[j].endIndex > spaceIndex) promptArray[j].endIndex++;
					
				}
				
			//if the current iteration does not exceed max width
			//then check if you need to update spaceIndex, otherwise, next iteration
			}else if (ord(string_char_at(text, i+1)) == 32){
				spaceIndex = i+2;	
				
			}

	}
	
}