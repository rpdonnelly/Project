#Author: Ryan Donnelly
#Date 6/8/16
#Purpose: Interview Project that will generate a csv report of all instances in a defined VPC, or all VPC if left blank.
#It will display the VPC ID, Instance ID, Private IP address, and all attached security groups; pipe-delimited if multiple groups are attached to an instance.
#Requirements:  This must be run from a windows computer within your AWS environment, or a local machine that has access to your AWS account, with the aws sdk cmdlets loaded.
#This script assumes you have a powershell profile defined that has appropriate credentials (access key and shared secret) with rights to read ec2 information.

$vpcid = '*'
$input = Read-Host -Prompt 'Input your VPC ID; for all VPC leave blank'

if ($input -ne '') { $vpcid = $input }

$MyInstances = (Get-EC2Instance -Filter @{Name="vpc-id"; Values=$vpcid} ).Instances 

$MyInstances | select VpcId, InstanceId, PrivateIpAddress, @{Name=’SecurityGroups';Expression={[string]::join(“|”, ($_.SecurityGroups.GroupName))}} | Export-Csv -NoTypeInformation c:\scripts\report.csv