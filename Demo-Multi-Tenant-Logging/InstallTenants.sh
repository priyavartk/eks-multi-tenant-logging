# Update Install script with your cluster name and Log region
#run script InstallTenants.sh <nameOfTenant>
ClusterName=<eks-cluster-name>
LogRegion='eu-west-1'
FluentBitHttpPort='2021'
FluentBitReadFromHead='Off'
tenant_name="$1"
tenant_namespace="$1"
[[ ${FluentBitReadFromHead} = 'On' ]] && FluentBitReadFromTail='Off'|| FluentBitReadFromTail='On'
[[ -z ${FluentBitHttpPort} ]] && FluentBitHttpServer='Off' || FluentBitHttpServer='On'
cat tenants.template.yaml | sed 's/{{cluster_name}}/'${ClusterName}'/;s/{{tenant_name}}/'${tenant_name}'/;s/{{tenant_namespace}}/'${tenant_namespace}'/;s/{{region_name}}/'${LogRegion}'/;s/{{http_server_toggle}}/"'${FluentBitHttpServer}'"/;s/{{http_server_port}}/"'${FluentBitHttpPort}'"/;s/{{read_from_head}}/"'${FluentBitReadFromHead}'"/;s/{{read_from_tail}}/"'${FluentBitReadFromTail}'"/' | kubectl apply -f - 
