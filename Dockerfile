# Build go
FROM golang:1.24.1-alpine AS builder
WORKDIR /app
COPY . .
ENV CGO_ENABLED=0
RUN go mod download
RUN go build -v -o VB -tags "sing xray hysteria2 with_quic with_grpc with_utls with_wireguard with_acme with_gvisor"

# Release
FROM  alpine
# 安装必要的工具包
RUN  apk --update --no-cache add tzdata ca-certificates \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN mkdir /etc/VB/
COPY --from=builder /app/VB /usr/local/bin

ENTRYPOINT [ "VB", "server", "--config", "/etc/VB/config.json"]
