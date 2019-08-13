FROM golang as build

ENV GO111MODULE=on
WORKDIR /go/src/echo
COPY echo.go .
RUN go mod init
RUN CGO_ENABLED=0  go build echo.go

FROM scratch as run

ARG PORT=1337
ENV PORT=${PORT}
COPY --from=build /go/src/echo/echo /
EXPOSE ${PORT}

ENTRYPOINT ["/echo"]
