FROM golang:1.10 AS builder

COPY . /go/src/github.com/thecodeteam/csi-scaleio
WORKDIR /go/src/github.com/thecodeteam/csi-scaleio
RUN X_CSI_SCALEIO_NO_PROBE_ON_START=true go test github.com/thecodeteam/csi-scaleio/service -test.v
RUN go build


FROM centos:7

RUN yum install -y module-init-tools libaio numactl e2fsprogs xfsprogs && yum clean all
COPY --from=builder /go/src/github.com/thecodeteam/csi-scaleio/csi-scaleio csi-scaleio

ENTRYPOINT ["/csi-scaleio"]
