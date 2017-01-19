. + {
  taskdef: {
    family: .meta.SERVICE_NAME,
    taskRoleArn: .meta.STACK_DETAILS.outputs.ServiceRoleArn,
    containerDefinitions: [({
      name: "web",
      environment: ( .environment | to_entries | map({ name: .key, value: .value | tostring }) ),
      image: .meta.DOCKER_IMAGE,
      memory: ( if .meta.ECS_MEMORY_RESERVATION then .meta.ECS_MEMORY_RESERVATION else 235 end ),
      cpu: ( if .meta.ECS_CPU_RESERVATION then .meta.ECS_CPU_RESERVATION else 64 end ),
      portMappings: [ { containerPort: .environment.PORT | tonumber, hostPort: .environment.PORT | tonumber } ],
      dockerLabels: ({
        "logentries.token": ( if .meta.LOGENTRIES_TOKEN then .meta.LOGENTRIES_TOKEN else "" end ),
        env: .meta.ENV_NAME,
        component: .meta.COMPONENT_NAME,
        team: .meta.TEAM,
        version: .meta.VERSION,
        product: ( if .meta.PRODUCT then .meta.PRODUCT else "undefined" end )
      } + (if .meta.LEG and .meta.LEG != "" then { leg: .meta.LEG } else {} end)),
    } + (
      if .meta.DOCKER_COMMAND then
        {
          command: .meta.DOCKER_COMMAND,
        }
      else
        {}
      end
    ))]
  }
}
