#!/bin/zsh
# This simple script compiles and runs a C++ file with a single command.
# It's useful for simple programs (single .cpp files that don't require
# linking as a part of the compilation process). I'll create a more robust
# version that can handle linking header/definition files if necessary.
#
# USAGE: To use the script globally, like a regular terminal command, you
# must add a directory containing this script to the PATH variable. The
# PATH variable tells the shell to look for terminal commands in all of
# its directories.
#
# On macOS Catalina, I made the directory /Users/justin/bin, where I save any
# *.sh files I make to run as commands in terminal. I added this directory to
# the PATH variable by adding this line:
#     export PATH=$PATH:/Users/justin/bin
# to the file:
#     /Users/justin/.zshrc
# I also made two aliases in the .zshrc file:
#   cprdo='compile_and_run.sh --overwrite true --post_delete true'
#   cpr='compile_and_run.sh'
#
# command line options:
# one positional argument:
#   $1
#     the *.cpp filename (including file extension .cpp)
# two keyword arguments:
#   --overwrite
#     false by default. any string in overwrite evaluates to true.
#     overwrites the output file, if it exists
#   --post_delete
#     false by default. any string in post_delete evaluates to true.
#     deletes the compiled file after it runs (simulate python script behavior)
# example use:
#   compile_and_run.sh helloworld.cpp --overwrite true --post_delete true
# alternatively, using the alias I defined above:
#   cprdo helloworld.cpp

zmodload zsh/zutil
zparseopts -D -E -A KWARGS -- -overwrite:=overwrite -post_delete:=post_delete
overwrite=$KWARGS[--overwrite]
post_delete=$KWARGS[--post_delete]

# Tell user to give a .cpp file (looks for .cpp files in the current directory)
if [ $# -eq 0 ]; then {
  echo "You must choose a .cpp source file. "
  if [[ ! -z "$(find *.cpp )" ]]; then {
    echo "Possible choices include:"
    echo "$(find *.cpp)"
  } else {
    echo "There are no .cpp files in the current directory."
  } fi
  exit 1
}

# Only accept one positional argument (the .cpp file)
elif [ $# -gt 1 ]; then {
  echo "Too many positional arguments. Enter only the name of the *.cpp file."
  exit 1
} fi

# Check if the source file exists in the current directory
source_file=$1
if [ ! -f "$source_file" ]; then {
  echo "Source file does not exist."
  exit 1
} fi

# Check if the output file already exists, process overwriting logic depending
# on user keyword arguments and/or user input
output_file=${source_file%.cpp}
if [ -f "$output_file" ]; then {
  if [ -z $overwrite ]; then {
    echo "There is already a compiled target."
    read "answer?Would you like to overwrite it? (y/n): "
    if [[ $answer == "n" ]]; then {
      echo "Aborted."
      exit 1
    } elif [[ $answer == "y" ]]; then {
      echo "Attempting to overwrite file."
    } else {
      echo "Please enter a valid choice."
      exit 1
    } fi
  } else {
    echo "Attempting to overwrite file."
  } fi
} fi

# If g++ fails to compile, exit the script
if ! g++ -o $output_file $source_file; then {
    echo "Target failed to build."
    exit 1
  } fi
  
# Run the newly compiled code
./$output_file

# Optionally, delete the output file after running it
if [ ! -z $post_delete ]; then {
  rm $output_file
} fi
exit 0
