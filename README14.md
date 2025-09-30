<<<<<<< HEAD
## SECURITY GROUPS AND NETWORK ACCESS CONTROL LIST (NACL)

### What is Security Group

A security group acts as a virtual firewall for a cloud resource, such as a virtual machine (VM). It controls inbound (in-coming) and outbound (out-going) network traffic by applying a set of rules. Think of it as a bouncer at a club, deciding who gets to come in and what they are allowed to do.

Key Characteristics
Rule-Based: A security group's core function is its set of rules. These rules specify what traffic is allowed or denied based on criteria like source/destination IP addresses, port numbers, and protocols (e.g., TCP, UDP, HTTP).

Stateful: This is a crucial feature. If you create an inbound rule that allows traffic in, the security group automatically permits the corresponding outbound return traffic, without needing a separate rule for it. For example, if you allow a web request to come in on port 80, the security group automatically allows the web server's response to go back out to the user.

Default Behavior: By default, security groups are designed for security. They typically deny all inbound traffic and allow all outbound traffic. You must explicitly create rules to permit any incoming traffic.

Instance-Level: In cloud environments like AWS and Azure, security groups are often associated with a specific resource, like a VM. This provides a layer of security at the individual resource level, allowing for fine-grained control. In contrast, other network security tools might apply rules at a broader network level, such as an entire subnet.

Understanding these key concepts is really important as we delve into the topic.

Inbound Rules: Rules that control the incoming traffic to an AWS resource, such as an EC2 instance or an RDS database.

Outbound Rules: Rules that control the outgoing traffic from an AWS resource.

Stateful: Security groups automatically allow return traffic initiated by the instances to which they are attached.

Port: A communication endpoint that processes incoming and outgoing network traffic. Security groups use ports to specify the types of traffic allowed.

Protocol: The set of rules that governs the communication between different endpoints in a network. Common protocols include TCP, UDP, and ICMP


### What is NACL

NACL stands for Network Access Control List. Think of it like a security checkpoint for your entire neighborhood in the AWS cloud. Imagine your AWS resources are houses in a neighborhood, and you want to control who can come in and out. That’s where NACLs come in handy.

NACLs are like neighborhood security guards. They sit at the entrance and check every person (or packet of data) that wants to enter or leave the neighborhood.

But here’s the thing: NACLs work at the subnet level, not the individual resource level like security groups. So instead of controlling access for each house (or AWS resource), they control access for the entire neighborhood (or subnet).

You can set rules in your NACL to allow or deny traffic based on things like IP addresses, protocols, and ports. For example, you can allow web traffic (HTTP) but block traffic on other ports like FTP or SSH.

Unlike security groups, which are stateful (meaning they remember previous interactions), NACLs are stateless. This means you have to explicitly allow inbound and outbound traffic separately, unlike security groups where allowing inbound traffic automatically allows outbound traffic related to that session.

In simple terms, NACLs act as gatekeepers for your AWS subnets, controlling who can come in and out based on a set of rules you define. They’re like the security guards that keep your neighborhood (or your AWS network) safe and secure.

Subnet-level Firewall: NACLs function as a firewall for an entire subnet, managing both inbound and outbound traffic. This means they control all traffic entering and exiting the subnet.

Stateless: NACLs are stateless, meaning they don't automatically allow return traffic. You must explicitly configure separate rules for both incoming (ingress) and outgoing (egress) traffic. This is a key difference from stateful firewalls like security groups.

Allow/Deny: NACL rules can be configured to either allow or deny traffic based on specific criteria, such as IP addresses or port numbers. This provides granular control over network traffic.

Ingress: This term refers to inbound traffic, which is any traffic entering the subnet.

Egress: This term refers to outbound traffic, which is any traffic exiting the subnet.

CIDR Block: This stands for Classless Inter-Domain Routing. A CIDR block is a way to specify a range of IP addresses (e.g., 10.0.0.0/24) that an NACL rule applies to.

We will be considering these concepts in Part 1 and Part 2 respectively.

## Part 1

