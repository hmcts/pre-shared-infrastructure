# pre product infrastructure

Contains the the product infrastructure components per Environment for pre

## Tooling

All infrastructure is created via Terraform, using reusable modules when appropriate.

## Getting started

You will likely want to install terraform,

We recommend using [tfenv](https://github.com/tfutils/tfenv), as it will manage the terraform version and ensures you use the same version locally and on our build server.

The terraform version is managed by `.terraform-version` files.

## Lint

Please run `terraform fmt` before submitting a pull request.

We've included a [pre-commit](https://pre-commit.com/) file to help with this.

Install it with:
```shell
$ brew install pre-commit
# or
$ pip3 install pre-commit
```

then run:
```command
$ pre-commit install
```

## Workflow

1. Make your changes locally
2. Format your change with `terraform fmt` or the pre-commit hook
3. Submit a pull request
4. Read the terraform plan
5. Run an apply on your branch against the sandbox environment to test the real-life outcome
6. Get someone else to review your PR
7. Merge the PR to master branch
8. Changes can be propagated to [each environment](https://hmcts.github.io/cloud-native-platform/environments/#environments) by running the pipeline, this should be done from lowest to highest

## LICENSE

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
