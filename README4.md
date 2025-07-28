## SHELL SCRIPTING

Upon creating a Shell_Scripting folder on the server as shown in the iamge below 

![Linux based EC2 instance](./Img4/A.png)

We wiil then proceed to navigate into the newly created folder and then using the PWD command to verify this.

![Linux based EC2 instance](./Img4/B.png)

Next up is creating the new my_first_shell_script.sh file using the VIM 

![Linux based EC2 instance](./Img4/C.png)

Upon creation, we then write shell commands to create folders using mkdir command and also creating new users using sudo useradd commands. 

![Linux based EC2 instance](./Img4/D.png)

Saving the file.

![Linux based EC2 instance](./Img4/E.png)

Verifying using PWD and ls -latr

![Linux based EC2 instance](./Img4/G.png)

Executing the .sh file with "./" method, permission is denied because the .sh file has no permission to execute during creation. 

![Linux based EC2 instance](./Img4/H.png)


# Granting the required permission using Chmod command

By using the Chmod 774 permission, this grants all permissions to users, groups and only read permission to others.

Verifying this using the ls -latr command, this shows the updated permissions for the .sh file.

![Linux based EC2 instance](./Img4/I.png)

To then execute, user password has to be provided. 

![Linux based EC2 instance](./Img4/J.png)

After successful execution of the .sh file or script. The respective folders are created and also users that are also created. 

![Linux based EC2 instance](./Img4/L.png)


## Shebang and Varaible declaration and initialization.

The image shows the shebang command in the first line of the script also variable declaration and value retrieval variable using the "Read" command.

![Linux based EC2 instance](./Img4/M.png)

Next image shows value retrieval from user 

![Linux based EC2 instance](./Img4/N.png)

Final output. 

![Linux based EC2 instance](./Img4/O.png)