First and foremost, well need to configure an EC2 instance, install apache to host the website on the instance and lastly, clone the a repository containing the web app files.

This installs the apache (httpd) on the instance. 

![](/Img14/1.png)

![](/Img14/2.png)

We then move on to install git package and clone our repository. 

![](/Img14/3.png)

![](/Img14/4.png)


Now that we are done with creating the underlying resources and installing the neccessary packages, we will navigate to the server instance on AWS.

![](/Img14/5.png)

From the image below, notice that there is a default securit group attcahed to the instance.

![](/Img14/6.png)

Navigate into the security group, under the inbound rules we would notice that it is of type SSH on port 22. What this means is the only SSH traffic on port 22 can gain access to this instance. No other type of traffic can gain access to the resource

![](/Img14/7.png)

Lets verify this, we will copy the public IPV4 address onto the web browser and we should be seeeing the content of our webpage. 

![](/Img14/7a.png)

Unfortunately, we can't reach the contents of our webpage over the internet (http traffic). This is becasue only SSH traffic can reach the instance. 

This is precisely where the concept of Security Group comes into play.  

The next step is to create a new security group that will allow us to gain access to this resource. 

![](/Img14/8.png)

A new security Group named publicaccess_SG that allows HHTP traffic from anywhere (0.0.0.0/0) can reach the ec2 instance. (For demo purposes as this is not a safe way as it does not follow the right security compliance)

![](/Img14/9.png)

The arrow points to type of traffic allowed to access the instance, HTTP traffic.

We then navigate back to the EC2 instance page to consume publicaccess_SG.
This is typically done by changing the associated Security Group to the newly created group.

![](/Img14/10.png)

select the newly created security group.

![](/Img14/11.png)

We have successfully attributed publicaccess_SG to the instance. 

![](/Img14/12.png)

We then refresh the webapge. The contents of the webpage should be displayed.

![](/Img14/13.png)

Lets see the effect of this from the perspective of the outbound rules. 
We will see how removing the outbound rule affects the instance's connectivity. Meaning no one can go outside of this instance.

On the Outbound rule section of publicaccess_SG, Click edit outbound rules.

![](/Img14/14.png)

Then delete.

![](/Img14/15.png)

Refresh the webpage. 

![](/Img14/16.png)

The content of the webpage is still very much available.

So, even though we’ve removed the outbound rule that allows all traffic from the instance to the outside world, we can still access the website. According to the logic we discussed, when a user accesses the instance, the inbound rule permits HTTP protocol traffic to enter. However, when the instance sends data to the user’s browser to display the website, the outbound rule should prevent it. Yet, we’re still able to view the website. Why might that be?

Security groups are stateful, which means they automatically allow return traffic initiated by the instances to which they are attached. So, even though we removed the outbound rule, the security group allows the return traffic necessary for displaying the website, hence we can still access it.

let’s explore the scenario,

If we delete both the inbound and outbound rules, essentially, we’re closing all access to and from the instance. This means no traffic can come into the instance, and the instance cannot send any traffic out. So, if we attempt to access the website from a browser or any other client, it will fail because there are no rules permitting traffic to reach the instance. Similarly, the instance won’t be able to communicate with any external services or websites because all outbound traffic is also blocked.

We wiil then go on to delete inbound rules for this instance, same way we previously deleted the outbound rules.

![](/Img14/17.png)

The inbound rules have now been deleted. 
Which means the instance is unreachable regardless of the type of traffic that attepmts to come in.

![](/Img14/7a.png)

![](/Img14/18.png)

We then navigate to the outbound rules to edit outbound rules. 
This rule will enable traffic out of the instance. 

![](/Img14/19.png)

We set type, CIDR and destination.

The outbound rules have been set to type HTTP, meaning HTTP traffic is allowed to leave the instance.

![](/Img14/19a.png)

Now observe that we are able to go to the outside world from the instance

![](/Img14/20.png)

As a result, the instance will be able to fetch data from external sources or communicate with other HTTP-based services on the internet. This adjustment ensures that while incoming connections to the instance may still be restricted, the instance itself can actively communicate over HTTP to external services.

### Part 2

