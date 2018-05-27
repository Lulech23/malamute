# MALamute
### Hi-res cover CSS generator for MyAnimeList modern templates

MALamute is a quick 'n dirty (emphasis on the dirty) application created in GameMaker Studio 2 to parse anime and manga lists from myanimelist.net and generate CSS files replacing the default, low-res cover art with higher-res versions already stored on the site. It is API-less and fetches data from HTML source, relying on MAL's modern templates which contain all needed information in a single data-items string.

The bulk of the work is done in the [obj\_mal Step event](https://github.com/Lulech23/malamute/blob/master/objects/obj_mal/Step_0.gml) using basic string operations to convert table data into properly-formatted CSS.

**[Download binaries here](https://app.box.com/s/xryh9pqzisw3di0bpvm98l6cb1m242c5)**

### Dependencies
MALamute relies on [wget for Windows](https://eternallybored.org/misc/wget/) and [SilentDOS by TGMG](http://gamemaker.cc/download/Silentdos.php) to fetch anime/manga list HTML source. These files must be included with MALamute as "wget.exe" and "cmd.dll" under a "lib" folder in the same directory as the included executable.

### Why GameMaker Studio 2?
Because GML is surprisingly useful and especially fast to write. I like to see what more I can do with it beyond making games. MALamute is a weekend project made for the heck of it. You have been warned.
