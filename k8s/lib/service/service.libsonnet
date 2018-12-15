/*  Kubernetes Service API Specification with Jsonnet
    Written by Mutlu Polatcan
    Updated at 15.12.2018 */
{
    types:: { NodePort: 'NodePort', ClusterIp: 'ClusterIP', LoadBalancer: 'LoadBalancer' },
    create(name): {
        apiVersion: 'Service',
        kind: 'v1', 
        metadata+: { name: name },  
        spec: { },
        port(name, port, targetPort):: self { spec+: { ports+: [ { name: name, port: port, targetPort: targetPort } ] } },
        selector(key,value):: self { spec+: { selector+: { [key]: value } } },
        annotation(annotation):: self { 
            // TODO Add annotation
        },
        finalizer(finalizer):: self {
            // TODO Add finalizer
        },
        namespace(namespace):: self {
            // TODO namespace
        },
        type(type):: self { spec+: { type: type } },
    }
}