Lets come to NACL. Navigate to the search bar and locate VPC. 
Under the VPC section, go to the Security section.
Locate NACL.

Click and Create. 

![](/Img14/21.png)

Provide a prefered NACL name and select a VPC (not default), then click create.

By default, you will notice it is denying all traffic from all ports. 

![](/Img14/22a.png)


![](/Img14/22b.png)

To make the required changes, select the NACL, under the inbound rules click edit inbound rule.
Then click Add rule.

Now, choose the rule number.
 Specify the type.
 Select the source.
 And determine whether to allow or deny the traffic.
 Then click on “Save changes.”

![](/Img14/24.png)

Currently, this NACL is not associated with any subnet within the VPC. 
Let’s associate it.
Selecting the NACL.
Click on “Actions” and choose “Edit subnet association.”

![](/Img14/25.png)

We have successfully attached the public subnet with the NACL.

![](/Img14/26.png)


After attaching the NACL to the public subnet and attempting to access the instance using the SSH, the instance becomes inaccessible. This is the expected behavior.

Even if we had access to the instance prior to thes changes, we would be unable to access our webpage.

![](/Img14/27.png)

Although we’ve permitted all traffic in the inbound rule of our NACL, we’re still unable to access the website. This raises the question: why isn’t the website visible despite these permissions?

The reason why we’re unable to access the website despite permitting inbound traffic in the NACL is because NACLs are stateless. They don’t automatically allow return traffic. As a result, we must explicitly configure rules for both inbound and outbound traffic.

Even though the inbound rule allows all traffic into the subnet, the outbound rules are still denying all traffic.

We can fix this by simply allowing outbound traffic. 
Same way we allows inbound traffic, we will replicate. Only this time, it would be for the outbound traffic.

![](/Img14/28.png)

Now, outbound traffic out of the subnet (public) is allowed.

![](/Img14/29.png)

We now have access to the instance using ssh traffic. 


In this scenario:

Security Group: Allows inbound traffic for HTTP and SSH protocols and permits all outbound traffic.

Network ACL: Denies all inbound traffic. Let’s observe the outcome of this configuration.

But since we already have a security group that allows all inbound traffic. 
We wiil denny all inbound traffic for the NACL.


![](/Img14/30.png)

Lets try to access the webpage.

![](/Img14/7a.png)


So we are unable to access the website. Why? Even if we have allowed inbound traffic for HTTP in security group.

Imagine you're at the entrance of a building, and there's a security guard checking everyone who wants to come in. That security guard is like the NACL. They have a list of rules (like "no backpacks allowed" or "no food or drinks inside"), and they check each person against these rules as they enter.

Once you're inside the building, there's another layer of security at each room's door. These are like the Security Groups. Each room has its own rules, like "only employees allowed" or "no pets." These rules are specific to each room, just like Security Groups are specific to each EC2 instance.

