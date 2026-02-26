#!/bin/bash
# bash script to customize the template


if [ $# -ne 2 ]; then
read -p "Enter Data Model project name: " DMFullName
read -p "Enter Data Model vodml name: " DMVODMLName
else
  DMFullName=$1
  DMVODMLName=$2
fi

ClassName=`tr [:lower:] [:upper:] <<<${DMVODMLName:0:1}`${DMVODMLName:1}

echo "will use $DMFullName as the full project name and $DMVODMLName as the model name and class $ClassName"

read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1

perl -p -i -e 's/mymodel/'${DMVODMLName}'/g' vo-dml/* model/*
perl -p -i -e 's/TemplateDM/'${DMFullName}'/gi' doc/site/*.md build.gradle.kts settings.gradle.kts vo-dml/TemplateDM-v1.vodml-binding.xml
perl -p -i -e 's/Mymodel/'${ClassName}'/g' src/test/java/org/ivoa/dm/mymodel/MymodelModelTest.java
perl -p -i -e 's/mymodel/'${DMVODMLName}'/g' src/test/java/org/ivoa/dm/mymodel/MymodelModelTest.java
perl -p -i -e 's/DataModelTemplate/'${DMFullName}'/gi' mkdocs_template.yml
(cd vo-dml; mv TemplateDM-v1.vo-dml.xml ${DMFullName}-v1.vo-dml.xml; mv TemplateDM-v1.vodml-binding.xml ${DMFullName}-v1.vodml-binding.xml )
(cd src/test/java/org/ivoa/dm/; mv mymodel $DMVODMLName; cd $DMVODMLName; mv MymodelModelTest.java ${ClassName}ModelTest.java )
(cd model; mv TemplateDM-v1.vodsl ${DMFullName}-v1.vodsl)



cat > ReadMe.md << EOD
$DMFullName Project
===================

This project uses [VO-DML tools](https://ivoa.github.io/vo-dml/) to define a data model.

The source for the model is in [model/$DMFullName-v1.vodsl](model/$DMFullName-v1.vodsl)

\`\`\`
gradle test
\`\`\`
should build the model and run tests against it.
\`\`\`shell
gradle testSite
\`\`\`
should build the site and make it available at http://localhost:8000

EOD
