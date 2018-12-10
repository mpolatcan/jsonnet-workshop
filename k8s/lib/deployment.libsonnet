/*  Simple Kubernetes Deployment Resource Specification with Jsonnet
    Written by Mutlu Polatcan
    10.12.2018 */
{
    Deployment(name, selector, containers, volumes=null): {
        apiVersion: 'apps/v1',
        kind: 'Deployment',
        metadata: {
            name: name
        },
        spec: {
            selector: {
                matchLabels: selector
            },
            template: {
                metadata: {
                    labels: selector
                },
                spec: {
                    containers: containers,
                    [if volumes != null then 'volumes']: volumes
                },
            },
        },
    },
}