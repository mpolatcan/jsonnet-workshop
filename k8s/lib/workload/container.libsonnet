/*  Kubernetes Container API Specification with Jsonnet
    Written by Mutlu Polatcan
    Updated at 15.12.2018 */
{   
    create(name): {
        name: name, 
        imagePullPolicy: self.pullpolicies.IfNotPresent,
        img(image):: self { image: image },
        imgPullPolicy(policy):: self { imagePullPolicy: policy },
        cmd(cmd):: self { command: cmd },
        args(args):: self { args: args },
        port(containerPort, hostPort=null, name=null, protocol=self.portprotocols.TCP):: self {
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
        resource(resourceName, request, limit):: self { resources+: { requests+: { [resourceName]: request }, limits+: { [resourceName]: limit } } },
        volDevice(devicePath,name):: self { volumeDevices+: [ { name: name, devicePath: devicePath } ] },
        termMsgPath(path):: self { terminationMessagePath: path }, 
        termMsgPolicy(policy):: self { terminationMessagePolicy: policy },
        workdir(workdir):: self { workingDir: workdir },
        stdIn(opt):: self { stdin: opt },
        stdInOnce(opt):: self { stdinOnce: opt },
        allocTty(opt):: self { tty: opt },
        probe(type):: self {
            Exec(cmd):: self { 
                [if type == 'liveness' then 'livenessProbe' else if type == 'readiness' then 'readinessProbe' else self.probeErr]+: self._probes.Exec(cmd) 
            },
            TcpSocket(port,host):: self { 
                [if type == 'liveness' then 'livenessProbe' else if type == 'readiness' then 'readinessProbe' else self.probeErr]+: self._probes.TcpSocket(port,host) 
            },
            HttpGet(port,path,host=null,scheme=null):: self { 
                [if type == 'liveness' then 'livenessProbe' else if type == 'readiness' then 'readinessProbe' else self.probeErr]+: self._probes.HttpGet(port,path,host,scheme) 
            },
            initialDelaySecs(secs):: self { 
                [if type == 'liveness' then 'livenessProbe' else if type == 'readiness' then 'readinessProbe' else self.probeErr]+: { initialDelaySeconds: secs } 
            },
            periodSecs(secs):: self { 
                [if type == 'liveness' then 'livenessProbe' else if type == 'readiness' then 'readinessProbe' else self.probeErr]+: { periodSeconds: secs } 
            },
            timeoutSecs(secs):: self { 
                [if type == 'liveness' then 'livenessProbe' else if type == 'readiness' then 'readinessProbe' else self.probeErr]+: { timeoutSeconds: secs } 
            },
            failureThreshold(threshold):: self { 
                [if type == 'liveness' then 'livenessProbe' else if type == 'readiness' then 'readinessProbe' else self.probeErr]+: { failureThreshold: threshold } 
            },
            successThreshold(threshold):: self { 
                [if type == 'liveness' then 'livenessProbe' else if type == 'readiness' then 'readinessProbe' else self.probeErr]+: { successThreshold: threshold } 
            },
            probeErr:: error 'Valid probe types: ["liveness","readiness"]',
        },
        lifeCycle(type):: self {
            local container = self,
            Exec(cmd):: self {
                lifecycle+: {
                    [if type == 'postStart' then 'postStart' else if type == 'preStop' then 'preStop' else self.lifeCycleErr]+: container._probes.Exec(cmd) 
                },
            },
            TcpSocket(port,host):: self { 
                lifecycle+: { 
                    [if type == 'postStart' then 'postStart' else if type == 'preStop' then 'preStop' else self.lifeCycleErr]+: container._probes.TcpSocket(port,host)
                }
            },
            HttpGet(port,path,host=null,scheme=null):: self { 
                lifecycle+: {
                    [if type == 'postStart' then 'postStart' else if type == 'preStop' then 'preStop' else self.lifeCycleErr]+: container._probes.HttpGet(port,path,host,scheme)
                },
            },
            lifeCycleErr:: error 'Valid lifecycle types: ["postStart","preStop"]'
        },
        pullpolicies:: { IfNotPresent: 'IfNotPresent', Always: 'Always' },
        portprotocols:: { TCP: 'TCP', UDP: 'UDP', SCTP: 'SCTP' },
        _probes:: { 
            Exec(cmd): { exec: { command: cmd } },
            TcpSocket(port,host): { tcpSocket: { port: port, host: host } }, 
            HttpGet(port,path,host,scheme): { 
                httpGet: { 
                    port: port,
                    path: path,
                    [if host != null then 'host']: host,
                    [if scheme != null then 'scheme']: scheme
                } 
                // TODO Http Headers will be added
            }
        },
        envVar:: self {
            local envvars = self,
            _keyRef(key,name=null,optional=null):: {
                key: key,
                [if name != null then 'n']: name,
                [if optional != null then 'optional']: optional
            },
            value(envVarName,envVarValue):: self { env+: [ { name: envVarName, value: envVarValue } ] },
            configMap(envVarName,key,name=null,optional=null):: self { env+: [ { name: envVarName, valueFrom: { configMapKeyRef: envvars._keyRef(key,name,optional) } } ] },
            secret(envVarName,key,name=null,optional=null):: self { env+: [ { name: envVarName, valueFrom: { secretKeyRef: envvars._keyRef(key,name,optional) } } ] },
            field(envVarName, fieldPath, apiVersion=null):: self { 
                env+: [ 
                    { 
                        name: envVarName, 
                        valueFrom: { 
                            fieldRef: { 
                                fieldPath: fieldPath, 
                                [if apiVersion != null then 'apiVersion']: apiVersion
                            }
                        } 
                    }
                ]
            },
            resourceField(envVarName, resource, containerName=null, divisor=null):: self {
                env+: [
                    {
                        name: envVarName,
                        valueFrom: {
                            resourceFieldRef: {
                                resource: resource,
                                [if containerName != null then 'containerName']: containerName,
                                [if divisor != null then 'divisor']: divisor
                            },
                        },
                    },
                ],
            },
        },
        securityCtx:: self {
            isPrivileged(opt):: self { securityContext+: { privileged: opt } },
            allowPrivilegeEscalate(opt):: self { securityContext+: { allowPrivilegeEscalation: opt } },
            procMnt(opt):: self { securityContext+: { procMount: opt } },
            readOnlyRootFS(opt):: self { securityContext+: { readOnlyRootFilesystem: opt } },
            runAsGrp(gid):: self { securityContext+: { runAsGroup: gid } },
            runAsNonRoot(opt):: self { securityContext+: { runAsNonRoot: opt } },
            runAsUsr(uid):: self { securityContext+: { runAsUser: uid } },
            seLinuxOpts():: self {
                // TODO SELinux options will be added
            },
            addCapability(capability):: self { securityContext+: { capabilites+: { add+: [ capability ] } } },
            dropCapability(capability):: self { securityContext+: { capabilites+: { drop+: [ capability ] } } }
        }
    }
}