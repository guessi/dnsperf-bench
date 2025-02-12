# DNS Performance Testing with Kubernetes Pods

[![Docker Stars](https://img.shields.io/docker/stars/guessi/dnsperf.svg)](https://hub.docker.com/r/guessi/dnsperf/)
[![Docker Pulls](https://img.shields.io/docker/pulls/guessi/dnsperf.svg)](https://hub.docker.com/r/guessi/dnsperf/)
[![Docker Automated](https://img.shields.io/docker/automated/guessi/dnsperf.svg)](https://hub.docker.com/r/guessi/dnsperf/)


## Integrated Items

* DNSPerf 2.14.0

## 🔥 Stress Test 🔥 Benchmark with Kubernetes Pods

Apply pre-configured testing deployment/pods

```bash
kubectl apply -f https://raw.githubusercontent.com/guessi/dnsperf-bench/main/k8s-dnsperf-bench.yaml
```

Make sure the deployment is running as expected


```bash
kubectl get pods -l app=dnsperf
NAME                       READY   STATUS    RESTARTS   AGE
dnsperf-7b9cc5b497-d5nfs   1/1     Running   0          1m16s
```

Check benchmark results

```bash
kubectl logs -f deployments/dnsperf
...
Statistics:
  ...
  Queries per second:   17241.513774
  ...
```

Even more stress 🔥🔥🔥

```bash
kubectl scale deployments/dnsperf --replicas 10
```

## 🤔 Evaluate why there would have performance issue

Does CoreDNS running expected version?

```bash
kubectl describe deployments coredns -n kube-system | grep 'Image:'
```

Does CoreDNS running with expected Corefile?

```bash
kubectl describe configmap coredns -n kube-system
```

Does CoreDNS running with correct resources configuration?

```bash
kubectl get deployments coredns -n kube-system -o json | jq -r '.spec.template.spec.containers[0].resources'
```

Does CoreDNS need more CPU/Memory resources?

```bash
kubectl top pods -n kube-system -l k8s-app=kube-dns
```

How many CoreDNS Pods running? Have you enabled CoreDNS AutoScaler?

```bash
kubectl get deployments coredns -n kube-system
```

> DO NOT report bug without trying to do performance tuning. If you try to gain too much stress without tuning CoreDNS configureation, it is expected to have some TIMEOUT or packet losts. It's expected if you don't change.

## 📑 Reference

- https://www.dnsperf.com/
