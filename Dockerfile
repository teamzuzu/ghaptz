# syntax=docker/dockerfile:1
FROM golang:1.22-alpine AS build
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /out/ghaptz ./cmd/ghaptz

FROM gcr.io/distroless/static-debian12
COPY --from=build /out/ghaptz /ghaptz
EXPOSE 8080
ENTRYPOINT ["/ghaptz"]
CMD ["-config", "/data/config.yaml"]
