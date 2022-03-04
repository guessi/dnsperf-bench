# Dockerized DNS Performance Testing Tool

[![Docker Stars](https://img.shields.io/docker/stars/guessi/dnsperf.svg)](https://hub.docker.com/r/guessi/dnsperf/)
[![Docker Pulls](https://img.shields.io/docker/pulls/guessi/dnsperf.svg)](https://hub.docker.com/r/guessi/dnsperf/)
[![Docker Automated](https://img.shields.io/docker/automated/guessi/dnsperf.svg)](https://hub.docker.com/r/guessi/dnsperf/)


## Integrated Items

* DNSPerf 2.9.0


## Usage

To run dnsperf with default settings, use the command below:

    $ docker run -it guessi/dnsperf:alpine

Or run dnsperf with customized settings:

    $ docker run                              \
        -e MAX_TEST_SECONDS=60                \
        -e DNS_SERVER_ADDR=8.8.8.8            \
        -e MAX_QPS=1000                       \
        -it guessi/dnsperf:alpine

Or run dnsperf with customized testing data:

    $ docker run                              \
        -v /path/to/files:/opt/records.txt:ro \
        -e MAX_TEST_SECONDS=60                \
        -e DNS_SERVER_ADDR=8.8.8.8            \
        -e MAX_QPS=1000                       \
        -it guessi/dnsperf:alpine


## Benchmark inside Kubernetes system

apply pre-configured testing deployment/pods

    $ kubectl apply -f ./bench/k8s-dnsperf-bench.yaml
    configmap/dns-records-config created
    deployment.apps/dnsperf-deployment created

make sure the deployment is running as expected

    $ kubectl get deploy dnsperf-deployment
    NAME                 READY   UP-TO-DATE   AVAILABLE   AGE
    dnsperf-deployment   0/2     2            0           81s

find out the pod name

    $ kubectl get po -l app=dnsperf
    NAME                                  READY   STATUS    RESTARTS   AGE
    dnsperf-deployment-5c5f65fc55-59pvl   1/1     Running   0          21s
    dnsperf-deployment-5c5f65fc55-8bfhp   1/1     Running   0          21s

pick a pod for log output monitoring

    $ kubectl logs -f dnsperf-deployment-5c5f65fc55-59pvl

wait for result output

    DNS Performance Testing Tool
    Version 2.9.0

    [Status] Command line: dnsperf -l 60 -s 8.8.8.8 -Q 1000 -d /opt/records.txt
    [Status] Sending queries (to 8.8.8.8:53)
    [Status] Started at: Fri Mar  4 15:27:57 2022
    [Status] Stopping after 60.000000 seconds
    [Timeout] Query timed out: msg id 55720
    [Timeout] Query timed out: msg id 56643
    [Timeout] Query timed out: msg id 59821
    [Status] Testing complete (time limit)

    Statistics:

      Queries sent:         60000
      Queries completed:    59997 (100.00%)
      Queries lost:         3 (0.01%)

      Response codes:       NOERROR 59997 (100.00%)
      Average packet size:  request 32, response 50
      Run time (s):         60.003051
      Queries per second:   999.899155

      Average Latency (s):  0.007349 (min 0.002795, max 4154504685.515536)
      Latency StdDev (s):   0.023197


## FAQ

Why is the pods shown as "CrashLoopBackOff"?

    Pod will end its life once the `MAX_TEST_SECONDS` passed

Why is the pods restart interval so long?

    Please refer to the FAQ of [Pod Lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy)


## Reference

- https://www.dnsperf.com/
