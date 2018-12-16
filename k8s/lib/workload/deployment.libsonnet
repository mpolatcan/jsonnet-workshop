/*  Kubernetes Deployment API v1 apps Specification with Jsonnet
    Written by Mutlu Polatcan */
{
    create(name): {
        apiVersion: 'apps/v1',
        kind: 'Deployment',
        spec: { template: { } },
        metadata+: { name: name },
        label(key, value):: self { metadata+: { labels+: { [key]: value } } },
        replicas(replicaNum):: self { spec+: { replicas: replicaNum } },
        selector(key, value):: self {
            spec+: {
                selector+: { matchLabels+: { [key]: value } },
                template+: { metadata+: { labels+: { [key]: value } } }
            }, 
        },
        initContainer(container):: self { spec+: { template+: { spec+: { initContainers+: [ container ] } } } },
        container(container):: self { spec+: { template+: { spec+: { containers+: [ container ] } } } },
        affinity(affinity):: self + {
            // TODO Affinity settings  
        },
        antiAffinity(antiAffinity):: self + {
            // TODO Anti affinity settings
        },
        volume(volume):: self { spec+: { template+: { spec+: { volumes+: [ volume ] } } } }
    }
}