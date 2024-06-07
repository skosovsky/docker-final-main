# docker build --tag parcels:v1 .

FROM golang:latest AS builder

WORKDIR /parcel
COPY go.mod ./
COPY *.go ./
RUN go mod download
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o parcel .

FROM alpine:latest

WORKDIR /parcel
COPY --from=builder /parcel/parcel .
COPY tracker.db ./

CMD ./parcel
