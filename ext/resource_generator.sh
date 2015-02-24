#!/bin/bash
#
# Given content like the following passed as the first argument
# this should build the methods needed to write most of the convection
# code for you.  You will have to do some massaging of the method names,
# but this takes most of the grunt work out.
# 
# Example:
# % . ./resource_generator.sh
# or add it to your .profile
# 
# % resource_generator ""Count" : String,
#"Handle" : String,
#"Timeout" : String"
#echo $1 | sed "s/\"//g" | cut -d ':' -f 1
#echo $1 | sed "s/\"//g" | cut -d ':' -f 1 | tr -d ' ' | xargs -I {} printf "def {}\(value\)\n  property\(\'{}\', value\)\nend\n\n"


resource_generator() {
    echo $1 | sed "s/\"//g" | cut -d ':' -f 1 | tr -d ' ' | xargs -I {} printf "def {}\(value\)\n  property\(\'{}\', value\)\nend\n\n"
}
