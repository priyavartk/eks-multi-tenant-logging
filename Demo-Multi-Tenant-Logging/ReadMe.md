This is a sample configuration and script to install and run a tenant into multi tenant configuration on Kubernetes (EKS).
The deployment runs a sample nginx container and fluent-bit sidecar. For your pratical use case you might only need to update deployment yaml to include your app container definition.
The fluent-bit sidecar container relies on AWS credentials from under lying instances(can be Node groups IAM role) but work is in progress to annotate it with IAM roles so that we dont have to deal with EC2 IAM roles.
