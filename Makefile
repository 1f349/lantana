SHELL := /bin/bash
PRODUCT_NAME := lantana
BIN := dist/${PRODUCT_NAME}
DNAME := ${PRODUCT_NAME}_
ENTRY_POINT := ./cmd/${PRODUCT_NAME}
HASH := $(shell git rev-parse --short HEAD)
COMMIT_DATE := $(shell git show -s --format=%ci ${HASH})
BUILD_DATE := $(shell date '+%Y-%m-%d %H:%M:%S')
VERSION := ${HASH}
LD_FLAGS := -s -w -X 'main.buildVersion=${VERSION}' -X 'main.buildDate=${BUILD_DATE}' -X 'main.buildName=${PRODUCT_NAME}'
COMP_BIN := go

ifeq ($(OS),Windows_NT)
	BIN := $(BIN).exe
	DNAME := $(DNAME).exe
endif

.PHONY: build dev test clean deploy d setup s generate

build:
	mkdir -p dist/
	${COMP_BIN} build -o "${BIN}" -ldflags="${LD_FLAGS}" ${ENTRY_POINT}

dev: build
	./${BIN} daemon -config .data/main.yaml -debug

test:
	${COMP_BIN} test -v ./...

clean:
	${COMP_BIN} clean
	rm -r -f dist/

generate: build
	mkdir -p .data
	sudo ./${BIN} generate -config .data/main.yaml

setup:
	sudo cp "${PRODUCT_NAME}.service" /etc/systemd/system
	sudo mkdir -p "/etc/${PRODUCT_NAME}/.data"
	sudo mkdir -p "/etc/${PRODUCT_NAME}/schema/mail"
	sudo mkdir -p "/etc/${PRODUCT_NAME}/schema/token"
	sudo cp -rf "database/schemas/." "/etc/${PRODUCT_NAME}/schema/mail"
	sudo cp -rf "database_token/schemas/." "/etc/${PRODUCT_NAME}/schema/token"
	sudo systemctl daemon-reload

s:
	sudo cp "${DNAME}.service" /etc/systemd/system
	sudo mkdir -p "/etc/${DNAME}/.data"
	sudo mkdir -p "/etc/${DNAME}/schema/mail"
	sudo mkdir -p "/etc/${DNAME}/schema/token"
	sudo cp -rf "database/schemas/." "/etc/${DNAME}/schema/mail"
	sudo cp -rf "database_token/schemas/." "/etc/${DNAME}/schema/token"
	sudo systemctl daemon-reload

deploy: build
	sudo systemctl stop "${PRODUCT_NAME}"
	sudo cp "${BIN}" /usr/local/bin
	sudo systemctl start "${PRODUCT_NAME}"

d: build
	sudo systemctl stop "${DNAME}"
	sudo cp "${BIN}" "/usr/local/bin/${DNAME}"
	sudo systemctl start "${DNAME}"
