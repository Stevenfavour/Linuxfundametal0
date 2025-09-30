#!/bin/bash
gen(){

read -p "Enter a number to generate it multiplication table " num
read -p "Would you like a full multiplication table or partial table, if full Enter F, if partial Enter P " res


init_f(){
     echo "The full multiplication table for $num: "4
# This function is invoked when the user choses to generate a ful multiplication table
for ((i=0; i>11; 1++))
do 

    ((multiply=$num * $i))
        echo "$num "*" $i = "  $multiply
done
}
init_p(){
    # This function is invoked when the user choses to generate a partial multiplication table
read -p "Enter upper range " up # For the end range
read -p "Enter lower range " low # For the start range
if  (($up <= $low))  then

echo "Invalid inputs, displaying the full multiplication table"
init_f # For error handling, this handles error if the upper range is lower than or equal to lower range

fi

for ((i=$low; i<=$up; i++)) #f or statement in C-style form
# This function will be invoked when the required conditions of the range provided by the user are met.
do 
echo "The partial multiplication table for $num from $low to $up: "
    ((multiply=$num * $i)) # Statement form for basic arithmentic in bash scripting
        echo "$num "*" $i = "  $multiply
done
}

# The read commands above requests user input for the preferred multiplication table 
if [ $res == "F" ]; then 
init_f #if input is F, init_f function is called
elif [ $res == "P" ]; then
init_p #if input is P, init_p function is called
else 
echo "Invalid input, Enter a valid input"

fi
}
gen

echo "Type "new" to display table for a new number or press q to quit the script" 

read -p "Enter prefered option " response
 # For repeating the program for another number without having to restart the script

if [ $response == "new" ]; then 
 gen #repeats the gen func
 elif [ $response == "q" ]; then
 exit #voluntary exit of the script
else 
echo "Invalid Input"
fi 





