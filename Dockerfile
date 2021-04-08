FROM golang:alpine AS build
WORKDIR /src
COPY . .
RUN go build -o /out/clickhouse-backup ./cmd/clickhouse-backup


FROM alpine AS bin
COPY --from=build /out/clickhouse-backup /

# #FROM scratch
# FROM alpine

#RUN adduser -D -g '' clickhouse
RUN apk update && apk add --no-cache ca-certificates tzdata && update-ca-certificates

COPY --from=build /out/clickhouse-backup /bin/clickhouse-backup
RUN chmod +x /bin/clickhouse-backup

#USER clickhouse

ENTRYPOINT [ "/bin/clickhouse-backup" ]
CMD [ "--help" ]
