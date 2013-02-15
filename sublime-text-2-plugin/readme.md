Description
----
This is a simple plugin for Sublime Text 2 editor that provides CAL syntax highlighting and a quick build keystroke ('f7').

Environment variables
----
In order for the build system to work the following variables must be set:

`CAL2C`
: CAL-to-C compiler, e.g. `$HOME/bin/Cal2C.jar`

`CAL_SYSTEM_DIRS`
: CAL common code, e.g. `$HOME/caltoopia/System`

`CAL_RUNTIME`
: System specific runtime, e.g. `$HOME/caltoopia/actors_rts_mac`

On OS X, see <http://stackoverflow.com/questions/135688/>
for how to make env vars available to GUI applications.

Known bugs/ToDo
----
* Scope definitions (and thus highlighting) could be further extended
* The build system assumed top to be the first network in the current file
* Selection is not preserved when building
* Error lines are not highlighted after failed build
* Better feedback during Cal2C invocation
