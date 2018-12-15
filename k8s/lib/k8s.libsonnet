{
    service: import 'service/service.libsonnet',
    deployment: import 'workload/deployment.libsonnet',
    container: import 'workload/container.libsonnet',
    probe: self.container.probe,
    env: self.container.env,
    securityContext: self.container.securityContext
}