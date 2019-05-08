FROM golang:1.12.5

RUN go get github.com/alecthomas/gometalinter
RUN go get github.com/kardianos/govendor
RUN go get github.com/HewlettPackard/gas
RUN gometalinter --install 

