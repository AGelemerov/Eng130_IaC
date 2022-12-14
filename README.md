# Infrastructure as code (IaC)
Infrastructure as code (IaC) is the process of managing and provisioning computer data centers through machine-readable definition files, rather than physical hardware configuration or interactive configuration tools.
Practicing infrastructure as code means applying the same rigor of application code development to infrastructure provisioning. All configurations should be defined in a declarative way and stored in a source control system such as AWS CodeCommit, the same as application code. Infrastructure provisioning, orchestration, and deployment should also support the use of the infrastructure as code.

![IaC-diagram](images/IaC-diagram.png)
## Configuration Management
Configuration management (CM) is a process for establishing and maintaining consistency of a product's performance, functional, and physical attributes with its requirements, design, and operational information throughout its life.

## Orchestration
Orchestration is the automated configuration, management, and coordination of computer systems, applications, and services. 

## What is Ansible
Ansible is a suite of software tools that enables infrastructure as code. It is open-source and the suite includes software provisioning, configuration management, and application deployment functionality.

Ansible is an open source, command-line IT automation software application written in Python. It can configure systems, deploy software, and orchestrate advanced workflows to support application deployment, system updates, and more.

## Blue-Green Deployment
Blue/green deployments provide releases with near zero-downtime and rollback capabilities. The fundamental idea behind blue/green deployment is to shift traffic between two identical environments that are running different versions of your application. The blue environment represents the current application version serving production traffic. In parallel, the green environment is staged running a different version of your application. After the green environment is ready and tested, production traffic is redirected from blue to green. If any problems are identified, you can roll back by reverting traffic back to the blue environment.
![blue-green](images/blue-green-deployment.png)
## Setup Ansible with Vagrant
1. SSH into Controller VM
2. Run Update and Upgrade
3. Run `sudo apt-get install software-properties-common`
4. Run `sudo apt-add-repository ppa:ansible/ansible`
5. Run `sudo apt-get update`
6. Run `sudo apt-get install ansible -y`
7. Check `sudo apt-get install tree`
8. cd into `cd /etc/ansible`
9.  Now we want to ssh into web vm from insode the controller vm
10. Enter `sudo ssh vagrant@192.168.33.10` enter then password `vagrant`
    1.  you should now be inside the web vm
11. To return back to controller enter `exit`
12. Now we want to ssh into web db from insode the controller vm
13. Enter `sudo ssh vagrant@192.168.33.11` enter then password `vagrant`
14. alter hosts file in `/etc/ansible` to have groups (labeled with [])
    1.  create a web and db group and put ips in there
    2.  you should now be able to ping machines
    3.  `sudo ansible all -m ping`


## Inventory
Ansible works against multiple managed nodes or ???hosts??? in your infrastructure at the same time, using a list or group of lists known as inventory. Once your inventory is defined, you use patterns to select the hosts or groups you want Ansible to run against.

## Ansible roles
Roles let you automatically load related vars, files, tasks, handlers, and other Ansible artifacts based on a known file structure. After you group your content in roles, you can easily reuse them and share them with other users.
### Role directory structure

```yaml
# playbooks
site.yml
webservers.yml
fooservers.yml
roles/
    common/               # this hierarchy represents a "role"
        tasks/            #
            main.yml      #  <-- tasks file can include smaller files if warranted
        handlers/         #
            main.yml      #  <-- handlers file
        templates/        #  <-- files for use with the template resource
            ntp.conf.j2   #  <------- templates end in .j2
        files/            #
            bar.txt       #  <-- files for use with the copy resource
            foo.sh        #  <-- script files for use with the script resource
        vars/             #
            main.yml      #  <-- variables associated with this role
        defaults/         #
            main.yml      #  <-- default lower priority variables for this role
        meta/             #
            main.yml      #  <-- role dependencies
        library/          # roles can also include custom modules
        module_utils/     # roles can also include custom module_utils
        lookup_plugins/   # or other types of plugins, like lookup in this case

    webtier/              # same kind of structure as "common" was above, done for the webtier role
    monitoring/           # ""
    fooapp/               # ""
```

## Adhoc commands in Ansible

- Run an update on web node from controller node
  - `sudo ansible web -a "sudo apt update -y" `
- Ping nodes
  - ` sudo ansible all -m ping`
