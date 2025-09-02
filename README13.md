## NETWORKING WITH AWS VPC

Before we delve into the practical aspect of this topic, we need to understand some key terms. 

What is a Virtual Private Cloud (VPC)?
A Virtual Private Cloud (VPC) is a logically isolated virtual network within a public cloud. It provides a secure, private, and customizable environment for you to launch and run your cloud resources. Think of it as your own private data center, but within a public cloud provider's infrastructure. It allows you to have complete control over your network environment, including IP address ranges, subnets, route tables, and network gateways.

On AWS, Amazon VPC is the foundational networking service. It is the core building block for all your cloud infrastructure on AWS. When you launch any AWS resource, such as an EC2 instance, it must be placed within a VPC. Every AWS account is provisioned with a default VPC in each region, but you can create and configure your own custom VPCs to better suit your needs.


Key components of an AWS VPC are Subnets, Route Table, Internet Gateway, NAT Gateway (Network Address Translator), IP address, CIDR etc..

What is Gateway 
A gateway is a network device or software that acts as a bridge between two different networks. It's essentially an entry and exit point for data, managing the flow of traffic and translating protocols to allow communication between disparate systems. For example, imagine you live in a city with different neighborhoods, each with its own set of houses. You're in one neighborhood, let's call it Neighborhood A, and you want to visit a friend who lives in a different neighborhood, Neighborhood B. To get from your neighborhood to your friend's neighborhood, you need to go through a gateway—a special gate that connects the two neighborhoods. This gateway acts as a bridge between the two areas, allowing people and things to pass back and forth.

So, when you leave your house in Neighborhood A, you walk to the gateway, pass through it, and then find your friend's house in Neighborhood B. The gateway helps you navigate from one neighborhood to another, just like how a network gateway helps data travel between different networks

What is a Subnet

A subnet (short for subnetwork) is a logical subdivision of a larger network. The practice of dividing a network is called subnetting. It's a fundamental concept in networking that helps to organize and manage large networks more efficiently.

How Subnets Work
A subnet is created by dividing a large IP address range into smaller, more manageable blocks. This is done by using a subnet mask, which essentially tells a network router which portion of an IP address identifies the network and which part identifies the host (or device) on that network.

Think of it like a city with different neighborhoods. The city is the main network, and the neighborhoods are the subnets. All addresses within a neighborhood share a common prefix, just as all devices in a subnet share the same network portion of their IP address. When mail is sent, the postal service only needs to get the letter to the correct neighborhood, and then the local mail carrier handles delivery to the specific house. Similarly, a router directs traffic to the correct subnet, and a local switch or router within that subnet handles delivery to the specific device.

What is a Route table?

A route table is like a map that helps data find its way around a network. Just like a map shows you the best routes to get from one place to another, a route table tells devices on a network how to send data packets to their destinations.

In simpler terms, a route table lists different destinations and the paths (or 'routes') to reach them. When a device receives data that it needs to send somewhere, it consults the route table to figure out where to send it.

For example, if your computer wants to send data to a website, it looks at its route table to find out which gateway to use to reach the internet. The route table might say, 'To reach the internet, send data to the router.' Then, the router knows how to forward the data to the next stop on its journey, eventually reaching its destination.

Think of a route table as the navigation system for data on a network, helping it find the fastest and most efficient paths to where it needs to go.



### Connection between Gateway and Route table

Gateways:

Gateways are devices (like routers or firewalls) that serve as entry and exit points between different networks.

They connect networks with different IP address ranges, such as your local network and the internet.

Gateways receive incoming data packets and determine where to send them next based on routing information.

Route Tables:

Route tables are tables maintained by networking devices (like routers or switches) that contain information about how to route data packets to their destinations.

Each entry in a route table specifies a destination network and the next hop (gateway) to reach that network.

Devices consult the route table to determine the best path for forwarding data packets based on their destination IP addresses.

Connection:

When a device (like a computer or server) wants to send data to a destination outside of its local network, it checks its route table.

The route table provides the information needed to determine the next hop (gateway) for reaching the destination network.

The device then forwards the data packet to the specified gateway, which continues the process until the packet reaches its final destination.

In summary, gateways and route tables work together to facilitate the routing of network traffic between different networks. Gateways serve as the entry and exit points between networks, while route tables provide the necessary routing information to determine how data packets should be forwarded to their destinations.


Now, let's come to the practical part

### Step 1
Setting up a Virtual Private Cloud

Navigate to the search bar and search VPC. Select VPC.
Click "Create VPC"

![](/Img13/A.png)

Select VPC only, choose our preferred IPV4 CIDR.
Select the configuration based on preference. 

