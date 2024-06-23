# DNS Performance Testing with Kubernetes Pods

[![Docker Stars](https://img.shields.io/docker/stars/guessi/dnsperf.svg)](https://hub.docker.com/r/guessi/dnsperf/)
[![Docker Pulls](https://img.shields.io/docker/pulls/guessi/dnsperf.svg)](https://hub.docker.com/r/guessi/dnsperf/)
[![Docker Automated](https://img.shields.io/docker/automated/guessi/dnsperf.svg)](https://hub.docker.com/r/guessi/dnsperf/)


## Integrated Items

* DNSPerf 2.14.0

## Preflight checklist

### Does CoreDNS running expected version?

    $ kubectl get deployments coredns -n kube-system -o jsonpath='{$.spec.template.spec.containers[0].image}'

### Does CoreDNS running with expected Corefile?

    $ kubectl get configmap coredns -n kube-system -o jsonpath='{$.data.Corefile}'

### Does CoreDNS running with correct resources configuration?

    $ kubectl get deployments coredns -n kube-system -o jsonpath='{$.spec.template.spec.containers[0].resources}'

## Benchmark with Kubernetes Pods

### Apply pre-configured testing deployment/pods

    $ kubectl apply -f https://raw.githubusercontent.com/guessi/dnsperf-bench/master/k8s-dnsperf-bench.yaml
    configmap/dns-records-config created
    deployment.apps/dnsperf created

### Find out your Kubernetes DNS service IP address

    $ kubectl get service kube-dns -n kube-system -o jsonpath='{$.spec.clusterIP}'

### If your DNS service address is not "10.100.0.10", you will need to change the value of predefined "DNS_SERVER_ADDR"

    $ kubectl edit deployment dnsperf

### Make sure the deployment is running as expected

    $ kubectl get deploy dnsperf

    NAME      READY   UP-TO-DATE   AVAILABLE   AGE
    dnsperf   1/1     1            1           81s

    $ kubectl get pods -l app=dnsperf

    NAME                       READY   STATUS    RESTARTS   AGE
    dnsperf-7b9cc5b497-d5nfs   1/1     Running   0          1m16s

### To check benchmark results

    $ kubectl logs -f deployments/dnsperf

    DNS Performance Testing Tool
    Version 2.14.0

    [Status] Command line: dnsperf -f any -m udp -s 10.100.0.10 -p 53 -d /opt/records.txt -c 1 -T 1 -l 30 -t 5 -Q 100000
    [Status] Sending queries (to 10.100.0.10:53)
    [Status] Started at: Thu Apr 11 16:47:46 2024
    [Status] Stopping after 30.000000 seconds
    [Status] Testing complete (time limit)

    Statistics:

      Queries sent:         517317
      Queries completed:    517317 (100.00%)
      Queries lost:         0 (0.00%)

      Response codes:       NOERROR 517317 (100.00%)
      Average packet size:  request 43, response 160
      Run time (s):         30.004152
      Queries per second:   17241.513774

      Average Latency (s):  0.004805 (min 0.000101, max 0.029327)
      Latency StdDev (s):   0.002537


### Check resources utilization of the CoreDNS deployment

    $ kubectl top pods -n kube-system -l k8s-app=kube-dns

    NAME                       CPU(cores)   MEMORY(bytes)
    coredns-79989457d9-fn2hc   1644m        15Mi
    coredns-79989457d9-xss5l   925m         16Mi

## Stress Test

### You may gain more replicas to stress your CoreDNS even harder

    $ kubectl scale deployments/dnsperf --replicas 4

    deployment.apps/dnsperf scaled

### After gaining workload, you should find it's CPU utilization even higher

    $ kubectl top pods -n kube-system -l k8s-app=kube-dns

    NAME                       CPU(cores)   MEMORY(bytes)
    coredns-79989457d9-fn2hc   1839m        17Mi
    coredns-79989457d9-xss5l   1344m        16Mi

> If you try to gain too much stress without tuning CoreDNS configureation (e.g. CPU, Memory, Replicas of CoreDNS), you should find some TIMEOUT, packet losts. That's expected... don't report it as bug! you should give CoreDNS more resources to handle that stress.

## Reference

- https://www.dnsperf.com/
