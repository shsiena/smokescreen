FROM golang:1.18 AS builder

WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /smokescreen .

FROM alpine:3.20

RUN apk add --no-cache ca-certificates
COPY --from=builder /smokescreen /usr/local/bin/smokescreen
COPY smokescreen.yaml /etc/smokescreen/smokescreen.yaml
COPY acl.yaml /etc/smokescreen/acl.yaml

EXPOSE 4750

ENTRYPOINT ["smokescreen", "--config-file", "/etc/smokescreen/smokescreen.yaml"]