![](/Img13/B.png)

Then click create.

![](/Img13/c.png)


### Step 2
Configuring Subnets within the VPC

Navigate to the Subnet option on the left pane of the VPC dashboard and Click.

![](/Img13/d.png)

We will be creating two subnets, a public and a private subnet.
The public will be configured to receive and send traffic to the internet (Public network) while the Private subnet does not.

This is for the private subnet setup with its IPV4 subnet CIDR block /24

![](/Img13/e1.png)

The next is for the Public subnet.

![](/Img13/e2.png)

Here is what the architecture would look like, diagrammatically.

![](/Img13/snn.png)

Successfully created. 

![](/Img13/f.png)

### Step 3

Configuring an Internet Gateway.

Navigate to the "Internet Gateway" option on the left sidebar.
Upon clicking, you will be directed to the internet gateway page, from there proceed to click on the "Create Internet Gateway" button

![](/Img13/g.png)

![](/Img13/h.png)

Now, you will notice that it is currently detached, indicating that it is not associated with any VPC. To enable internet conectivity you must attach the gateway to the VPC previously created. 

![](/Img13/i.png)

After the VPC has been attached successfully.

![](/Img13/j.png)

Here is the updated architecture. 

![](/Img13/sn.png)


### Step 4

Setting up the routing table.

Proceed to the "Route Tables" option on the left pane. Once there, click on the "Create route table" button. Choose route table name and select VPC to use for this route table. Click Create route table. 

![](/Img13/k.png)

Next, click on "Subnet associations", followed by "Edit Subnet associations" to associate the subnet wit this route table. we will then associate the public subnet to this route table. This is the route table the public subnet will make use of when attempting to communicate to the outside world from within the VPC.
Choose the public subnet and click on save association. Go to the Route section and click edit routes. Select Destination as "0/0/0/0.0" indicating that every IPV4 address can access this subnet. In the target field, choose "Internet Gateway" and then select the Internet Gateway created earlier. 

![](/Img13/m.png)

Save the changes. This custom route table has now been configured to route traffic to the internet gatewa,y allowing connectivity to the internet. Since only the subnet named "my_public_subnet" is associated with this route table, only resources with this subnet can access the internet.
![](/Img13/n.png)

![](/Img13/l.png)

Here is the updated architecture.

![](/Img13/s.png)

### Step 5

Configuring NAT gateway

Navigate to the NAT Gateways section and click create.

Choose a name for the NAT gateway, select the private subnet. 
Since we have no intention to expose the private network, the subnet will be configure behind a NAT gateway as discussed earlier. 

![](/Img13/o.png)

The NAT Gateway has been successfully created. 

![](/Img13/p.png)

Select the newly created NAT GW, go to the details section and select the private subnet ID.

![](/Img13/1.png)

Under the Route Table section, click the route table ID to view more information about the route table (That routes data packets from the private network to the NAT GW) 

![](/Img13/2.png)

Under the routes, click edit routes, then click add routes. 

![](/Img13/3.png).

Select Destination as "0.0.0.0/0" 
In the target field choose NAT gateway
Then select the NATGW created earlier. Finally save the changes.

On the subnet association section, click on edit sunet association. Select the private subnet and save. 

![](/Img13/5.png)

Now the subnet has been successfully attached with the route table. 

![](/Img13/4.png).

![](/Img13/6.png).


Difference between Internet Gateway and NAT Gateway

Internet Gateway:

Think of it like a door to the internet for your subnet. When you attach an Internet Gateway to a subnet, it allows the resources in that subnet (like EC2 instances) to reach out to the internet and also allows internet traffic to reach those resources. It's like having a door both to enter and exit the subnet.

NAT Gateway:

Imagine it as a one-way street sign for your subnet's traffic. When you attach a NAT Gateway to a subnet, it lets the resources in that subnet (like EC2 instances) access the internet, but it doesn't allow incoming traffic from the internet to reach those resources. It's like the resources can go out to the internet, but the internet traffic can't directly come in


### Step 6


What is VPC Peering?
VPC peering is a way to connect two virtual private clouds (VPCs) in the cloud so they can communicate directly. It's like having two neighboring offices share files and chat directly without a middleman.

By default, EC2 instances in different VPCs cannot communicate with each other.

To enable communication between EC2 instances in different VPCs, you can set up VPC peering, VPN connections, or AWS Direct Connect.

VPC peering establishes a direct network connection between the VPCs, allowing EC2 instances in one VPC to communicate with EC2 instances in the other.

Why do we need VPC Peering?
We need VPC peering when we want different parts of our cloud network (VPCs) to work together seamlessly. For instance, if you have one VPC for your development team and another for your marketing team and you want them to share data securely, VPC peering lets these VPCs communicate directly, making things easier for everyone.

