HADOOP_VERSION=3.3.6
build-base: ## build base image.
	docker build -t hadoop-hive-spark-base ./base
build-master: ## build master server image.
	docker build -t hadoop-hive-spark-master ./master
build-worker: ## build worker server image.
	docker build -t hadoop-hive-spark-worker ./worker
build-history: ## build history server image.
	docker build -t hadoop-hive-spark-history ./history
build-jupyter: ## build jupyter notebook image.
	docker build -t hadoop-hive-spark-jupyter ./jupyter
build-dev: ## build dev env.
	docker build -t hadoop-hive-spark-dev ./dev

start-cluster: ## start hadoop cluster.
	mkdir ./datanode1 ./datanote2 ./namenode
	docker-compose -f ./docker-compose-cluster.yml up -d
stop-cluster: ## stop hadoop cluster.
	docker-compose -f ./docker-compose-cluster.yml down
	rm -rf ./datanote1 ./datanote2 ./namenode

build-all: build-base build-master build-worker build-history build-jupyter build-dev ## build images.
build-cluster: build-base build-master build-worker build-history ## build images.

help: ## print help.
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
