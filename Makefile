EXAMPLES = examples

.PHONY: format formatted all go-clean pkg-build-install test vet check \
        example-scheduler example-executor clean

all: go-clean pkg-build-install examples

clean: go-clean
	rm -f ${EXAMPLES}/example-scheduler ${EXAMPLES}/example-executor 

go-clean:
	go clean

pkg-build-install:
	go install -v ./...

examples: example-scheduler example-executor

example-scheduler:
	rm -rf ${EXAMPLES}/$@
	go build -race -o ${EXAMPLES}/$@ ${EXAMPLES}/example_scheduler.go

example-executor:
	rm -rf ${EXAMPLES}/$@
	go build -race -o ${EXAMPLES}/$@ ${EXAMPLES}/example_executor.go

format:
	gofmt -s -w .

formatted:
	! gofmt -s -l . | grep -v -e ^Godeps/

vet:
	go vet ./...

test:
	go test -timeout 300s -race ./...

check: formatted vet test
