/* Simple Deployment and Service example with Jsonnet implementation 
    Written by Mutlu Polatcan
    10.12.2018 */
local service = import 'lib/service.libsonnet';
local container = import 'lib/container.libsonnet';
local deployment = import 'lib/deployment.libsonnet';
local labels = import 'lib/labels.libsonnet';
local storage = import 'lib/storage.libsonnet';

[
    service.Service(
        name="test",
        ports=[
            service.Port(name="restapi-https-port", port=443, targetPort=443),
            service.Port(name="restapi-http-port", port=80, targetPort=80),
        ], 
        selector=labels.Selector(
            selectors=[
                ['app','restapi'],
                ['env', 'test'],
            ]),
        type=service.type.LoadBalancer
    ),
    deployment.Deployment(
        name="test", 
        selector=labels.Selector(
            [
                ['app','restapi'],
                ['env', 'test'],
            ]),
        containers=[
            container.Container(
                name='restapi',
                image='restapi/restapi',
                command=["gunicorn","-w","16","--bind","0.0.0.0:5000","--chdir","/restapi/code","app:app"],
                livenessProbe=container.Probe(probe=container.HttpGetProbe(port="5000",path="/"), failureThreshold=3),
                readinessProbe=container.Probe(probe=container.HttpGetProbe(port="5000",path="/"), failureThreshold=3),
                resources=[
                    container.Resource(name='cpu',request='100m',limit='500m'),
                    container.Resource(name='memory',request='1Gi',limit='2Gi'),
                ],
                volumeMounts=[
                    container.VolumeMount(name="volume-1", mountPath="/")
                ],
                ports=[
                    container.Port(containerPort=5000)
                ],
            ),
        ],
        volumes=[
            storage.Volume(name="restapi",type=storage.HostPathVolume(path="/restapi"))
        ],
    )
]