# Replace values at line 1 and 2 below with your cluster name and regions.
ClusterName='workshop-demo'
LogRegion='eu-west-1'
# I have chosen port other than standard 2020 to allow run fluent-bit as a daemon for non tenant loggings. So this wont conflict with your fluent bit Daemonset deployment port 2020
FluentBitHttpPort='2021'
FluentBitReadFromHead='Off'
tenant_name="$1"
tenant_namespace="$1"
[[ ${FluentBitReadFromHead} = 'On' ]] && FluentBitReadFromTail='Off'|| FluentBitReadFromTail='On'
[[ -z ${FluentBitHttpPort} ]] && FluentBitHttpServer='Off' || FluentBitHttpServer='On'
cat tenants.template.yaml | sed 's/{{cluster_name}}/'${ClusterName}'/;s/{{tenant_name}}/'${tenant_name}'/;s/{{tenant_namespace}}/'${tenant_namespace}'/;s/{{region_name}}/'${LogRegion}'/;s/{{http_server_toggle}}/"'${FluentBitHttpServer}'"/;s/{{http_server_port}}/"'${FluentBitHttpPort}'"/;s/{{read_from_head}}/"'${FluentBitReadFromHead}'"/;s/{{read_from_tail}}/"'${FluentBitReadFromTail}'"/' | kubectl apply -f - 
