/*  Deployment and Service example with Jsonnet implementation 
    Written by Mutlu Polatcan */
local k8s = import 'lib/k8s.libsonnet';

std.manifestYamlStream(
    [
        k8s.service.create('minecraft-service')
            .namespace('default')
            .clusterName('test-cluster')
            .port('minecraft-server', 8080, 8080).port('minecraft-client', 25675, 25675)
            .annotation('kubernetes.io/hostname','minecraft')
            .selector('app','minecraft').selector('env','test')
            .type(k8s.constants.service.types.ClusterIp)
            .extIp('xx.xx.xx.xx')
            .extName('test')
            .lbIp('xx.xx.xx.xx')
            .lbSourceRange('xx.xx.xx.xx/x')
            .extTrafficPolicy('test')
            .sessionAffinity('test')
            .sessionAffinityConf.clientIp.timeoutSecs(3),
        k8s.deployment.create("test")
            .label('app', 'minecraft')
            .selector('app','minecraft').selector('env','test')
            .initContainer(k8s.container.create('minecraft').img('mpolatcan/echo').cmd('git pull'))
            .container(
                k8s.container.create('minecraft')
                    .img('mpolatcan/minecraft')
                    .cmd('echo hello minecraft!')
                    .port(containerPort=8080, name="minecraft-server").port(containerPort=25675, name="minecraft-client")
                    .resource('cpu', '200Mi', '500Mi').resource('memory', '512Mi', '1Gi')
                    .volMnt('minecraft-vol', '/')
                    .probe('readiness').Exec("echo hello world").initialDelaySecs(3)
                    .envVar.value('app','minecraft').envVar.configMap('app','name')
                    .envVar.field('app','test').envVar.resourceField('app','test')
                    .lifeCycle('postStart').Exec('echo').lifeCycle('preStop').TcpSocket(8080,'localhost')
                    .securityCtx.runAsUser(1000).runAsGroup(1000).runAsNonRoot(true).seLinuxOpts.user('mpolatcan').role('admin')
                    .allocTty(true).stdIn(true).stdInOnce(true)
            )
    ]
)