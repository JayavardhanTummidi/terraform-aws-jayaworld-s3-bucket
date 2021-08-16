This module is very useful to create S3 bucket with all the key functionalities such as data encryption, server logs, versioning and public restrictions etc., 

As mentioned above, this module is created with the organization best practises. So it's important to create few resources prior to use this module. So, please read below prerequisites before proceeding to use this module.

 PREREQUISITES
 =============
 1) Please use KMS key module "jayaworld-kms-key" to create KMS Key. If you already have KMS key, you can avoid doing this. 

 2) Please use S3 logs bucket module "jayaworld-s3-logs-bucket" to create s3 logs bucket. If you already have s3 log bucket, you can avoid this. 

 3) Once 1 and 2 is created, you can simply pass it into the variables in this module. Please refer variables column. 

 NOTE:- The only reason i didn't include kms key and s3 log bucket creation resources in this module, because each time when you use this module, it will create duplicate kms and s3 log buckets. To avoid this, it's better to create them separtely and use it as variables as mentioned above in 1, 2 and 3. 

 By defualt, any organization restricts public access to the s3 buckets and objects. However, there are some cases you might need to enable public read access. In the case you need to modify following variables to false (NOT HIGHLY RECOMMENDED). Also, keep in mind onething that your AWS account settings will override the public access controls specified for the bucket and object. You might need to check with your AWS account admin who can make this changes to account level. 
 
 # S3 will block public access permissions applied to newly added buckets or objects, and prevent the creation of new public access ACLs for existing buckets and objects. This setting doesn’t change any existing permissions that allow public access to S3 resources using ACLs.
  block_public_acls = true
 # S3 will ignore all ACLs that grant public access to buckets and objects.
  ignore_public_acls = true
 # S3 will block new bucket and access point policies that grant public access to buckets and objects. This setting doesn't change any existing policies that allow public access to S3 resources
  block_public_policy = true
 # S3 will ignore public and cross-account access for buckets or access points with policies that grant public access to buckets and objects.
  restrict_public_buckets = true