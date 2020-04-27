# CompileAndRun
This simple script compiles and runs a C++ file with a single command.
It's useful for simple programs (single .cpp files that don't require
linking as a part of the compilation process). I'll create a more robust
version that can handle linking header/definition files if necessary.

# Usage
To use the script globally, like a regular terminal command, you
must add a directory containing this script to the PATH variable. The
PATH variable tells the shell where to look for terminal commands.

# Adding a directory to PATH
On macOS Catalina, I made a directory `/Users/justin/bin`, where I save any
`*.sh` scripts. I added this directory to the PATH variable by adding this
line to `~/.zshrc`
```
export PATH=$PATH:/Users/justin/bin
```

I also made two aliases in the .zshrc file:
```
cprdo='compile_and_run.sh --overwrite true --post_delete true'
cpr='compile_and_run.sh'
```

# Command Line Options:
#### There's one positional argument:
```
$1
    the *.cpp filename (including file extension .cpp)
```
#### There are two keyword arguments:
```
--overwrite
    overwrite the output file, if it exists
    false by default. any string in overwrite evaluates to true.

--post_delete
    delete the output file after it runs (simulates python behavior)
    false by default. any string in post_delete evaluates to true.
```
#### Example use:
```
  compile_and_run.sh helloworld.cpp --overwrite true --post_delete true
```
###### Alternatively, using the alias I defined above:
```
  cprdo helloworld.cpp
```
