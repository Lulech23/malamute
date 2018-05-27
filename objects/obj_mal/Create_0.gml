/// @description Initialize and unpack libraries

//Initialize basic application variables
dir = "";
dir_anime = "";
dir_manga = "";
file = "";
fname = "";
fname_anime = "";
fname_manga = "";
output = @"
///////////////////////////////////////
MALamute HD Cover Generator by Lulech23
---------------------------------------
                          version 0.0.2
///////////////////////////////////////";
scroll = 0;
scroll_max = 0;
scroll_step = 22;
str = "";
str_temp = "";
type = "anime";
uname = "";
url="https://myanimelist.net/";
wait = game_get_speed(gamespeed_fps)*2;

//If temp directory does not exist...
cmd("", "if not exist \"%APPDATA%\\MALamute\\tmp\" ( " +
		//... create the directory
		"mkdir \"%APPDATA%\\MALamute\\tmp\" " +
	")"
);