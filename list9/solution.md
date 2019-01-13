#### Ex2
###### AWS Secrets Manager

* Works via HTTP API or SDK
* In general: there are secrets(names), versions of secrets and rotation of credentials
* Integration with RDS (MySQL, Postgres, Aurora)
* Basic Functions:  
  * Create secret (this is what you pay for)
  * GetSecretValue (self explaining)
  * PutSecretValue (new secret version)
  * UpdateSecretValue (update version)
  * RotateSecret (more about: you can set up lambda function to create new version and SM will call it and use new version as current in random moment)

###### Hashicorp Vault

* Works via Http API or CLI
* In general: paths and key/value pairs
* Many engines (start of path), many usages (e.g. **aws** for IAM roles generation, **database** for on-demand, time limited database creds)

###### Cloud KMS

* do it yourself... god, why?