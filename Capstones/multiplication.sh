#!/bin/bash

# Function to display the multiplication table
generate_table() {
    num=$1
    start=$2
    end=$3

    echo ""
    echo "--- Multiplication Table for $num (from $start to $end) ---"
    echo ""

    # Loop to generate the table
    for (( i=start; i<=end; i++ )); do
        result=$(( num * i ))
        printf "%-2d x %-2d = %-4d\n" "$num" "$i" "$result"
    done
    echo ""
}

# Main script logic
main_program() {
    # Prompt for the multiplication number
    echo "Enter a number for the multiplication table:"
    read -r number

    # Input validation for the main number
    while ! [[ "$number" =~ ^[0-9]+$ ]] || [[ "$number" -eq 0 ]]; do
        echo "Invalid input. Please enter a positive integer:"
        read -r number
    done

    # Prompt for full or partial table
    echo "Do you want a (F)ull table (1-10) or a (P)artial table?"
    read -r choice
    choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')

    # Default to full table if input is invalid
    if [[ "$choice" != "p" ]]; then
        generate_table "$number" 1 10
    else
        # Partial table option
        echo "Enter the starting number of the range:"
        read -r start_range

        echo "Enter the ending number of the range:"
        read -r end_range

        # Input validation for range
        if ! [[ "$start_range" =~ ^[0-9]+$ ]] || ! [[ "$end_range" =~ ^[0-9]+$ ]] || [[ "$start_range" -gt "$end_range" ]]; then
            echo "Invalid range detected. Displaying full table instead."
            generate_table "$number" 1 10
        else
            generate_table "$number" "$start_range" "$end_range"
        fi
    fi
}

# Loop to allow running the program again
while true; do
    main_program

    # Prompt to run again
    echo "Would you like to run the program again for a new number? (yes/no)"
    read -r rerun_choice
    rerun_choice=$(echo "$rerun_choice" | tr '[:upper:]' '[:lower:]')

    if [[ "$rerun_choice" != "yes" ]] && [[ "$rerun_choice" != "y" ]]; then
        echo "Exiting script. Goodbye!"
        break
    fi
    echo ""
done