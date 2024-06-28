# nextflow-aws-batch-poc
This project is to demonstrate running a Nextflow workflow using AWS resources as the back-end (AWS Batch using Fargate, S3).

In a real-world scenario, this would be containerized and run from an AWS ECS task using Fargate.

## Setup
Below are the actions to take before you can run the Nextflow workflow.

### AWS Resources
Below are the AWS resources needed to run the Nextflow workflow.

#### IAM User/Group
Create an IAM user/group.  Attach the following AWS managed policies to the user/group:
* AmazonEC2FullAccess
* AmazonS3FullAccess
* AWSBatchFullAccess

Create and attach the following customer inline policy:
* GetAndPassRolePolicy
```
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": [
				"iam:GetRole",
				"iam:PassRole"
			],
			"Resource": "*"
		}
	]
}
```

> NOTE: In a real-world application, we should apply the Principle of Least Privilege and create customer-defined policies that only include the specific permissions needed.

#### S3 bucket
Create a general-purpose S3 bucket that will hold the working files from Nextflow runs.  Add a top-level folder named `work`.

#### Batch
Create a compute environment as follows:
1. Compute environment configuration
    1. Choose Fargate
    2. Specify a name for the compute environment
    3. Allow Batch to create the Service role for you
2. Instance configuration
    1. Enable Use Fargate Spot capacity (for trial accounts, demo purposes only)
    2. Specify Maximum vCPUs
3. Network configuration
    1. Accept the defaults

Create a job queue as follows:
1. Choose Fargate
2. Specify a name for the job queue
3. Select the compute environment you created earlier
4. Add the following job state limits:
    1. MISCONFIGURATION:COMPUTE_ENVIRONMENT_MAX_RESOURCE 600s
    2. MISCONFIGURATION:JOB_RESOURCE_REQUIREMENT 600s
    3. CAPACITY:INSUFFICIENT_INSTANCE_CAPACITY 600s

### Nextflow CLI
You'll need to install the Nextflow CLI (and its prerequisites) on the machine that will kick off the Nextflow workflow.

On Windows, it is recommended to install it on WSL Ubuntu.

https://www.nextflow.io/docs/latest/install.html

### Config
To run the Nextflow workflow against AWS resources (Batch, S3), you'll need to modify values in the `nextflow.config` file first:

* aws.batch.jobRole
* aws.batch.executionRole
* aws.region
* aws.accessKey
* aws.secretKey

> NOTE: In a real-world application, AWS credentials for an IAM user would NOT be supplied via the config file.  Instead an IAM role would be used with the appropriate attached policies by an AWS ECS task.

## Run
Execute the `main.sh` shell script from the project root.  

Logs should be written to `./logs`.  

Results should be written to `./results`.  

All working files used by Nextflow during the workflow execution will be in the S3 bucket at the path specified in the config.
