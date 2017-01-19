{
  name: .meta.SERVICE_NAME,
  region: .meta.REGION,
  parameters: ({
    backendPort: .environment.PORT | tostring,
    environment: .meta.ENV_NAME,
    componentName: .meta.COMPONENT_NAME,
    clientSecurityGroup: .meta.ECS_PARAMS.client_security_group,
    elbAccessLogsBucket: .meta.ELB_ACCESS_LOGS_BUCKET,
    subnets: ( if .meta.ELBTYPE == "internet-facing" 
                then .meta.ECS_PARAMS.subnets | join(",") 
                else .meta.ECS_PARAMS.private_subnets | join(",") 
              end),
    vpc: .meta.ECS_PARAMS.vpc,
    leg: (if .meta.LEG != "" then .meta.LEG else "none" end),
  } + (
    if .meta.NO_DNS then
      {}
    else
      {
        dnsName: .meta.DNS_NAME,
        dnsZone: .meta.DNS_ZONE,
      }
    end
  ) + (
    if .meta.ELB_CERT then
      { sslCertificateId: .meta.ELB_CERT }
    else
      {}
    end
  ) + (
    if .meta.HEALTHCHECK_SUFFIX then
      { healthcheckSuffix: .meta.HEALTHCHECK_SUFFIX }
    else
      {}
    end
  ) + (
    if .meta.ELBTYPE then
      { ELBType: .meta.ELBTYPE }
    else
      {}
    end
  )),
  tags: {
    Project: .meta.TEAM,
    Component: .meta.COMPONENT_NAME,
    Environment: .meta.ENV_NAME,
  },
  capabilities: [ "CAPABILITY_IAM" ],
  template_file: "infrastructure/ecs-deployment-scripts/stack.json",
}
