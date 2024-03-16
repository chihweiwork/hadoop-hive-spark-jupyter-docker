HADOOP_VERSION=3.3.6
SPARK_VERSION=3.4.2
HIVE_VERSION=3.1.3

HADOOP_URL=https://www.apache.org/dist/hadoop/common/hadoop-$(HADOOP_VERSION)/hadoop-$(HADOOP_VERSION).tar.gz
SPARK_URL=https://archive.apache.org/dist/spark/spark-$(SPARK_VERSION)/spark-$(SPARK_VERSION)-bin-hadoop3.tgz
HIVE_URL=https://archive.apache.org/dist/hive/hive-$(HIVE_VERSION)/apache-hive-$(HIVE_VERSION)-bin.tar.gz

DOWNLOAD_PATH=.

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

download-hadoop: ## download hadoop
	curl -fsSL $(HADOOP_URL) -o $(DOWNLOAD_PATH)/hadoop.tar.gz 
	curl -fsSL $(HADOOP_URL).asc -o $(DOWNLOAD_PATH)/hadoop.tar.gz.asc 

download-spark: ## download spark
	curl -fsSL $(SPARK_URL) -o $(DOWNLOAD_PATH)/spark.tgz
	curl -fsSL $(SPARK_URL).asc -o $(DOWNLOAD_PATH)/spark.tgz.asc
download-hive: ## download hive
	curl -fsSL $(HIVE_URL) -o $(DOWNLOAD_PATH)/hive.tar.gz
	curl -fsSL $(HIVE_URL).asc -o $(DOWNLOAD_PATH)/hive.tar.gz.asc

clean-download: ## clean all download data.
	rm -f $(DOWNLOAD_PATH)/hadoop.tar.gz $(DOWNLOAD_PATH)/hadoop.tar.gz.asc $(DOWNLOAD_PATH)/spark.tgz $(DOWNLOAD_PATH)/spark.tgz.asc $(DOWNLOAD_PATH)/hive.tar.gz $(DOWNLOAD_PATH)/hive.tar.gz.asc

start-cluster: ## start hadoop cluster.
	mkdir ./datanode1 ./datanote2 ./namenode
	docker-compose -f ./docker-compose-cluster.yml up -d
stop-cluster: ## stop hadoop cluster.
	docker-compose -f ./docker-compose-cluster.yml down
	rm -rf ./datanote1 ./datanote2 ./namenode

build-all: build-base build-master build-worker build-history build-jupyter build-dev ## build images.
build-cluster: build-base build-master build-worker build-history ## build images.

download: download-hadoop download-spark download-hive ## download hadoop spark hive

help: ## print help.
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