## YAML
YAML is a human-friendly data serialization language for all programming languages.
It is used to create configuration files in many laguanges.
We use it for the creation of playbooks for the Ansible controller to interact with other virtual environments.
```yaml
    # Yaml file start ---
    ---
    # create a script to configure nginx in our web server

    # who is the host - means name of the server
    - hosts: web

    # gather data
    gather_facts: yes

    # we need admin access
    become: true

    # add the actual instructions
    tasks:
    - name: Install/configure Nginx Web server in web-VM
        apt: pkg=nginx state=present
    #can be absent as well
    # we need to ensure at the end of this script the status of nginx is running
```

## Hybrid

1. 
### Set up dependencies for controller
`sudo apt install python3`
`sudo apt install python3-pip`
`pip3 install awscli`
`pip3 install boto boto3`
`sudo apt upgrade -y`
`alias python=python3`

### Set up Ansible vault
`cd /etc/ansible`
`cd`
`/group_vars/all/pass.yaml` - mkdir is needed
when in this vi editor, enter:
`aws_access_key: my_key`
`aws_secret_key: my_key`
cd to /etc/ansible
`sudo ansible-playbook ec2.yaml --ask-pass --tags create-ec2`

## Infrastructure as Code Terraform Orchestration

### What is Terraform?
Terraform is an open-source, infrastructure as code, software tool. It allows users to define both on-premises and cloud resources in human-readable configuration files that can be easily versioned, reused, and shared. 

### Benefits of Terraform
 - Declarative nature. 
   - A declarative tool allows users to specify the end state and the IaC tools will automatically carry out the necessary steps to achieve the user configuration. It is in contrast to other imperative IaC tools where users need to define the exact steps required to achieve the desired state.
  
 - Platform agnostics. 
   - Most IaC tools like AWS CloudFormation and Azure Resource templates are platform specific. Yet, Terraform allows users to use a single tool to manage infrastructure across platforms with applications using many tools, platforms, and multi-cloud architectures.
  
 - Reusable configurations. 
   - Terraform encourages the creation of reusable configurations where users can use the same configuration to provision multiple environments. Additionally Terraform allows creating reusable components within the configuration files with modules.
  
 - Managed state. 
   - With state files keeping track of all the changes in the environment, all modifications are recorded and any unnecessary changes will not occur unless explicitly specified by the user. It can be further automated to detect any config drifts and automatically fix the drift to ensure the desired state is met at all times.
  
 - Easy rollsbacks. 
   - As all configurations are version controlled and the state is managed, users can easily and safely roll back most infrastructure configurations without complicated reconfigurations.
  
 - Integration to CI/CD. 
   - While IaC can be integrated into any pipeline, Terraform provides a simple three-step workflow that can be easily integrated into any CI/CD pipeline. It helps to completely automate the infrastructure management

![terraform_structure](images/terraform.png)
### Use cases
 - Remote encrypted state storage
 - Direct CI/CD integrations
 - Fully remote and SOC2 compliant collaborative environment
 - Version Controls
 - Private Registry to store module and Policy as Code support to configure security and compliance policies
 - Complete auditable environment.
 - Cost estimations before applying infrastructure changes in supported providers.

![best_practices_terraform](images/terraform-best-practicies.png)

### Who uses Terraform

1842 companies reportedly use Terraform in their tech stacks, including Uber, Udemy, and Instacart, Slack, Twitch.

### Who owns Terraform
HashiCorp is a software company with a freemium business model based in San Francisco, California. HashiCorp provides open-source tools and commercial products that enable developers, operators and security professionals to provision, secure, run and connect cloud-computing infrastructure.
![hashi](images/hashicorp_logo.svg)

## Terraform cheat sheat
```
Usage: terraform [global options] <subcommand> [args]

The available commands for execution are listed below.
The primary workflow commands are given first, followed by
less common or more advanced commands.

Main commands:
  init          Prepare your working directory for other commands
  validate      Check whether the configuration is valid
  plan          Show changes required by the current configuration
  apply         Create or update infrastructure
  destroy       Destroy previously-created infrastructure

All other commands:
  console       Try Terraform expressions at an interactive command prompt
  fmt           Reformat your configuration in the standard style
  force-unlock  Release a stuck lock on the current workspace
  get           Install or upgrade remote Terraform modules
  graph         Generate a Graphviz graph of the steps in an operation
  import        Associate existing infrastructure with a Terraform resource
  login         Obtain and save credentials for a remote host
  logout        Remove locally-stored credentials for a remote host
  output        Show output values from your root module
  providers     Show the providers required for this configuration
  refresh       Update the state to match remote systems
  show          Show the current state or a saved plan
  state         Advanced state management
  taint         Mark a resource instance as not fully functional
  test          Experimental support for module integration testing
  untaint       Remove the 'tainted' state from a resource instance
  version       Show the current Terraform version
  workspace     Workspace management

Global options (use these before the subcommand, if any):
  -chdir=DIR    Switch to a different working directory before executing the
                given subcommand.
  -help         Show this help output, or the help for a specified subcommand.
  -version      An alias for the "version" subcommand.
```

