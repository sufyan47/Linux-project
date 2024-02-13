#!/bin/bash

#note:use "sudo ./usermanagement" to run file  

# Function to display usage information and available options
function display_usage {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -c, --create          Create a new user account."
    echo "  -d, --delete     	  Delete an existing user account."
    echo "  -r, --reset      	  Reset password for an existing user account."
    echo "  -l, --list       	  List all user accounts on the system."
    echo "  -cg, --creategrp     Create a new group."
    echo "  -ug, --adduser        Add user to group."
    echo "  -gd, --delgroup       Delete group."
    echo "  -h, --help       	  Display this help and exit."
 }

# Function to create a new user account
function create_user {
    read -p "Enter the new username: " username

    # Check if the username already exists
    if id "$username" &>/dev/null; then
        echo "Error: The username '$username' already exists. Please choose a different username."
    else
        # Prompt for password (Note: You might want to use 'read -s' to hide the password input)
        read -p "Enter the password for $username: " password

        # Create the user account
        useradd -m -p "$password" "$username"
        echo "User account '$username' created successfully."
    fi
}

# Function to delete an existing user account
function delete_user {
    read -p "Enter the username to delete: " username

    # Check if the username exists
    if id "$username" &>/dev/null; then
        userdel -r "$username"  # -r flag removes the user's home directory
        echo "User account '$username' deleted successfully."
    else
        echo "Error: The username '$username' does not exist. Please enter a valid username."
    fi
}

# Function to reset the password for an existing user account
function reset_password {
    read -p "Enter the username to reset password: " username

    # Check if the username exists
    if id "$username" &>/dev/null; then
        # Prompt for password (Note: You might want to use 'read -s' to hide the password input)
        read -p "Enter the new password for $username: " password

        # Set the new password
        echo "$username:$password" | chpasswd
        echo "Password for user '$username' reset successfully."
    else
        echo "Error: The username '$username' does not exist. Please enter a valid username."
    fi
}

# Function to list all user accounts on the system
function list_users {
    echo "User accounts on the system:"
    cat /etc/passwd | awk -F: '{ print "- " $1 " (UID: " $3 ")" }'
}

# Function to Create group
function create_group {
        # Check if group already exists

    read -p "Enter the  group: " groupname

     if grep -q "$groupname" /etc/group; then
        echo "Group $groupname already exists."
      else
        # Create the group
        groupadd $groupname
        echo "Group $groupname created successfully."
    fi
}


#Add user to group

# Function to add a user to a group
function add_user_to_group { 
    read -p "Enter the username: " username
    read -p "Enter the  group: " groupname

    if groups "$username" | grep -q "\b$groupname\b"; then
        echo "User '$username' is already a member of group '$groupname'."
    else
        usermod -aG "$groupname" "$username"
        echo "User '$username' added to group '$groupname' successfully."
    fi
}

# Function to Delete group
function delete_group {
	# Delete Group
    
    read -p "Enter the  group: " groupname

     if grep -q "$groupname" /etc/group; then
	 # Delete the group
        groupdel $groupname     
        echo "Group $groupname deleted sucessfully."
      else
        # Create does not exist
        echo "Group $groupname does not exists."
    fi
}


# Check if no arguments are provided or if the -h or --help option is given
if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    display_usage
    exit 0
fi

# Command-line argument parsing
while [ $# -gt 0 ]; do
    case "$1" in
        -c|--create)
            create_user
            ;;
        -d|--delete)
            delete_user
            ;;
        -r|--reset)
            reset_password
            ;;
        -l|--list)
            list_users
	    ;;
	-cg|--createtgrp)
	    create_group
	    ;;
	-ug|--adduser)
	    add_user_to_group	 
            ;;
	-gd|--delgroup)
            delete_group
            ;;
    
        *)
            echo "Error: Invalid option '$1'. Use '--help' to see available options."
            exit 1
            ;;
    esac
    shift
done
