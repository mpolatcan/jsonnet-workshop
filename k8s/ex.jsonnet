/*  Deployment and Service example with Jsonnet implementation 
    Written by Mutlu Polatcan
    Updated at 15.12.2018 */

local k8s = import 'lib/k8s.libsonnet';

std.manifestYamlStream(
    [
        k8s.service.create('minecraft-service')
            .port('minecraft-server', 8080, 8080).port('minecraft-client', 25675, 25675)
            .selector('app','minecraft').selector('env','test')
            .type(k8s.service.types.ClusterIp),
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
                    .liveProbe(k8s.probe.create(k8s.probe.types.HttpGet(8080,'/').httpHeader('test','test')))
                    .readyProbe(k8s.probe.create(k8s.probe.types.Exec(["echo","hello"])))
                    .envVar(k8s.env.create('test').fromSecretKeyRef('minecraft'))
                    .securityCtx(k8s.securityContext.runAsUsr(1000).runAsGrp(1000))
                    .allocTty(true)
                    .stdIn(true)
                    .stdInOnce(true)
            )
    ]
)