
AWS Identity and Access Management (IAM) is a fundamental service that controls who can access your AWS resources and what they can do with them. Its primary purpose is to provide a granular security framework for your AWS environment.

## The Role and Purpose of IAM

IAM works on the principle of least privilege, ensuring that users, applications, or services are granted only the permissions necessary to perform their specific tasks and nothing more.  It is the control tower for managing identities and permissions in AWS.

### Key components of IAM include:

Users: Represents individuals or applications that interact with AWS. Each user can have their own credentials. 

##### Example

You'd create an IAM User for each employee in your company, such as a developer, an administrator, or a data analyst. This gives each person a unique identity to log in with and an audit trail to track their actions.

Groups: A collection of IAM users. Permissions can be assigned to a group, and all users in that group inherit those permissions. This simplifies management, as you don't need to assign permissions to each user individually.

##### Example

Instead of granting the "Administrator" policy to every new system administrator you hire, you can create a group called Admins. You attach the AdministratorAccess policy to this group once. Then, every time a new sysadmin joins the team, you just add their IAM User to the Admins group, and they automatically get the required permissions. Similarly, you could create a Developers group with policies that allow them to use services like EC2, and a Read-Only group for users who only need to view resources.

Roles: A set of permissions that can be assumed by a trusted entity, such as an AWS service (e.g., an EC2 instance) or an external user. Roles are essential for delegating access to services securely, without having to share long-term credentials.

Policies: The documents that define permissions. They are written in JSON and specify what actions are allowed or denied on which resources. Policies are attached to users, groups, or roles.

## Contribution to Security and Efficient Management
IAM significantly enhances security and management in several ways:

Strong Access Control: IAM prevents unauthorized access to sensitive data and resources. By defining explicit permissions, you can ensure that only authorized entities can perform actions like launching instances, accessing databases, or viewing logs.

Auditability: IAM integrates with AWS CloudTrail, allowing you to log all actions taken by IAM users and roles. This provides a detailed audit trail for security analysis and compliance.

Scalability: IAM makes it easy to manage access for a large number of users and services. Instead of manually configuring each user, you can use groups and roles to scale permissions management.

Delegated Access: With IAM Roles, you can securely grant temporary access to AWS services or other accounts without sharing access keys. For example, an EC2 instance can assume a role to access an S3 bucket, which is far more secure than embedding credentials in the application.

In essence, IAM is the cornerstone of a secure and well-managed AWS account. It provides the necessary tools to implement a robust security posture and maintain control over your cloud environment.



## Steps invoolved in creatinga custom IAM policy for a specific role within an organization. 

Log into AWS as a root user (Tenant owner) and navigate to IAM dashboard.
Under Access management, select policies.

![](/Img10/A.png)

On selecting policies, click create policy and specify permissions.
Here, permissions for an EC2 user is selected. This policy is meant for Developers only as they would need access to ec2 server instances to deploy thier codes on the remote servers hosted on AWS. 

![](/Img10/b.png)

![](/Img10/c.png)

![](/Img10/d.png)

For Review, A policy name is set and its description is given. 
Policy for Developers.

![](/Img10/e.png)

Successful Creation. As seen in the image below a customer managed custom IAM policy is created.

![](/Img10/f.png)

The same steps explained above is then also used to create another policy for the Data Analyst team. 

![](/Img10/g.png)


## Creating User Groups

Navigate to IAM dashboard. Under Access management, select User group.
Specify your group name and then select the prefered already created policy to link with the group. 

![](/Img10/h.png)

Here, we will be selecting DevPol, which is the policy created for the developers.

![](/Img10/i.png)

The same process is also follwed to create another group for the Analyst Team.

![](/Img10/j.png)



## Creating Users

To create new users, navigate back to the IAM dashboard under Access Management select Users.

Provide the name of the user. Ensure that the user can access AWS Management Console, if not selected, the user wont be able to login from the web browser.

Click "I want to create an IAM User"
Then provide a password for the user, the user can then change this upon first time signin. 

![](/Img10/k.png)

Retrieve the autogenerated Password. 

![](/Img10/m.png)


Select permission option and assign the user to a specified group.
Then Click Create.

![](/Img10/add.png)

The same process is repeated for Mary, a data analyst user given permission to only S3 services.

![](/Img10/adddd.png)

![](/Img10/addd.png)


## Testing and Validation

### Testing John's access. 

Login into AWS console with aacount ID (linked wih the root user), name and the password generated when creating the user John. 

![](/Img10/n.png)

Upon sign in attempt, User John was propted to change the password. 

![](/Img10/o.png)

Success. 

![](/Img10/p.png)

As seen in the top right side of the screen, John is logged in into the console as a user under the main account ID

![](/Img10/q.png)

To validate the policy, John proceeds to create an ec2 instance which is the permission granted during user account creation. The EC2 instance was successfully created and initiated. 

![](/Img10/r.png)

To ensure that both users accces is strictky confined to their role specific resources (EC2 for John and S3 for Mary) and they cannot access other AWS services betond the premise of what the group policy permits. To validates this, John tries to create a S3 bucket; unable to proceed. 

![](/Img10/s.png)

This validation ensures adherence to the principle of least privileges, enhancing security by limiting access to only what is neccessary for each user's role. 

The server instance is deleted by John to avoid uneccessary charges. Also shows John has the permission to also delete these resources. 

![](/Img10/t.png)



### Testing Mary's access

Following the steps we took for user john to gain access.

Logs into the console

![](/Img10/u.png)

Creates an S3 bucket

![](/Img10/v.png)

![](/Img10/w.png)


Attempts to create an EC2 instance, fails due to permission. 

![](/Img10/x.png)

In the context of AWS, the principle of least privilege is the foundation for creating secure and resilient cloud environments. It's an essential best practice for defining IAM policies. Instead of granting broad permissions, you create very specific policies that only allow the actions needed for a particular job function. For example, a user who only needs to read data from an S3 bucket shouldn't be given permissions to delete objects or modify bucket configurations.

Why It's Important
Applying this principle is crucial for several reasons:

Minimizing the Attack Surface: By restricting permissions, you reduce the potential for a breach. If an attacker compromises a user account, the damage they can cause is limited to that user's specific permissions.

Preventing Accidental Errors: A user with too many permissions can inadvertently delete or modify critical resources, leading to service outages or data loss. Least privilege acts as a safeguard against human error.

Improving Auditability and Compliance: It's easier to track and audit actions when permissions are tightly controlled. This helps organizations meet regulatory compliance requirements and provides a clear trail of who did what, when, and where.


## Implementing Multi Factor Authentication

Multi-Factor Authentication (MFA) is a security feature that adds an extra layer of protection to your AWS account and resources. With MFA enabled, users are required to provide two or more forms of authentication before they can access AWS resources.

John, the backend developer, logs into the AWS Management Console to access EC2 instances for deploying and testing his code. However, to further secure his access, Zappy e-Bank requires John to use MFA in addition to his regular username and password.

When John attempts to log in, after providing his username and password, AWS prompts him to enter a one-time code generated by an MFA device.

To enable MFA for user John, click John under users and select "Enable MFA" 

![](/Img10/y.png)

Provide a MFA device name and also select a preferred device type from the options. In this case, Authentication app was leveraged. 

![](/Img10/z.png)

To complete the process, follow the on-screen instruction. 

![](/Img10/zz.png)

Upon completion. 

![](/Img10/AA.png). 



The above steps is also taken to enable MFA for user Mary. 
