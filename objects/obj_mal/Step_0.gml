/// @description Process lists

//Pause process between operations to allow time for output to draw
if (wait > -1) {
	scroll = 0;
	wait -= 1;	
}

//Get list
if (wait == 1) {
	//Check for existing user data
	ini_open("user.ini");
	dir_anime = ini_read_string("USER", "dir_anime", program_directory);
	dir_manga = ini_read_string("USER", "dir_manga", program_directory);
	fname_anime = ini_read_string("USER", "fname_anime", "cover_anime.css");
	fname_manga = ini_read_string("USER", "fname_manga", "cover_manga.css");
	uname = ini_read_string("USER", "uname", "");
	ini_close();

	//Get MAL username
	uname = get_string("Please enter your MyAnimeList username (case-sensitive):", uname);
	
	//Skip if username is not input
	if (uname = "") {
		output += "\n\nUser not specified. Try again? (Y/N)";
		wait = -1;
		exit;
	}

	//Get list type
	if (show_question("Convert anime list instead of manga list?\n\n(Choose 'no' for manga list)")) {
		type = "anime";
	} else {
		type = "manga";
	}
	
	//Output selection to display
	output += "\n\nList selected:\n\n" + url + type + "list/" + uname + "\n\nPlease wait (this could take a while)...";
}

//Process list
if (wait == 0) {
	//Fetch list
	cmd("", "cd /d \"" + program_directory + "\\lib\" & wget.exe -O \"%APPDATA%\\MALamute\\tmp\\list.html\" " + url + type + "list/" + uname + "?status=7");

	//Parse list
	if (file_exists("tmp\\list.html")) {
		//Open the list file
		file = file_text_open_read("tmp\\list.html");
	
		//Initialize reading file
		str = "";
		
		//Ensure list data exists
		if (file_text_read_string(file) == "") {
			output += "\n\nError fetching list. Try again? (Y/N)";
			wait = -1;
			exit;
		}
	
		//Get list table data
		while (string_count("<table class=\"list-table\" data-items=\"", str) == 0) {
			str = file_text_readln(file);	
			
			//Break loop if table data is not found
			if (file_text_eof(file)) {
				output += "\n\nError parsing list data!";
				break;
			}
		}
	
		//Close and delete the list file
		file_text_close(file);
		file_delete("tmp\\list.html");
	
		//Convert HTML notation to literals
		str = string_replace_all(str, "&quot;", "\"");
		str = string_replace_all(str, "\\/", "/");
	
		//Strip image thumbnails
		str = string_replace_all(str, "r/96x136/", "");
	
		//Separate list entries
		str = string_replace_all(str, "\"" + type + "_url\"", "\n\"" + type + "_url\"");
		str = string_replace_all(str, ",\"is_added_to_list\"", "\n,\"is_added_to_list\"");
	
		//Strip list table data
		str = string_delete(str, 1, string_pos("\"" + type + "_url\"", str) - 1);
		
		//Backup string to temp string
		str_temp = str;
		str = "";

		//Strip list entry data
		while (string_count(",\"is_added_to_list\"", str_temp) > 0) {
			//Copy cover data to main string
			str = str + string_copy(str_temp, 1, string_pos(",\"is_added_to_list\"", str_temp) - 1);
			
			//Delete cover data from temp string
			str_temp = string_delete(str_temp, 1, string_pos(",\"is_added_to_list\"", str_temp) - 1);
			
			//Delete extra data from temp string
			if (string_count("\"" + type + "_url\"", str_temp) > 0) {
				str_temp = string_delete(str_temp, 1, string_pos("\"" + type + "_url\"", str_temp) - 1);
			} else {
				//End process when all data is parsed
				str_temp = "";
			}
		}
	
		//Convert HTML to CSS
		str = string_replace_all(str, "\"" + type + "_url\":\"", ".list-table .list-table-data .data.image a[href*=\"");
		str = string_replace_all(str, ",", "] {\r");
		str = string_replace_all(str, "\"" + type + "_image_path\":", "    background: url(");
		str = string_replace_all(str, ".list-table ", ");}\r\r.list-table ");
		str = string_replace(str, ");}\r\r.list-table ", ".list-table ");
		str = string_replace_all(str, "\\u", "\\");
		str = string_replace_all(str, "\\221a", "√"); //Special fix for Tokyo Ghoul - technically shouldn't be necessary, but it is
		str = str + ");}";
		
		//Format CSS
		while (string_count(");}", str) > 0) {
			//Remove excess linebreaks
			str = string_delete(str, string_pos(");}", str) - 1, 1);
			
			//Remove access tokens from URLs
			str = string_delete(str, string_pos(".jpg?s=", str) + 4, string_pos(");}", str) - string_pos(".jpg?s=", str) - 5);
			
			//Add CSS background properties
			str = string_replace(str, ");}", ") no-repeat center center / 100%;\r}");
		}
		
		//Hide original covers
		str = str + "\r\rbody." + type + " .list-table .list-table-data .data.image a img {\r    position: relative;\r    z-index: -1;\r}";
		
		//Get default directory and filename based on list type
		if (type == "anime") {
			dir = dir_anime;
			fname = fname_anime;
		} else {
			dir = dir_manga;
			fname = fname_manga;
		}
	
		//Get save file destination
		file = get_save_filename_ext("CSS Style Sheets|*.css", fname, dir, "Select a save location...");

		//Skip process if canceled
		if (file = "") {
			output += "\n\nOperation cancelled. Try again? (Y/N)";
			wait = -1;
			exit;
		}

		//Save user data
		ini_open("user.ini");
		if (type == "anime") {
			ini_write_string("USER", "dir_anime", filename_dir(file));
			ini_write_string("USER", "fname_anime", filename_name(file));
		} else {
			ini_write_string("USER", "dir_manga", filename_dir(file));
			ini_write_string("USER", "fname_manga", filename_name(file));
		}
		ini_write_string("USER", "uname", uname);
		ini_close();
		
		//Write final file
		file = file_text_open_write(file);
		file_text_write_string(file, str);
		file_text_close(file);
		
		//Output result to display
		output += "\n\nOperation complete. Process another list? (Y/N)";
	} else {
		//Output error to display if list file was not found
		output += "\n\nError fetching list. Try again? (Y/N)";
	}
}