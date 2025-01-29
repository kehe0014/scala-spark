#!/bin/bash

# Script to automate setting up and running the NBA data processing pipeline

# 1. Clean Up Existing Containers (if any)
# ------------------------------------------
# This step ensures a clean slate by stopping and removing any previously running
# MySQL containers managed by docker-compose. The `-v` flag removes volumes associated
# with the containers, and `--remove-orphans` removes any dangling networks.

DOCKER_COMPOSE_FILE="docker-compose-mysql.yml"  # Path to the docker-compose file
DOCKER_COMPOSE_CMD="docker compose" 
ENV_FILE=".env"                                  # Path to the environment variable file

echo "Cleaning up existing MySQL containers..."
$DOCKER_COMPOSE_CMD -f "$DOCKER_COMPOSE_FILE" --env-file "$ENV_FILE" down -v --remove-orphans

# 2. Start MySQL Container
# ----------------------------
# This step starts the MySQL container using the specified docker-compose file
# and environment variables. The container will run in detached mode (`-d`)

echo "Starting MySQL container..."
$DOCKER_COMPOSE_CMD -f "$DOCKER_COMPOSE_FILE" --env-file "$ENV_FILE" up -d
#if ! $DOCKER_COMPOSE_CMD ps --filter status=running | grep -q mysql; then
  #echo "Error: MySQL container failed to start."
  #exit 1
#fi
docker ps
echo "Starting MySQL container succed ..."

# 3. Build the Application (sbt commands) with Apache Spark and Scala
# --------------------------------------------------------------
# Executes the sbt commands to clean, compile, and assemble the project.

sbt clean compile assembly
echo "Building the application..."  # Print message unconditionally
if [ $? -eq 0 ]; then
  echo "Building the application succed..."
else
  echo "Building the application failed."
  exit 1  # Exit script on failure
fi
# 4. Run Spark Job
# ------------------
# This step submits the Spark job using the spark-submit command. The classpath
# should point to the assembled JAR file generated in the previous step.

SPARK_CLASS="com.tdk.dst.spark.scala.Extract"  
JAR_FILE="target/scala-2.12/NBA-assembly-1.0.jar"
if [ ! -f "$JAR_FILE" ]; then
  echo "Error: JAR file not found: $JAR_FILE"
  exit 1
else
  echo "JAR file found: $JAR_FILE"
fi

echo "Submitting Spark job..."
spark-submit --class "$SPARK_CLASS" "$JAR_FILE"
if [ $? -eq 0 ]; then
  echo "Spark job succed..."
else
  echo "Spark job submission failed."
  exit 1  # Exit the script if spark-submit failed
fi
