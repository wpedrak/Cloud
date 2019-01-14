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
  * RotateSecret (more about: you can set up lambda function to create new version and SM will call it and use new version as current in random moments)

###### Hashicorp Vault

* Works via Http API or CLI
* In general: paths and key/value pairs
* Many engines (start of path), many usages (e.g. **aws** for IAM roles generation, **database** for on-demand, time limited database creds)

###### Cloud KMS

* do it yourself... god, why?

#### Ex7

- **Handbook**  is a type of reference work, or other collection of instructions, that is intended to provide ready reference. Set of usefull instructions. Example: IntelliJ handbook (http://index-of.es/Varios-2/IntelliJ-IDEA-Handbook.pdf).
- **Runbook** is a compilation of routine procedures and operations that the system administrator or operator carries out. System administrators in IT departments and NOCs use runbooks as a reference. Runbooks can be in either electronic or in physical book form. Typically, a runbook contains procedures to begin, stop, supervise, and debug the system. It may also describe procedures for handling special requests and contingencies. An effective runbook allows other operators, with prerequisite expertise, to effectively manage and troubleshoot a system. Through runbook automation, these processes can be carried out using software tools in a predetermined manner. Example: IBM example (https://www.ibm.com/support/knowledgecenter/en/SSZQDR/com.ibm.rba.doc/GS_example.html)
- **Disaster Recovery Plan** is a documented process or set of procedures to recover and protect a business IT infrastructure in the event of a disaster. Such a plan, ordinarily documented in written form, specifies procedures an organization is to follow in the event of a disaster. It is "a comprehensive statement of consistent actions to be taken before, during and after a disaster". Example: IBM (https://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_73/rzarm/rzarmdisastr.htm)
- **Recovery Time Objective** is the time within which a business process must be restored, after a major incident (MI) has occurred, in order to avoid unacceptable consequences associated with a break in business continuity.
- **Recovery Point Objective** is the age of files that must be recovered from backup storage for normal operations to resume if a computer, system, or network goes down as a result of a MI. The RPO is expressed backwards in time (that is, into the past) starting from the instant at which the MI occurs, and can be specified in seconds, minutes, hours, or days. The recovery point objective (RPO) is thus the maximum acceptable amount of data loss measured in time. It is the age of the files or data in backup storage required to resume normal operations after the MI.
- **Postmortem Documentation** is a lessons learned. What happend? What was done correctly and what wasn't? It helps to sort things out. Example: GitLab (https://about.gitlab.com/2017/02/10/postmortem-of-database-outage-of-january-31/)