## Setup Terraform with AWS

![diagram](images/diagram.png)
### Install Terraform on local machine
 1. Download chocolatey here: `https://chocolatey.org/install`
 2. Run this command in Powershell with admin access:
    1. ```Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))```
    2. This will download terraform on your system
 3. On the same terminal, run: `choco install terraform`
 4. Check for your version to ensure it is installed correctly
    1. `terraform --version`

### Place keys in environment variable
 1. Press the windows key and search for environment
 2. You should see something along the lines of "edit environment vairables"
 3. After clicking on that a new window appears and on the bottom right you should see "Environment variables..."
 4. Open that
 5. In the new window, in the User Variables section add a new variable and call it AWS_ACCESS_KEY
 6. In the value provide your access key
 7. Repeat from step 5 for your secret key

Note: older versions of terraform will require you to add ID at the end of the variable names. (i.e. instead of AWS_ACCESS_KEY you will need AWS_ACCESS_KEY_ID)


### Create Terraform file
 1. Create a new folder
 2. Create a new file called "main.tf"
 3. If you are using VSCode it will be useful to download the default terraform plugin so you can see text and keyword highlighting
 4. In there you can type any script you want
    1. Each topic available will be documented in different sections


### Setup an EC2 instance with custom VPC, Subnet, IG, RT, SGs

#### Create a VPC
```
  resource "aws_vpc" "custom_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      Name = "eng130-angel-terraform-vpc"
    }
  }
```

#### Create Subnet
```
  # Create Subnet 10.0.6.0/24 for public - 10.0.18.0/24 for prvate
  resource "aws_subnet" "eng130-angel-terraform-subnet" {
    vpc_id     = aws_vpc.eng130-angel-terraform-vpc.id
    cidr_block = "10.0.6.0/24"
    tags = {
      "Name" = "eng130-angel-terraform-subnet"
    }
  }
```

#### Create a security group
```
  # Create Security Group for instance
  resource "aws_security_group" "eng130-angel-terraform-sg" {
    name   = "eng130-angel-terraform-sg"
    vpc_id = aws_vpc.eng130-angel-terraform-vpc.id
    # Inbound Rules

    # SSH from anywhere
    ingress {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    # HTTP from anywhere
    ingress {
      description = "HTTP"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      description = "All Outbound Traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "eng130-angel-terraform-sg"
    }

  }
```

#### Create an Internet Gateway
```
  # Create Internet Gateway
  resource "aws_internet_gateway" "eng130-angel-terraform-ig" {
    vpc_id = aws_vpc.eng130-angel-terraform-vpc.id
    tags = {
      Name = "eng130-angel-terraform-ig"
    }
  }
```
#### Create a Route Table
```
  resource "aws_route_table" "eng130-angel-terraform-rt"{
    vpc_id = aws_vpc.custom_vpc
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.eng130-angel-terraform-ig.id
    }

    tags = {
      Name = var.tags.name_of_rt
    }
  }
```

#### Associate route table and vpc
```

  # Create RT association
  resource "aws_main_route_table_association" "eng130-angel-terraform-rta" {
    vpc_id         = aws_vpc.eng130-angel-terraform-vpc.id
    route_table_id = aws_route_table.eng130-angel-terraform-rt.id
  }
```
#### Create an EC2 instance
```
  provider "aws" {

  Which part of AWS we would like to launch resources in
    region = "eu-west-1"

  }
  resource "aws_instance" "app_instance"{
    ami = var.webapp-ami-id# "ami-0b47105e3d7fc023e"
    instance_type = "t2.micro"
    key_name = "eng130"
    associate_public_ip_address = true
    tags = {
      Name = "eng130-angel-terraform-app"
    }
  }
```

## IaC with Controller on AWS
![iac-ansible-terraform](images/IaC_ansible_terraform.png)



upload the yaml file
upload the host file
upload provision file
delete eng99 folder
check provision file for location

alter hosts file to have correct IPs