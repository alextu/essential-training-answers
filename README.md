# Essential training answers

This project contains answers to the essential training exercices as simple REST calls.

## Prerequisites
If you want to benefit from the built-in gradle tasks.
- Java
- Docker

If you want to execute without Docker, you'll need the following tools :
- curl
- jd

## Start a fresh artifactory
Either roll your own instance or start a fresh one with the built-in task :

`./gradlew runCleanArtifactory`

## Run the snippets

- Run all the snippets :

`./gradlew runRestSnippets -PartUrl=http://172.16.61.131:8081/artifactory`

- Run only the scripts begining with 01 :

`./gradlew runRestSnippets -PartUrl=http://172.16.61.131:8081/artifactory -Ppart=01* `