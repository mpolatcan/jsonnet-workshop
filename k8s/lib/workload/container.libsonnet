/*  Kubernetes Container API Specification with Jsonnet
    Written by Mutlu Polatcan
    Updated at 15.12.2018 */
{   
    local container = self, 
    pullpolicies:: { IfNotPresent: 'IfNotPresent', Always: 'Always' },
    portprotocols:: { TCP: 'TCP', UDP: 'UDP', SCTP: 'SCTP' },
    probe:: {
        local probes = self,
        types:: { 
            Exec(cmd): { type: 'exec', spec: { command: cmd } },
            TcpSocket(port,host): { type: 'tcpSocket', spec: { port: port, host: host } }, 
            HttpGet(port,path,host=null,scheme=null): { 
                type: 'httpGet', 
                spec: { 
                    port: port, 
                    path: path,
                    [if host != null then 'host']: host,
                    [if scheme != null then 'scheme']: scheme,
                },
                httpHeader(name, value): self { spec+: { httpHeaders+: [ { name: name, value: value } ] } },
            }
        },
        create(probespec, initialDelaySeconds=1, periodSeconds=3, timeoutSeconds=1, failureThreshold=3, successfullThreshold=1): {
            probespec: probespec, 
            initialDelaySeconds: initialDelaySeconds,
            periodSeconds: periodSeconds, 
            timeoutSeconds: timeoutSeconds,
            failureThreshold: failureThreshold, 
            successfullThreshold: successfullThreshold
        },
    },
    env:: {
        create(name): {
            name: name,
            value(value):: self { value: value },
            fromConfigMapKeyRef(key, name=null, optional=null):: self {
                valueFrom: {
                    configMapKey: {
                        key: key,
                        [if name != null then 'name']: name,
                        [if optional != null then 'optional']: optional
                    }
                },
            },
            fromSecretKeyRef(key, name=null, optional=null):: self {
                valueFrom: {
                    secretKeyRef: {
                        key: key,
                        [if name != null then 'name']: name,
                        [if optional != null then 'optional']: optional
                    }
                },
            },
            fromFieldRef(fieldPath, apiVersion=null):: self {
                valueFrom: {
                    fieldRef: {
                        fieldPath: fieldPath,
                        [if apiVersion != null then 'apiVersion']: apiVersion
                    },
                },
            },
            fromResourceFieldRef(resource, containerName=null, divisor=null):: self {
                valueFrom: {
                    resourceFieldRef: {
                        resource: resource,
                        [if containerName != null then 'containerName']: containerName,
                        [if divisor != null then 'divisor']: divisor
                    },
                },
            }
        }
    },
    lifecycle:: {
        postStart(probespec): self { postStart: probespec },
        preStop(probespec): self { preStop: probespec },
    },
    securityContext:: {
        isPrivileged(opt):: self { privileged: opt },
        allowPrivilegeEscalation(opt):: self { 'allowPrivilegeEscalation': opt },
        procMnt(opt):: self { procMount: opt },
        readOnlyRootFS(opt):: self { readOnlyRootFilesystem: opt },
        runAsGrp(gid):: self { runAsGroup: gid },
        runAsNonRoot(opt):: self { runAsNonRoot: opt },
        runAsUsr(uid):: self { runAsUser: uid },
        seLinuxOpts():: self {
            // TODO SELinux options will be added
        },
        addCapability(capability):: self { capabilites+: { add+: [ capability ] } },
        dropCapability(capability):: self { capabilites+: { drop+: [ capability ] } }
    },
    create(name): {
        name: name, 
        imagePullPolicy: container.pullpolicies.IfNotPresent,
        img(image):: self { image: image },
        imgPullPolicy(policy):: self { imagePullPolicy: policy },
        cmd(cmd):: self { command: cmd },
        args(args):: self { args: args },
        port(containerPort, hostPort=null, name=null, protocol=container.portprotocols.TCP):: self {
            ports+: [
                {
                    containerPort: containerPort,
                    protocol: protocol,
                    [if hostPort != null then 'hostPort']: hostPort,
                    [if name != null then 'name']: name
                }
            ],
        },
        volMnt(name, mountPath, readOnly=false):: self {
            volumeMounts+: [ { name: name, mountPath: mountPath, readOnly: readOnly } ]
        },
        resource(resourceName, request, limit):: self {
            resources+: {
                requests+: { [resourceName]: request },
                limits+: { [resourceName]: limit }
            }
        },
        liveProbe(probe):: self { livenessProbe+: { [probe.probespec.type]: probe.probespec.spec } },
        readyProbe(probe):: self { readinessProbe+: { [probe.probespec.type]: probe.probespec.spec } },
        volDevice(devicePath,name):: self { volumeDevices+: [ { name: name, devicePath: devicePath } ] },
        termMsgPath(path):: self { terminationMessagePath: path }, 
        termMsgPolicy(policy):: self { terminationMessagePolicy: policy },
        workdir(workdir):: self { workingDir: workdir },
        envVar(env):: self { env+: [ env ] },
        stdIn(opt):: self { stdin: opt },
        stdInOnce(opt):: self { stdinOnce: opt },
        allocTty(opt):: self { tty: opt },
        securityCtx(sc):: self { securityContext: sc }
    }
}