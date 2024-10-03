# Gradle build logic change frequency

This measures the frequency of changes to the Gradle build logic in the repository.
This is a good indicator of how often the build logic is updated and how often engineers need to run configuration and sync.

## How to run

```bash
$ git submodule update --init
$ cd gradle
$ ../stat.sh
```