So, the traffic first goes through the NACL (the security guard at the entrance), and if it passes those rules, it then goes through the Security Group (the security check at each room's door). If it doesn't meet any of the rules along the way, it's denied entry.

The reason we can't see the website is because the NACL has denied inbound traffic. This prevents traffic from reaching the security group, much like a security guard not allowing entry to another room if access to the building is denied. Similarly, if someone can't enter a building, they can't access any rooms inside without first gaining entry to the building.

## Difference between Security Groups and NACL

Security Groups in AWS act like virtual firewalls that control traffic at the instance level. They define rules for inbound and outbound traffic based on protocols, ports, and IP addresses. Essentially, they protect individual instances by filtering traffic, allowing only authorized communication.

On the other hand, Network Access Control Lists (NACLs) function at the subnet level, overseeing traffic entering and leaving subnets. They operate as a barrier for entire subnets, filtering traffic based on IP addresses and protocol numbers. Unlike security groups, NACLs are stateless, meaning they don’t remember the state of the connection, and each rule applies to both inbound and outbound traffic independently.

Note- In security groups, there's no explicit “deny” option as seen in NACLs; any rule configured within a security group implies permission, meaning that if a rule is established, it’s automatically allowed.


=======
## SECURITY GROUPS AND NETWORK ACCESS CONTROL LIST (NACL)

### What is Security Group

A security group acts as a virtual firewall for a cloud resource, such as a virtual machine (VM). It controls inbound (in-coming) and outbound (out-going) network traffic by applying a set of rules. Think of it as a bouncer at a club, deciding who gets to come in and what they are allowed to do.

Key Characteristics
Rule-Based: A security group's core function is its set of rules. These rules specify what traffic is allowed or denied based on criteria like source/destination IP addresses, port numbers, and protocols (e.g., TCP, UDP, HTTP).

Stateful: This is a crucial feature. If you create an inbound rule that allows traffic in, the security group automatically permits the corresponding outbound return traffic, without needing a separate rule for it. For example, if you allow a web request to come in on port 80, the security group automatically allows the web server's response to go back out to the user.

Default Behavior: By default, security groups are designed for security. They typically deny all inbound traffic and allow all outbound traffic. You must explicitly create rules to permit any incoming traffic.

Instance-Level: In cloud environments like AWS and Azure, security groups are often associated with a specific resource, like a VM. This provides a layer of security at the individual resource level, allowing for fine-grained control. In contrast, other network security tools might apply rules at a broader network level, such as an entire subnet.

Understanding these key concepts is really important as we delve into the topic.

Inbound Rules: Rules that control the incoming traffic to an AWS resource, such as an EC2 instance or an RDS database.

Outbound Rules: Rules that control the outgoing traffic from an AWS resource.

Stateful: Security groups automatically allow return traffic initiated by the instances to which they are attached.

Port: A communication endpoint that processes incoming and outgoing network traffic. Security groups use ports to specify the types of traffic allowed.

Protocol: The set of rules that governs the communication between different endpoints in a network. Common protocols include TCP, UDP, and ICMP


### What is NACL

NACL stands for Network Access Control List. Think of it like a security checkpoint for your entire neighborhood in the AWS cloud. Imagine your AWS resources are houses in a neighborhood, and you want to control who can come in and out. That’s where NACLs come in handy.

NACLs are like neighborhood security guards. They sit at the entrance and check every person (or packet of data) that wants to enter or leave the neighborhood.

But here’s the thing: NACLs work at the subnet level, not the individual resource level like security groups. So instead of controlling access for each house (or AWS resource), they control access for the entire neighborhood (or subnet).

You can set rules in your NACL to allow or deny traffic based on things like IP addresses, protocols, and ports. For example, you can allow web traffic (HTTP) but block traffic on other ports like FTP or SSH.

Unlike security groups, which are stateful (meaning they remember previous interactions), NACLs are stateless. This means you have to explicitly allow inbound and outbound traffic separately, unlike security groups where allowing inbound traffic automatically allows outbound traffic related to that session.

In simple terms, NACLs act as gatekeepers for your AWS subnets, controlling who can come in and out based on a set of rules you define. They’re like the security guards that keep your neighborhood (or your AWS network) safe and secure.

Subnet-level Firewall: NACLs function as a firewall for an entire subnet, managing both inbound and outbound traffic. This means they control all traffic entering and exiting the subnet.

Stateless: NACLs are stateless, meaning they don't automatically allow return traffic. You must explicitly configure separate rules for both incoming (ingress) and outgoing (egress) traffic. This is a key difference from stateful firewalls like security groups.

Allow/Deny: NACL rules can be configured to either allow or deny traffic based on specific criteria, such as IP addresses or port numbers. This provides granular control over network traffic.

Ingress: This term refers to inbound traffic, which is any traffic entering the subnet.

Egress: This term refers to outbound traffic, which is any traffic exiting the subnet.

CIDR Block: This stands for Classless Inter-Domain Routing. A CIDR block is a way to specify a range of IP addresses (e.g., 10.0.0.0/24) that an NACL rule applies to.

We will be considering these concepts in Part 1 and Part 2, respectively.

## Part 1

First and foremost, well need to configure an EC2 instance, install apache to host the website on the instance and lastly, clone the a repository containing the web app files.

This installs Apache (httpd) on the instance. 

![](/Img14/1.png)

![](/Img14/2.png)

We then move on to install git package and clone our repository. 

![](/Img14/3.png)

![](/Img14/4.png)


Now that we are done with creating the underlying resources and installing the neccessary packages, we will navigate to the server instance on AWS.

![](/Img14/5.png)

From the image below, notice that there is a default security group attached to the instance.

![](/Img14/6.png)

Navigate into the security group, under the inbound rules, we would notice that it is of type SSH on port 22. What this means is that only SSH traffic on port 22 can gain access to this instance. No other type of traffic can gain access to the resource

![](/Img14/7.png)

Lets verify this, we will copy the public IPV4 address onto the web browser and we should be seeeing the content of our webpage. 

![](/Img14/7a.png)

Unfortunately, we can't reach the contents of our webpage over the internet (http traffic). This is because only SSH traffic can reach the instance. 

This is precisely where the concept of Security Group comes into play.  

The next step is to create a new security group that will allow us to gain access to this resource. 

![](/Img14/8.png)

A new security Group named publicaccess_SG that allows HHTP traffic from anywhere (0.0.0.0/0) can reach the ec2 instance. (For demo purposes as this is not a safe way as it does not follow the right security compliance)

![](/Img14/9.png)

The arrow points to type of traffic allowed to access the instance, HTTP traffic.

We then navigate back to the EC2 instance page to consume publicaccess_SG.
This is typically done by changing the associated Security Group to the newly created group.

![](/Img14/10.png)

Select the newly created security group.

![](/Img14/11.png)

We have successfully attributed publicaccess_SG to the instance. 

![](/Img14/12.png)

We then refresh the webpage. The contents of the webpage should be displayed.

![](/Img14/13.png)

Let's see the effect of this from the perspective of the outbound rules. 
We will see how removing the outbound rule affects the instance's connectivity. Meaning no one can go outside of this instance.

On the Outbound rule section of publicaccess_SG, click edit outbound rules.

![](/Img14/14.png)

Then delete.

![](/Img14/15.png)

Refresh the webpage. 

![](/Img14/16.png)

The content of the webpage is still very much available.

So, even though we’ve removed the outbound rule that allows all traffic from the instance to the outside world, we can still access the website. According to the logic we discussed, when a user accesses the instance, the inbound rule permits HTTP protocol traffic to enter. However, when the instance sends data to the user’s browser to display the website, the outbound rule should prevent it. Yet, we’re still able to view the website. Why might that be?

Security groups are stateful, which means they automatically allow return traffic initiated by the instances to which they are attached. So, even though we removed the outbound rule, the security group allows the return traffic necessary for displaying the website, hence we can still access it.

let’s explore the scenario,

If we delete both the inbound and outbound rules, essentially, we’re closing all access to and from the instance. This means no traffic can come into the instance, and the instance cannot send any traffic out. So, if we attempt to access the website from a browser or any other client, it will fail because there are no rules permitting traffic to reach the instance. Similarly, the instance won’t be able to communicate with any external services or websites because all outbound traffic is also blocked.

We will then go on to delete inbound rules for this instance, same way we previously deleted the outbound rules.

![](/Img14/17.png)

The inbound rules have now been deleted. 
Which means the instance is unreachable regardless of the type of traffic that attempts to come in.

![](/Img14/7a.png)

![](/Img14/18.png)

We then navigate to the outbound rules to edit them. 
This rule will enable traffic out of the instance. 

![](/Img14/19.png)

We set type, CIDR, and destination.

The outbound rules have been set to type HTTP, meaning HTTP traffic is allowed to leave the instance.

![](/Img14/19a.png)

Now observe that we are able to go to the outside world from the instance

![](/Img14/20.png)

As a result, the instance will be able to fetch data from external sources or communicate with other HTTP-based services on the internet. This adjustment ensures that while incoming connections to the instance may still be restricted, the instance itself can actively communicate over HTTP to external services.

### Part 2

Let's come to NACL. Navigate to the search bar and locate VPC. 
Under the VPC section, go to the Security section.
Locate NACL.

Click and Create. 

![](/Img14/21.png)

Provide a prefered NACL name and select a VPC (not default), then click create.

By default, you will notice it is denying all traffic from all ports. 

![](/Img14/22a.png)


![](/Img14/22b.png)

To make the required changes, select the NACL, under the inbound rules, click edit inbound rule.
Then click Add rule.

Now, choose the rule number.
 Specify the type.
 Select the source.
 And determine whether to allow or deny the traffic.
 Then click on “Save changes.”

![](/Img14/24.png)

Currently, this NACL is not associated with any subnet within the VPC. 
Let’s associate it.
Selecting the NACL.
Click on “Actions” and choose “Edit subnet association.”

![](/Img14/25.png)

We have successfully attached the public subnet to the NACL.

![](/Img14/26.png)


After attaching the NACL to the public subnet and attempting to access the instance using SSH, the instance becomes inaccessible. This is the expected behavior.

Even if we had access to the instance prior to these changes, we would be unable to access our webpage.

![](/Img14/27.png)

Although we’ve permitted all traffic in the inbound rule of our NACL, we’re still unable to access the website. This raises the question: why isn’t the website visible despite these permissions?

The reason why we’re unable to access the website despite permitting inbound traffic in the NACL is that NACLs are stateless. They don’t automatically allow return traffic. As a result, we must explicitly configure rules for both inbound and outbound traffic.

Even though the inbound rule allows all traffic into the subnet, the outbound rules are still denying all traffic.

We can fix this by simply allowing outbound traffic. 
Same way we allows inbound traffic, we will replicate. Only this time, it would be for the outbound traffic.

![](/Img14/28.png)

Now, outbound traffic out of the subnet (public) is allowed.

![](/Img14/29.png)

We now have access to the instance using SSH traffic. 


In this scenario:

Security Group: Allows inbound traffic for HTTP and SSH protocols and permits all outbound traffic.

Network ACL: Denies all inbound traffic. Let’s observe the outcome of this configuration.

But since we already have a security group that allows all inbound traffic. 
We will deny all inbound traffic for the NACL.


![](/Img14/30.png)

Lets try to access the webpage.

![](/Img14/7a.png)


So we are unable to access the website. Why? Even if we have allowed inbound traffic for HTTP in security group.

Imagine you're at the entrance of a building, and there's a security guard checking everyone who wants to come in. That security guard is like the NACL. They have a list of rules (like "no backpacks allowed" or "no food or drinks inside"), and they check each person against these rules as they enter.

Once you're inside the building, there's another layer of security at each room's door. These are like the Security Groups. Each room has its own rules, like "only employees allowed" or "no pets." These rules are specific to each room, just like Security Groups are specific to each EC2 instance.

So, the traffic first goes through the NACL (the security guard at the entrance), and if it passes those rules, it then goes through the Security Group (the security check at each room's door). If it doesn't meet any of the rules along the way, it's denied entry.

The reason we can't see the website is that the NACL has denied inbound traffic. This prevents traffic from reaching the security group, much like a security guard not allowing entry to another room if access to the building is denied. Similarly, if someone can't enter a building, they can't access any rooms inside without first gaining entry to the building.

## Difference between Security Groups and NACL

Security Groups in AWS act like virtual firewalls that control traffic at the instance level. They define rules for inbound and outbound traffic based on protocols, ports, and IP addresses. Essentially, they protect individual instances by filtering traffic, allowing only authorized communication.

On the other hand, Network Access Control Lists (NACLs) function at the subnet level, overseeing traffic entering and leaving subnets. They operate as a barrier for entire subnets, filtering traffic based on IP addresses and protocol numbers. Unlike security groups, NACLs are stateless, meaning they don’t remember the state of the connection, and each rule applies to both inbound and outbound traffic independently.

Note- In security groups, there's no explicit “deny” option as seen in NACLs; any rule configured within a security group implies permission, meaning that if a rule is established, it’s automatically allowed.



>>>>>>> a90996b03a7e969c4559c3110485420de20a2c9d
