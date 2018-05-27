/// @function cmd(prog, param)
/// @description Executes a command to run a program with optional command-line parameters
/// @param prog The program to execute. {string}
/// @param param Additional program arguments. {string}

return external_call(global.dos, argument0, argument1);