Additionally, here are some key points to be aware of:

Two VPCs cannot connect to each other by default. You need to set up VPC peering or use a VPN or Direct Connect to establish connectivity between VPCs.

Subnets within the same VPC can communicate with each other by default, as AWS sets up route tables to allow communication within the same VPC.

EC2 instances in the same subnet can communicate with each other by default, assuming they have proper security group rules allowing the desired traffic.

EC2 instances in different subnets within the same VPC can also communicate with each other by default, as long as their associated route tables are configured to allow traffic between subnets.

We start by creating another VPC, could be in the same region as the former or could be in a different region. 

![](/Img13/q.png)

Navigate to the peering connection on the left sidebar. Create a peering connection. 

![](/Img13/r.png)

Name the connection: First, provide a name for the VPC peering connection that's easy to identify.

Select the requester VPC: Choose the first VPC that will initiate the peering request.

Specify the account: Since the VPCs are within your own AWS account, choose "My account."

![](/Img13/s1.png)

Confirm the region: Ensure that the region selected is the same as the region where both VPCs were created. For example, "This Region (ap-southeast-1)."

Select the accepter VPC: Choose the second VPC that will accept the peering request.

Create the connection: Click the "Create Peering Connection" button to finalize the process.

![](/Img13/s2.png)

After creation, you will get notified about a pending acceptance request. 
Click on Action and Accept. 

![](/Img13/t.png)

![](/Img13/u.png)

Now, go back to the main route table ID of the accepter VPC.
Copy its IPV4 CIDR addresss.


Now go back to main route table of the requester VPC. Navigate to the Route table
![](/Img13/v.png)

Edit route from it route table. Using the copied CIDR address of the accepter VPC as the destination and select Peering connection as the target. Selected the peering connection created.

![](/Img13/w.png)

![](/Img13/w2.png)


Save the changes. 

![](/Img13/x.png)

Repeat this process, vice versa.

We have successfully configured the connection for both VPC to communicate through the Peering Connection.
This process establishes a connection between both VPCs by setting up configuration on both ends of the VPCs.

![](/Img13/7.png)




Important Points About VPC Peering

VPC peering allows direct communication between two VPCs using private IP addresses.

Region compatibility: VPC peering can be set up between VPCs in the same AWS region or different regions, and in the same AWS account or different accounts.

CIDR Blocks: The CIDR blocks of the VPCs involved in the peering connection should not overlap or conflict with each other. Each VPC must have a unique CIDR block.

IP Addressing: Resources in one VPC can communicate with resources in the peered VPC using their private IP addresses.

Security Groups and NACLs: Proper configuration of Security Groups and Network Access Control Lists (NACLs) is essential to allow traffic between peered VPCs.

Direct Communication: Resources in one VPC can directly communicate with resources in the peered VPC without needing internet access.

Transitive Traffic: Traffic cannot flow through a VPC peering connection to reach other VPCs that are not directly peered.

Routing: Update route tables in both VPCs to allow traffic to flow through the peering connection. Each VPC's route table must contain a route entry for the CIDR block of the peer VPC, pointing to the peering connection.

Limitations: There are limits on the number of VPC peering connections that can be established per VPC, as well as limitations on the number of route entries per route table.

## VPC Endpoints

A VPC endpoint is a network component that allows you to privately connect your Virtual Private Cloud (VPC) to supported AWS services and other VPC endpoint services without requiring an internet gateway, NAT device, VPN connection, or AWS Direct Connect connection. This keeps network traffic within the Amazon network, enhancing security and improving performance.

Imagine a company with a web application hosted on an EC2 instance inside a private subnet. This application needs to regularly read and write data to an Amazon S3 bucket.

Without a VPC endpoint, the EC2 instance in the private subnet would need a NAT Gateway to access the public S3 endpoint over the internet. This setup exposes the traffic to the public internet, even if it's encrypted, and can incur data transfer costs through the NAT Gateway.

With a VPC endpoint (specifically, a Gateway Endpoint for S3), the EC2 instance can communicate directly with the S3 service using private IP addresses. The traffic never leaves the AWS network, which provides several benefits:

Enhanced Security: The data transfer is completely private, reducing the risk of unauthorized access or data exposure.

Cost Savings: You avoid the data processing charges associated with a NAT Gateway.

Improved Performance: Communication is faster and has lower latency because it stays within Amazon's high-speed internal network.

In this scenario, the VPC endpoint acts as a secure, private tunnel that allows the application to access the necessary AWS services without ever touching the public internet.

