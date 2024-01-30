.PHONY: all install local
SHELL := bash

TENANTS = nav ssb tenant

all: install local

install:
	poetry install

local:
	poetry run mkdocs serve

build:
	for TENANT in $(TENANTS); do \
		TENANT=$$TENANT poetry run mkdocs build -d out/$$TENANT; \
		done
	
