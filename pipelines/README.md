# Pipelines

Pipelines are the YAMl files that define the continouis integration processess for the Luna mHealth project.

The four main pipelines are:

pipeline_build_luna.yml - The build pipelines. Runs at night if there was a commit in the main branch.

pipeline_luna_lint-test.yml - The pull request pipelines. Runs, due to a build policy, whenever a pull request is created.

pipeline_nightly_buid.yml - The nightly testing pipeline. This pipeline runs every night and runs the unit tests and end-to-end tests against Luna.

pipeline_run_unit_tests.yml - A pipeline that just runs the unit tests and lints Luna.

## Folder Contents

- **playground**: Contains the testing pipeline yaml. 
- **scripts**: Contains various script used by the pipelines such as python and PowerShell scripts. 
- **templates**: Templates are groups of tasked run by the pipeline. The templates folder contians the templates for the pipelines.


## Additional Documentation

More documentation on pipelines can be found here in the [ADO Build pipelines document](https://docs.google.com/document/d/14i34RJYrWRlDUDMFsVYQ8nDoLo9Qan4OrPh_OlAHvhg/edit?tab=t.0#heading=h.z3905hbxo73p)

