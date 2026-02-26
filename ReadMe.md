Template Data Model Project
===========================

This is a template project for creating a new Data Model using
[vodml tools](https://github.com/ivoa/vo-dml).

Steps to use it
---------------
1. decide on your DM name!
2. copy the repository (in github it can be used as a template on creation)
3. decide on  model name then run (note that the project name is whatever you called the github project)
```shell
./setup.sh
```
4. check that the build works with
```shell
gradle test
```

If that goes wrong it should be possible to get back to the original with

```shell
rm -fr model/* vo-dml/* src/test/java/* ;git restore doc/site/*.md vo-dml/ model/ build.gradle.kts settings.gradle.kts src/test/java/org/ivoa/dm/mymodel/MymodelModelTest.java ReadMe.md mkdocs_template.yml
```

