# Dockerized DNS Performance Testing Tool

[![Docker Stars](https://img.shields.io/docker/stars/guessi/dnsperf.svg)](https://hub.docker.com/r/guessi/dnsperf/)
[![Docker Pulls](https://img.shields.io/docker/pulls/guessi/dnsperf.svg)](https://hub.docker.com/r/guessi/dnsperf/)
[![Docker Automated](https://img.shields.io/docker/automated/guessi/dnsperf.svg)](https://hub.docker.com/r/guessi/dnsperf/)


## Integrated Items

* DNSPerf 2.1.0.0-1


## Usage

To run dnsperf with default settings, use the command below:

    $ docker run -it guessi/dnsperf:2-alpine

Or run dnsperf with customized settings:

    $ docker run                              \
        -e MAX_TEST_SECONDS=60                \
        -e DNS_SERVER_ADDR=8.8.8.8            \
        -e MAX_QPS=1000                       \
        -it guessi/dnsperf:2-alpine

Or run dnsperf with customized testing data:

    $ docker run                              \
        -v /path/to/files:/opt/records.txt:ro \
        -e MAX_TEST_SECONDS=60                \
        -e DNS_SERVER_ADDR=8.8.8.8            \
        -e MAX_QPS=1000                       \
        -it guessi/dnsperf:2-alpine


## Benchmark inside Kubernetes system

apply pre-configured testing deployment/pods

    $ kubectl apply -f ./bench/k8s-dnsperf-bench.yaml
    configmap "dns-records-config" unchanged
    deployment.apps "dnsperf-deployment" configured

make sure the deployment is running as expected

    $ kubectl get deploy dnsperf-deployment
    NAME                 DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
    dnsperf-deployment   5         5         5             5          2m

find out the pod name

    $ kubectl get po -l app=dnsperf
    NAME                                 READY     STATUS      RESTARTS   AGE
    dnsperf-deployment-f9d5d86dd-7jg9c   1/1       Running     0          1m
    dnsperf-deployment-f9d5d86dd-chbmb   1/1       Running     0          1m
    dnsperf-deployment-f9d5d86dd-cs6sf   1/1       Running     0          1m
    dnsperf-deployment-f9d5d86dd-ctwtj   1/1       Running     0          1m
    dnsperf-deployment-f9d5d86dd-dnvt4   1/1       Running     0          1m

pick a pod for log output monitoring

    $ kubectl logs -f dnsperf-deployment-f9d5d86dd-7jg9c

wait for result output

    DNS Performance Testing Tool
    Nominum Version 2.1.0.0

    [Status] Command line: dnsperf -l 30 -s x.x.x.x -Q 100000 -d /opt/records.txt
    [Status] .............
    [Status] .............
    [Status] .............
    [Status] Testing complete (time limit)

    Statistics:

      Queries sent:         741442
      Queries completed:    741404 (99.99%)
      Queries lost:         38 (0.01%)

      Response codes:       NOERROR 741404 (100.00%)
      Average packet size:  request 39, response 130
      Run time (s):         30.002017
      Queries per second:   24711.805210

      Average Latency (s):  0.003736 (min 0.000159, max 0.012242)
      Latency StdDev (s):   0.000644


## FAQ

Why is the pods shown as "CrashLoopBackOff"?

    Pod will end its life once the `MAX_TEST_SECONDS` passed

Why is the pods restart interval so long?

    Please refer to the FAQ of [Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy)


## Reference

- https://www.dnsperf.com/
