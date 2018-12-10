/*  Simple Container Specification for Kubernetes Deployment Resource with Jsonnet
    Written by Mutlu Polatcan
    10.12.2018 */
{   
    local containerLib = self,
    ProbeTypes: {
        TCPSocket: 'tcpSocket',
        HTTPGet: 'httpGet'
    },
    TCPSocketProbe(port, host): {
        type: containerLib.ProbeTypes.TCPSocket,
        spec: {
            port: port,
            host: host
        },
    },
    HttpGetProbe(port, path): {
        type: containerLib.ProbeTypes.HTTPGet,
        spec: {
            port: port, 
            path: path
        },
    },
    Probe(probe, initialDelaySeconds=1, periodSeconds=3, failureThreshold=3): {
        [probe.type]: probe.spec,
        initialDelaySeconds: initialDelaySeconds,
        periodSeconds: periodSeconds, 
        failureThreshold: failureThreshold
    },
    Resource(name,request,limit): {
        name: name,
        request: request,
        limit: limit
    },
    Resources(resources): {
        requests: {
            [resource.name]: resource.request 
            for resource in resources
        },
        limits: {
            [resource.name]: resource.limit
            for resource in resources
        },
    },
    VolumeMount(name, mountPath, readOnly=false): {
        name: name,
        mountPath: mountPath,
        readOnly: readOnly
    },
    PortProtocols: {
        TCP: 'TCP',
        UDP: 'UDP',
        SCTP: 'SCTP'
    },
    Ports(ports): [
        {
            containerPort: port.containerPort,
            [if port.name != null then 'name']: port.name,
            [if port.hostPort != null then 'hostPort']: port.hostPort,
        }
        for port in ports if port.containerPort != null
    ],
    Port(containerPort, hostPort=null, name=null, protocol=containerLib.PortProtocols.TCP): {
        name: name,
        containerPort: containerPort,
        hostPort: hostPort,
        protocol: protocol
    },
    Container(name, 
              image, 
              imagePullPolicy='IfNotPresent',
              command=null, 
              ports=null,
              volumeMounts=null,
              resources=null,
              livenessProbe=null,
              readinessProbe=null): {
        name: name,
        image: image,
        imagePullPolicy: imagePullPolicy,
        [if command != null then 'command']: command,
        [if ports != null then 'ports']: containerLib.Ports(ports),
        [if volumeMounts != null then 'volumeMounts']: volumeMounts,
        [if resources != null then 'resources']: containerLib.Resources(resources), 
        [if livenessProbe != null then 'livenessProbe']: livenessProbe,
        [if readinessProbe != null then 'readinessProbe']: readinessProbe
    }
}