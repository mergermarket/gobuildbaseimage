FROM golang:1.7

RUN go get -u github.com/alecthomas/gometalinter.v1
RUN go get -u github.com/kardianos/govendor 
RUN go get github.com/alecthomas/gometalinter 
RUN go get github.com/HewlettPackard/gas
RUN gometalinter --install 

