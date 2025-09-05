## Creating AWS Resources with Functions and Arrays

Functions: The script is divided into well-defined functions (check_aws_cli, create_s3_buckets, list_s3_buckets, delete_s3_buckets). This modular design improves readability, reusability and makes the script easier to maintain. Each function has a single, clear purpose, such as creating buckets or checking for the AWS CLI.

Arrays: The DEPARTMENTS variable is an array, which allows for a single variable to hold multiple values. This is used in the create_s3_buckets and delete_s3_buckets functions to iterate through each department and perform the necessary actions, making the code scalable and dynamic.

Variable Substitution: The script uses variable substitution (e.g., ${COMPANY_NAME}-${department}-data-bucket) to dynamically generate unique bucket names. This prevents hard-coding and makes the script flexible for different company names or departments.

Error Handling and Control Flow: The script includes basic error handling and control flow mechanisms. It checks if the AWS CLI is installed and provides user-friendly messages. It also uses conditional statements (if) to check if a bucket was successfully created or deleted, and to ensure the delete function is not run accidentally without user confirmation. Finally, the case statement provides a clean way to handle different command-line arguments.

In this project, we will be focusing on creating two AWS resources: EC2 Instance and s3 Buckets

### Provisioning an EC2 Instance

Creating instances through scripting requires the use of an EC2 AMI. What this does is mirror an already provisioned instance.  When creating an Amazon EC2 instance using a shell script, we need to specify an Amazon Machine Image (AMI). The AMI serves as a template that contains the operating system, application server, and applications required to launch your instance. It's essentially a blueprint for your virtual server.

The AWS EC2 run-instances command is the primary tool for this. You use the --image-id parameter to specify the AMI you want to use. Other essential parameters include --instance-type, which defines the hardware configuration, and --key-name, which provides the key pair for secure access. 

The image below shows the already-created AMI we will be making use of for this task.

![](/Img16/1.png)

The next step is to develop our shell script containing a function whose task is to create the instance. 

We start by declaring our global variables for the instance parameters. 

![](/Img16/2.png)

Specify the;

- Instance type
- AMI ID
- Region (to launch the instance)
- Count
- Key Pair name (We must have already created a key pair on the EC2 dashboard)
- Tags (Optional, used for easier identification)

check_prerequisite() ensures we have AWS CLI installed on the machine. If not, it prompts the user to install first before proceeding. 

![](/Img16/3.png)

In the create_ec2_instances(), the function takes in an argument. This argument (local_count) specifies the number of instances to be created. 

After succesfull creation on line 42, we declared the variable Instance_id to extract the id of the instances that have been created. 

In 45, we wrote a command to ensure the process waits until the instances are up and running. If this is not done, the script will proceed, and this will cause the process to break because the instances would still be pending state. 

Lets proceed to run the script on the terminal.

![](/Img16/4.png)

Running the script, we can see that the process failed to create.

Upon troubleshooting, I discovered that I failed to specify the argument when calling the function in the script. This argument is supposed to take the number of instances count even though we added the number while running the script on the terminal. 

We have then corrected the script.

![](/Img16/4a.png)

Let's try running the script again.

![](/Img16/5.png)

Now lets taka a look at what we have up there. An error occurred again, but this time, it says it can't find the specified AMI. Says our AMI does not exist. 
But surely it does, so upon troubleshooting, I discovered that the region we specified in the global variable is quite different from where the AMI exists. 

An AMI is a regional resource, meaning it can only be used to launch an EC2 instance within the same AWS Region where the AMI is stored.

If you need to launch an EC2 instance in a different region, you must first copy the AMI to that destination region. This process creates a new, independent AMI in the target region, which you can then use as a template to launch your instance.

So then I tried to list out the ami I have currently using the "aws ec2 describe-images" command, the result tuns up empty. 

I then added the region, it then displays the information of my existing ami. 
Upon correcting this issue, we tried to run the command again. 

And this time, an error pops up.

![](/Img16/7.png) 

No subnet found. 
From this, it is quite clear that we will need a subnet for us to provision this instance. 

![](/Img16/6.png)

We then needed to add our preferred VPC and a subnet within it. 
Lines 16 and 17 show the IDs of the VPC and its Subnet. 

Let's try running the script again. 

![](/Img16/8.png)

This time, it works!

So as not to incur uneccassary charges, we will neeed to terminate this instance.

I also developed a function that enables us to terminate this instance.

![](/Img16/9.png)

The function only deletes instances with specific tags, as described earlier. 

![](/Img16/10.png)

Filters the tags to be deleted, then proceeds to delete them.


We have been able to successfully create EC2 instances automatically with scripts.



### Provisioning an s3 Bucket

In this section, our objective is to create five distinct S3 buckets, each designated for storing data related to Marketing, Sales, HR, Operations, and Media.

To achieve this, we'll utilize a fundamental data structure in shell scripting known as an "array." This is because we need one single variable holding all the data, and then have the capability to loop through them.

Arrays in Shell Scripting

An array is a versatile data structure that allows you to store multiple values under a single variable name. Particularly in shell scripting, arrays offer an efficient means of managing collections of related data, making them invaluable for our task ahead.

![](/Img16/11.png)

Here we defined our parameters, Company_Name, Departments (Array), and Region.

Also, we wrote a function to check if AWS CLI is installed. 

![](/Img16/12.png)

This function is to create s3 buckets.
In line 38, notice the "-- create-bucket-configuration" command. Regions outside of us-east-1 require the appropriate LocationConstraint to be specified in order to create the bucket in the desired region.

Let's try to run the script. 

![](/Img16/13.png)

We have encountered an error. Its telling us our prefered bucket name has alreday being used. Bucket namespace is shared by all users of the system; essentially, no two buckets that exists on AWS can shared the same namespace. 

We will need to change our bucket names. 

![](/Img16/14.png)

Using the local variable bucket_name, we changed the name by adding random numbers to it. 
Lets try running the script again. 

![](/Img16/15.png)

Ran successfully!

The script also returned the endpoints of the buckets created. 

We will also execute a function to list all the buckets that start with Company_Name (datawise).

![](/Img16/16.png)


Output.

![](/Img16/17.png)

The script ensures the user is aware of the action that's about to be taken.
There's also a prompt for the user to respond to if he actually wants the buckets to be deleted. 

We will then go ahed to delete the s3 buckets. Before we do that, we have to delete its contents first, as buckets with contents can't be deleted unless they are empty. So what we will do is to delete them recurssively. Afterwards, the buckets can be deleted.

![](/Img16/18.png)

Finally, we will call the function to delete the bucket.

![](/Img16/19.png)

Successful deletion!















































An AMI is a regional resource, meaning it can only be used to launch an EC2 instance within the same AWS Region where the AMI is stored.

If you need to launch an EC2 instance in a different region, you must first copy the AMI to that destination region. This process creates a new, independent AMI in the target region, which you can then use as a template to launch your instance.


