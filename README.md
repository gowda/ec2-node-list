## ec2-node-list

Command-line utility to fetch the list of EC2 instances.

Output is a CSV is of the form:
```
<name>, <region>, <hostname>, <reachability>
```

### Prerequisites

* Install EC2 CLI from [Amazon EC2 website](http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/set-up-ec2-cli-linux.html)
* Setup EC2 CLI with credentials. ([read here](http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/set-up-ec2-cli-linux.html#set_aws_credentials_linux))
* GNU Sed (Only for Mac OS X users)

### Usage

```bash
$ bash find-instances.sh
```
