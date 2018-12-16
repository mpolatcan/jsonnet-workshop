{
    image:: {
        pullpolicies:: { IfNotPresent: 'IfNotPresent', Always: 'Always' }
    },
    port:: {
        protocols:: { TCP: 'TCP', UDP: 'UDP', SCTP: 'SCTP' }
    },
    service:: {
        types:: { NodePort: 'NodePort', ClusterIp: 'ClusterIP', LoadBalancer: 'LoadBalancer' }
    },
}