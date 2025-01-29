name := "NBA"

version := "1.0"

scalaVersion := "2.12.15"
val sparkVersion = "3.3.0" // Using Spark version 3.3.0

libraryDependencies ++= Seq(
  // Lihaoyi's libraries
  "com.lihaoyi" %% "requests" % "0.1.8",
  "com.lihaoyi" %% "ujson" % "0.7.1",
  "com.lihaoyi" %% "os-lib" % "0.9.1",

  // Spark dependencies (using Spark version 3.3.0)
  "org.apache.spark" %% "spark-core" % sparkVersion,
  "org.apache.spark" %% "spark-sql" % sparkVersion,

  // Hadoop dependencies
  "org.apache.hadoop" % "hadoop-client" % "3.3.2",
  "org.apache.hadoop" % "hadoop-common" % "3.3.2",
  "org.apache.hadoop" % "hadoop-mapreduce-client-core" % "3.3.2",
  "org.apache.hadoop" % "hadoop-client-api" % "3.3.2",

  // JSON
  "com.typesafe.play" %% "play-json" % "2.9.2",

  // Properties files
  "com.typesafe" % "config" % "1.4.2",

  // Postgresql driver
  "org.postgresql" % "postgresql" % "42.7.5",

  // MySQL Driver
  "mysql" % "mysql-connector-java" % "8.0.33",

  // Logging
  "org.slf4j" % "slf4j-api" % "1.7.36",
  "ch.qos.logback" % "logback-classic" % "1.2.11",

  // Testing
  "org.scalatest" %% "scalatest" % "3.2.17" % Test
)

dependencyOverrides ++= Seq(
  "org.typelevel" %% "cats-core" % "2.10.0"
)


assembly / assemblyMergeStrategy := {
  case PathList("META-INF", xs @ _*) => MergeStrategy.discard
  case _ => MergeStrategy.first
}


