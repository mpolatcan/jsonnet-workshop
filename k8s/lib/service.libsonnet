/*  Simple Kubernetes Service Resource Specification with Jsonnet
    Written by Mutlu Polatcan
    10.12.2018 */
{
    Port(name, port, targetPort): {
        name: name, 
        port: port,
        targetPort: targetPort
    },
    Service(name, ports, selector, type): {
        apiVersion: 'v1',
        kind: 'Service',
        metadata: {
            name: name,
        },
        spec: {
            ports: [
                port for port in ports
            ],
            selector: selector,
            type: type,
        },
    },
    type: {
        NodePort: 'NodePort',
        ClusterIp: 'ClusterIP',
        LoadBalancer: 'LoadBalancer'
    },
}