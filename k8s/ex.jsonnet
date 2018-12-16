/*  Deployment and Service example with Jsonnet implementation 
    Written by Mutlu Polatcan
    Updated at 15.12.2018 */

local k8s = import 'lib/k8s.libsonnet';

std.manifestYamlStream(
    [
        k8s.service.create('minecraft-service')
            .port('minecraft-server', 8080, 8080)
            .port('minecraft-client', 25675, 25675)
            .selector('app','minecraft')
            .selector('env','test')
            .type(k8s.service.types.ClusterIp),
        k8s.deployment.create("test")
            .label('app', 'minecraft')
            .selector('app','minecraft')
            .selector('env','test')
            .initContainer(k8s.container.create('minecraft').img('mpolatcan/echo').cmd('git pull'))
            .container(
                k8s.container.create('minecraft')
                    .img('mpolatcan/minecraft')
                    .cmd('echo hello minecraft!')
                    .port(containerPort=8080, name="minecraft-server")
                    .port(containerPort=25675, name="minecraft-client")
                    .resource('cpu', '200Mi', '500Mi')
                    .resource('memory', '512Mi', '1Gi')
                    .volMnt('minecraft-vol', '/')
                    .probe('readiness').Exec("echo hello world").initialDelaySecs(3)
                    .envVar.value('app','minecraft')
                    .envVar.configMap('app','name')
                    .envVar.field('app','test')
                    .envVar.resourceField('app','test')
                    .lifeCycle('postStart').Exec('echo')
                    .lifeCycle('preStop').TcpSocket(8080,'localhost')
                    .securityCtx.runAsUsr(1000).runAsGrp(1000)
                    .allocTty(true)
                    .stdIn(true)
                    .stdInOnce(true)
            )
    ]
)