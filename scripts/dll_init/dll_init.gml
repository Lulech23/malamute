/// @function dll_init()
/// @description Initializes executing Windows commands at runtime

gml_pragma("global", "dll_init();");

global.dos = external_define("lib\\cmd.dll", "RunSilent", dll_stdcall, ty_real, 2, ty_string, ty_string);
