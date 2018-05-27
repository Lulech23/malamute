/// @description Display output

//Get auto-scroll position
scroll_max = min(0, (window_get_height() - string_height_ext(output, -1, window_get_width() - 16)) - 16);

//Draw output with auto-scroll
draw_set_color($DDDDDD);
draw_text_ext(8, 8 + scroll_max + scroll, output, -1, window_get_width() - 16);
draw_set_color($FFFFFF);