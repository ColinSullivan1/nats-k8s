# NATS Streaming Server Helm Chart

Installs a [NATS](http://nats.io/) streaming server for use with NATS clients.

## TL;DR;

```console
$ helm install nats-server
```

**NOTE:**  Sometimes the initial pod creation fails due to timing with its dependencies (Core NATS or the PVC).  This is a known issue,
Kubernetes will restart the pods and you'll be good to go in a few seconds if this happens.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release nats-streaming-server
```

### Dependencies

This chart has a depenency on the [NATS server](../nats-server) chart and will install it.

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## NATS streaming server scaling

This chart installs **two** NATS streaming servers, one active and the other as a fault tolerant backup.  As the NATS streaming server deployment is scaled, additional servers will act as backups, although ideally you will only need two.

### Resources

In choosing resources, NATS streaming server can consume much memory.  You'll want to set resources accordingly.  Also, be sure you have room on the PVC for your server configuration.


## Configuration

| Parameter                                 | Description                                      | Default                                           |
|-------------------------------------------|-------------------------------------             |---------------------------------------------------|
| `replicaCount`                            | # of NATS streaming servers                      | 2                                                 |
| `image.tag`                               | Container image version                          | 0.6.0                                             |
| `image.pullPolicy`                        | Image pull policy                                | IfNotLatest                                       |
| `clusterID`                               | ID for active and backups                        | "test-cluster"                                    |
| `natsUrl`                                 | External NATS Server URL                         | "nats://username:password@nats-service:4222"      |
| `ftGroup`                                 | Name of the fault tolerant group                 | "ft-(specified cluster id)"                       |
| `maxChannels`                             | Max # of channels                                | 100                                               |
| `maxSubs`                                 | Max # of subscriptions per channel               | 1000                                              |
| `maxMsgs`                                 | Max # of messages per channel                    | "1000000"                                         |
| `maxBytes`                                | Max messages total size per channel              | 900mb                                             |
| `maxAge`                                  | Max duration a message can be stored             | "0s" (unlimited)                                  |
| `maxMsgs`                                 | Max # of messages per channel                    | 1000000                                           |
| `maxMsgs`                                 | Max # of messages per channel                    | 1000000                                           |
| `configFile`                              | Configuration File                               | "" (Requires a PVC with a configuration file)     |
| `hbInterval`                              | Interval server sends hbs to clients             | "30s"                                             |
| `hbTimeout`                               | Duration to wait for a hb response               | "10s"                                             |
| `ackSubs`                                 | Internal subscription count for acks             | 0 (one per client)                                |
| `debug`                                   | Enable debugging                                 | false                                             |
| `trace`                                   | Enable detailed tracing                          | false  (avoid using this)                         |
| `service.type`                            | ClusterIP, NodePort, LoadBalancer                | ClusterIP                                         |
| `service.monitorPort`                     | Port to accept monitor requests                  | 8222                                              |
| `resources`                               | Server resource requests and limits              | none set                                          |
| `persistent.enabled`                      | Create a volume to store data                    | true (false is used with memory mode)             |
| `persistent.size`                         | Size of persistent volume claim                  | 1Gi RW                                            |
| `persistent.storageClass`                 | Type of persistent volume claim                  | `nil` (uses alpha storage class annotation)       |
| `persistent.accessMode`                   | ReadWriteOnce                                    | [ReadWriteOnce]                                   |
| `persistent.selector`                     | Selection criteria to select a persistent volume | `nil`                                             |

## Examples
### AWS EFS
https://aws.amazon.com/efs/

NATS Streaming can run in a Kubernetes cluster using a NFS persistent volume backed by Amazons EFS service.

#### Create an EFS File System
Create a new EFS File system in the AWS console; make sure that you create it in the same VPC and subnet(s) as your K8s nodes and that the security groups used will grant your K8s nodes access.

Once the EFS is available make a note of the DNS name from the AWS console; you'll need it to tell K8s where to connect to.

#### Create a Persistent Volume
You now need to create a NFS Persistent Volume in K8s pointed at your new EFS.

Save the YAML below as *persistentVolume.yaml* substituting in the DNS name of your EFS endpooint from the previous step and then create the Persistent Volume in your cluster with the command `kubectl apply -f persistentVolume.yaml`.

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nats-pv
  labels:
    name: nats-pv
    app: nats
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteMany
  mountOptions:
    - nfsvers=4.1
    - rsize=1048576
    - wsize=1048576
    - hard
    - timeo=600
    - retrans=2
  nfs:
    path: "/"
    server: ${DNS NAME GOES HERE}

``` 

#### NATS Streaming Configuration

Create or edit the values.yaml for your NATS Streaming chart setting the persistence section as it appears below; this will mount the Persistent Volume that you have just created as the NATS data folder.

```yaml
persistence:
  enabled: true
  storageClass: "-"
  accessMode: ReadWriteMany
  size: 5Gi
  selector:
    matchLabels:
      name: "nats-pv"
      app: "nats"
```

Continue to configure and deploy NATS as documented in the rest of this readme.
