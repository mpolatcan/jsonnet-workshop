/*  Kubernetes Service API v1 Core Specification with Jsonnet
    Written by Mutlu Polatcan */

local constants = import '../utils/constants.libsonnet';
{
    create(name): {
        apiVersion: 'Service',
        kind: 'v1', 
        metadata+: { name: name },  
        port(name, port, targetPort, nodePort=null, protocol=constants.port.protocols.TCP):: self { 
            spec+: { 
                ports+: [ 
                    { 
                        name: name, 
                        port: port, 
                        targetPort: targetPort,
                        protocol: protocol,
                        [if nodePort != null then 'nodePort']: nodePort
                    } 
                ] 
            } 
        },
        selector(key,value):: self { spec+: { selector+: { [key]: value } } },
        annotation(key,value):: self { metadata+: { annotations+: { [key]: value } } },
        namespace(ns):: self { metadata+: { namespace: ns } },
        delGracePeriodSecs(secs):: self { metadata+: { deletionGracePeriodSeconds: secs } },
        clusterName(name):: self { metadata+: { clusterName: name } },
        type(type):: self { spec+: { type: type } },
        lbIp(ip):: self { spec+: { loadBalancerIP: ip } },
        lbSourceRange(range):: self { spec+: { loadBalancerSourceRanges+: [ range ] } },
        clusterIp(ip):: self { spec+: { clusterIP: ip } },
        extName(name):: self { spec+: { externalName: name } },
        extIp(ip):: self { spec+: { externalIPs+: [ ip ] } },
        extTrafficPolicy(policy):: self { spec+: { externalTrafficPolicy: policy } },
        sessionAffinity(sa):: self { spec+: { sessionAffinity: sa } },
        sessionAffinityConf:: self {
            clientIp:: self {
                timeoutSecs(secs):: self { spec+: { sessionAffinityConfig+: { clientIp: { timeoutSeconds: secs } } } },
            },
        },
    }
}