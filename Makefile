#!/usr/bin/make

PKG := github.com/omise/omise-go

GO    := go
GODOC := godoc

default: test
.PHONY: %

gen:
	@$(GO) build -v . ./operations
	@$(GO) get -v \
		./internal/generator \
		github.com/jteeuwen/go-bindata/go-bindata
	@$(GOPATH)/bin/generator
	@$(GOPATH)/bin/go-bindata -nometadata \
		-o internal/creds/bindata.go \
		-pkg creds \
		-prefix internal/creds/ \
		-ignore ".+\.go" \
		internal/creds/
	@$(MAKE) fmt

fmt:
	@echo go fmt:
	@go fmt ./...
	@echo goimports:
	@goimports -l -w .


deps:
	@$(GO) get -v -u ./...
test-deps:
	@$(GO) get -t -v -u ./...

test: test-deps
	@$(GO) test -v ./...
network-test: test-deps
	NETWORK=1 @$(GO) test -v ./...

doc:
	@echo starting godoc on port 9090
	@echo package doc is at http://0.0.0.0:9090/pkg/github.com/omise/omise-go/
	@$(GODOC) -v -http=":9090"

