/*  Simple Kubernetes Volume Resources Specification with Jsonnet
    Written by Mutlu Polatcan
    10.12.2018 */
{
    local storageLib = self, 
    VolumeTypes: {
        HostPath: 'hostPath',
        NFS: 'nfs',
        GCEPersistentDisk: 'gcePersistentDisk',
        PVC: 'persistentVolumeClaim'
    },
    GCEFSTypes: {
        EXT4: 'ext4',
        NTFS: 'ntfs',
        XFS: 'xfs'
    },
    HostPathVolume(path): {
        get_type():: storageLib.VolumeTypes.HostPath,
        path: path
    },
    PVCVolume(claimName): {
        get_type():: storageLib.VolumeTypes.PVC,
        claimName: claimName
    },
    NFSVolume(server,path): {
        get_type():: storageLib.VolumeTypes.NFS,
        server: server, 
        path: path
    },
    GCEPersistentDisk(pdName,fsType=storageLib.GCEFSTypes.EXT4, readOnly=false): {
        get_type():: storageLib.VolumeTypes.GCEPersistentDisk,
        pdName: pdName,
        fsType: fsType,
        readOnly: readOnly
    },
    Volume(name, type): {
        name: name,
        [type.get_type()]: type
    },
}