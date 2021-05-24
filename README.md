**EKS Multi-Tenant-Logging using fluent-bit and Cloudwatch Logs**

This is a sample configuration and script to install and run a tenant into multi tenant configuration on Kubernetes (EKS). This examples uses namespace islolation for tenant isolation. But config can be modified further if you have logical isolation at application level.

The deployment runs a sample nginx container and fluent-bit sidecar. For your pratical use case you might only need to update deployment yaml to include your app container definition.

![alt text](https://github.com/priyavartk/eks-multi-tenant-logging/blob/main/Screenshot%202021-05-24%20at%2011.29.12.png?raw=true)

The fluent-bit sidecar container relies on AWS credentials from under lying instances(can be Node groups IAM role) but work is in progress to annotate it with IAM roles so that we dont have to deal with EC2 IAM roles.

 **How to Install** 

Modify InstallTenants.sh script with your EKS cluster name and region for cloudwatch log groups.

**run InstallTenants.sh tenant-name **
 
the script uses \'sed \'to replace config values and generate a runtime config from template which creates namespace/configmaps required to run application container and fluent-bit.
  
If you dont need a templatised version or you have need to install different application code container for each tenant, then simply take the template and update with your tenant's application container image, rest of the config will remain same.
  
The deployment create a Kubernetes service with Loadbalancer which then you can use to hit the application after deployment. The Cloudwatch logs are created in pattern \"/aws/containerinsights/\<CLUSTER-NAME\>/\<yourChosenAppName\>\/<tenant-name\>\".
 
Get your LB name/URL by running #kubectl get svc <tenant-name>
  
Because we are deploying nginx as a sample application code container,we are using nginx access logs fields in processing logs for insights query dashboard.
  
**Few of sample Dashboard queries for Clodwatch Logs insights looks like as below.**
  
  **"Logs by Pod name "**
 
fields log,kubernetes.pod_name|filter  stream !='stderr'|  parse log '* - - [*] "\* \* \*" \* \* "-" "\*"' as remote_addr, timestamp, request_type, location, protocol, response_code, body_bytes_sent, user_agent 

**If you chose to run dashboard for multiple tenants logs groups then you can create application log dashboard like below.**
 
fields log,kubernetes.pod_name,kubernetes.namespace_name as tenant|filter  stream !='stderr'|  parse log '* - - [*] "\* \* \*" \* \* "-" "\*"' as remote_addr, timestamp, request_type, location, protocol, response_code, body_bytes_sent, user_agent 





![alt text](https://github.com/priyavartk/eks-multi-tenant-logging/blob/main/Screenshot%202021-05-24%20at%2010.30.17.png?raw=true)


**Disclaimer: InstallTenant.sh is little modified from a default script from AWS docs**
