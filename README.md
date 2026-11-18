# RunnerAsHelper

RunnerAsHelper is a small utility that generates a .bat runner and a desktop shortcut for an existing Windows shortcut.

It creates the runner batch file in the target application's directory and configures it to launch the application under a specified Windows user account with restricted privileges. (note that you have to create the user and set the privileges, for example only have access to one folder.)

This is useful for running games or applications that you don't fully trust under a separate, less-privileged user account, helping limit their access to your system.

# Configuration

The Windows username is configured in shmc.ps1.

# Usage

Simply drag and drop a Windows shortcut (.lnk) onto shmc.bat.

RunnerAsHelper will automatically:

Extract the target application and its launch parameters.

Generate a runner batch file in the target directory.

Create a desktop shortcut using the original application's icon.
