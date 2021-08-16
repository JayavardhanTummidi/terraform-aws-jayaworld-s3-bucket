**This module is very useful to create S3 bucket with all the key functionalities such as data encryption, server logs, versioning, life cycle management and public restrictions etc.,** 

As mentioned above, this module is created with the organization best practises. So it's important to create few resources prior to use this module. So, please read below prerequisites before proceeding to use this module.

 **PREREQUISITES**
 
 1) Please use KMS key module "jayaworld-kms-key" (from https://registry.terraform.io) to create KMS Key. If you already have KMS key, you can avoid doing this. 
  
  module "jayaworld-kms-key" {
  source  = "app.terraform.io/jaya-world/jayaworld-kms-key/aws"
  # insert the variables
  }

 2) Please use S3 logs bucket module "jayaworld-s3-logs-bucket" (from https://registry.terraform.io) to create s3 logs bucket. If you already have s3 log bucket, you can avoid this. 

  module "jayaworld-s3-logs-bucket" {
  source  = "app.terraform.io/jaya-world/jayaworld-s3-logs-bucket/aws"
  # insert the variables
  }

 3) Once 1 and 2 is created, you can simply pass it into the variables in this module. Please refer inputs column. 

 NOTE:- The only reason i didn't include kms key and s3 log bucket creation resources in this module, because each time when you use this module, it will create duplicate kms and s3 log buckets. To avoid this, it's better to create them separtely and use it as variables as mentioned above in 1, 2 and 3. 

 By defualt, any organization restricts public access to the s3 buckets and objects. However, there are some cases you might need to enable public read access. In that case you need to modify public acl variables to false (NOT HIGHLY RECOMMENDED). Also, keep in mind onething that your AWS account settings will override the public access controls specified for the bucket and object. You might need to check with your AWS account admin who can make this changes to account level. 

 **Finally use this module**

 module "jayaworld-s3-bucket" {
  source  = "app.terraform.io/jaya-world/jayaworld-s3-bucket/aws"
  # insert required variables here
 }