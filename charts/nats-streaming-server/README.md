# NATS Streaming Server Helm Chart

Installs a [NATS](http://nats.io/) streaming server for use with NATS clients.

## TL;DR;

```console
$ helm install nats-server
```

**NOTE:**  Sometimes the initial pod creation fails due to timing with it's dependencies (Core NATS or the PVC).  This is a known issue,
Kubernetes will restart the pods and you'll be good to go in a few seconds if this happens.

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release nats-server
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

| Parameter                                 | Description                         | Default                                           |
|-------------------------------------------|-------------------------------------|---------------------------------------------------|
| `replicaCount`                            | # of NATS streaming servers         | 2                                                 |
| `image.tag`                               | Container image version             | 0.6.0                                             |
| `image.pullPolicy`                        | Image pull policy                   | IfNotLatest                                       |
| `clusterID`                               | ID for active and backups           | "test-cluster"                                    |
| `natsUrl`                                 | External NATS Server URL            | "nats://username:password@nats-service:4222"      |
| `ftGroup`                                 | Name of the fault tolerant group    | "ft-(specified cluster id)"                       |
| `maxChannels`                             | Max # of channels                   | 100                                               |
| `maxSubs`                                 | Max # of subscriptions per channel  | 1000                                              |
| `maxMsgs`                                 | Max # of messages per channel       | "1000000"                                         |
| `maxBytes`                                | Max messages total size per channel | 900mb                                             |
| `maxAge`                                  | Max duration a message can be stored| "0s" (unlimited)                                  |
| `maxMsgs`                                 | Max # of messages per channel       | 1000000                                           |
| `maxMsgs`                                 | Max # of messages per channel       | 1000000                                           |
| `configFile`                              | Configuration File                  | "" (Requires a PVC with a configuration file)     |
| `hbInterval`                              | Interval server sends hbs to clients| "30s"                                             |
| `hbTimeout`                               | Duration to wait for a hb response  | "10s"                                             |
| `ackSubs`                                 | Internal subscription count for acks| 0 (one per client)                                |
| `debug`                                   | Enable debugging                    | false                                             |
| `trace`                                   | Enable detailed tracing             | false  (avoid using this)                         |
| `service.type`                            | ClusterIP, NodePort, LoadBalancer   | ClusterIP                                         |
| `service.monitorPort`                     | Port to accept monitor requests     | 8222                                              |
| `resources`                               | Server resource requests and limits | none set                                          |
| `persistentVolume.enabled`                | Create a volume to store data       | true (false is used with memory mode)             |
| `persistentVolume.size`                   | Size of persistent volume claim     | 1Gi RW                                            |
| `persistentVolume.storageClass`           | Type of persistent volume claim     | `nil` (uses alpha storage class annotation)       |
| `persistentVolume.accessMode`             | ReadWriteOnce                       | [ReadWriteOnce]                                   |
