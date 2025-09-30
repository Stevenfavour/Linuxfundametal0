## FUNCTION

Organizindg you cose is key to maintaining clarity and efficeincy. One powereful tecgnique to achieve this is through the use of Functions.
By encapsulating specific logic in functions improves clarity and helps to streamline your scripts. 

Considering a specific logic with and without the use and functions. 
We will consider the following logic below and then encapsulate them inside a function. 
### 1. Checking is a script has an argument
### 2. Checking if AWS CLI is installed.
### 3. Check if environmental variable exists to authenticate with AWS.


## Checking if script has an argument with and without making use of function. 

![Without function](/Img8/A.png)

The image above shows the logic code to determine if a given script has an argument. This is achieved by determining the number of arguments, if the logic returns 0 then it means the script has no argument. 

### With Fuction

![With function](/Img8/B.png)

This is a similar logic as the previous only with a check_num_of_args fuction.
The function checks the number of argument and the echoes the number of argument as environment. if and elif statements are then used to access the arguments and the action is taken depending on the type of argument provided by the user.

When a fuction is defined in a shelll script, it remians inactive until it is called or declared within the script. Rearranging the above script to helpe clarity and readability, this is what it should look like. The environment variable is now been placed at the begining of the script.

![Without function](/Img8/C.png)

Upon encapsulating the already discussed if and elif conditional statement inside the activate_infra_environment function. The refinded script will look like this. 

![Without function](/Img8/D.png)

Both functions are then called at the end of the script.

###  Checking if AWS CLI is installed.

The script below shows how this is done. 

![Without function](/Img8/E.png)

if ! command -v aws &> /dev/null; then: 
This line contains an if statement. Here's the breakdown:

!: This is the logical negation operator. It reverses the result of a command, so ! command means "If Not".

command -v aws: This command checks if the aws command is available in the system. It returns the path to the aws executable if it exists, or nothing if it doesn't. 
"Which" can also be used in place of "command -v" The y both effectively perform similar function. 

&> /dev/null: This part redirects both standard output (stdout) and standard error (stderr) to /dev/null, a special device file that discards all output. This effectively suppresses any output from the command -v command. 

then: This keyword indicates the beginning of the code block to execute if the condition in the if statement is true.

echo "AWS CLI is not installed. Please install it before proceeding.": This line prints an error message to the standard output if the AWS CLI is not installed.

return 1: This line causes the function to exit with a non-zero exit status


###  Check if environmental variable exists to authenticate with AWS.

To programmatically create resources in AWS, you need to configure authentication using various means such as environment variables, configuration files, or IAM roles.

The ~/.aws/credentials and ~/.aws/config files are commonly used to store AWS credentials and configuration settings, respectively.

Credentials File (~/.aws/credentials)

The credentials file typically contains AWS access key ID and secret access key pairs. You will have only default section at first. But you can add other environments as required. Just as we have for testing and production below.

![Without function](/Img8/F.png)

Config File (~/.aws/config)

The config file stores configuration setting for AWS services and clients.

![Without function](/Img8/G.png)

### Checking if AWS profile exists.

A profile will enable you to easily switch between different AWS configurations. If you set an environment variable by running the command export AWS_PROFILE=testing, this will pick up the configuration from both file and authenticate you to the testing environment.

AWS Profile The AWS_PROFILE environment variable allows users to specify which profile to use from their AWS config and credentials files. If AWS_PROFILE is not set, the default profile is used.

Here is what the function would look like;

![Without function](/Img8/H.png)

-z flag is ued to test if the value if the string variable (AWS_PROFILE) has zero length, whether empty or null.

The overall shell script should then look like this with all the defined fuctions been called.

![Without function](/Img8/I.png)




