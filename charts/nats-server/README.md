# NATS Server Helm Chart

Installs a [NATS](http://nats.io/) server cluster for use with NATS clients.

## TL;DR;

```console
$ helm install nats-server
```

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install --name my-release nats-server
```

## Uninstalling the Chart

To uninstall/delete the my-release deployment:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## NATS server clusters

This chart installs a cluster of **three** NATS servers, sufficent for large scale deployments.  As the NATS server deployment is scaled, servers will automatically cluster.  This means that if you need independent, standalone servers, you'll need to install this chart once for each server.

Applications can connect using a NATS url composed like this:

`nats://<username>:<password>@<service name><client port>`

The default is:

`nats://username:password@nats-service:4222`

Is is *HIGHLY* recommended you change the username and password.  A [bcrypted](https://github.com/nats-io/gnatsd#bcrypt) password is recommended.

### Resources

In choosing resources, NATS is fairly lightweight, but a large number of subscribers and connections can consume memory.  If TLS is enabled, and/or bcrytped passwords are used, you'll want more CPU.


## Configuration

| Parameter                                 | Description                         | Default                                           |
|-------------------------------------------|-------------------------------------|---------------------------------------------------|
| `replicaCount`                            | # of NATS servers to cluster        | 3                                                 |
| `image.tag`                               | Container image version             | latest                                            |
| `image.pullPolicy`                        | Image pull policy                   | IfNotLatest                                       |
| `username`                                | User required for connections       | "username"                                        |
| `password`                                | Password required for connections   | "password"                                        |
| `debug`                                   | Enable debugging                    | false                                             |
| `trace`                                   | Enable detailed tracing             | false  (avoid using this)                         |
| `service.name`                            | Service name                        | nats-service                                      |
| `service.type`                            | ClusterIP, NodePort, LoadBalancer   | ClusterIP                                         |
| `service.clientPort`                      | Port to accept client connections   | 4222                                              |
| `service.monitorPort`                     | Port to accept monitor requests     | 8222                                              |
| `service.clusterPort`                     | Port to accept cluster routes       | 6222                                              |
| `resources`                               | Server resource requests and limits | none set                                          |
