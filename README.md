> **This module is very useful to create S3 bucket with all the key functionalities such as data encryption, server logs, versioning, life cycle management and public restrictions etc.,** 

 > **PREREQUISITES**
 
 1) Make sure you have required S3 permissions and priviliges attached to your IAM user. 

 2) Please use KMS key module "jayaworld-kms-key" [Terraform modules](https://registry.terraform.io/modules) to create KMS Key. If you already have KMS key, you can avoid doing this. 
  
  module "jayaworld-kms-key" {

  source  = "app.terraform.io/jaya-world/jayaworld-kms-key/aws"
  
  **insert the variables**

  }

> **IMPORTNAT NOTES**

This module also encourages you to enable server logging, and so, it requires to provide log bucket name. If you want to use existing log bucket, feel free to provide it's name in the variable "log_bucket_name". 

By defualt, any organization restricts public access to the s3 buckets and objects. However, there are some cases you might need to enable public read access. In that case you need to modify public acl variables to false (NOT HIGHLY RECOMMENDED). Also, keep in mind onething that your AWS account settings will override the public access controls specified for the bucket and object. You might need to check with your AWS account admin who can make this changes to account level. 

**Finally use this module**

  module "jayaworld-s3-bucket" {

  source  = "app.terraform.io/jaya-world/jayaworld-s3-bucket/aws"
  
  **insert required variables here**

  }