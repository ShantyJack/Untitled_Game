

function prompt_check_mouse_position(){
	if (device_mouse_x_to_gui(0) >= spawnX + global.textBoxOffsetX &&
		device_mouse_x_to_gui(0) <= spawnX + width + global.textBoxOffsetX &&
		device_mouse_y_to_gui(0) >= spawnY + global.textBoxOffsetY &&
		device_mouse_y_to_gui(0) <= spawnY + height + global.textBoxOffsetY){
			//do the things here
			
			promptHolder.promptFunc();
			
			//put an if statement to check if there is a next dialogue
			if (promptHolder.nextDialogue != pointer_null){
				global.currentDialogue = promptHolder.nextDialogue;
				setDialogueTimer();
			}
			
			instance_destroy(obj_prompt);
			
		}
}
