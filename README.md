# pre product infrastructure

Contains the the product infrastructure components per Environment for pre

- Resource Group



## Tooling

All infrastructure is created via Terraform, using reusable modules.

They are discovered by using [GitHub search](https://github.com/hmcts/?q=cnp-module&type=&language=).

## Getting started

You will likely want to install terraform,

We recommend using [tfenv](https://github.com/tfutils/tfenv), as it will manage the terraform version and ensures you use the same version locally and on our build server.

The terraform version is managed by `.terraform-version` file in the root of the repo, you can update this whenever you want.

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
4. Check the terraform plan from the build link that will be posted on your PR
5. Get someone else to review your PR
6. Merge the PR
7. It will automatically be deployed to AAT and Prod environments
8. Once successful in AAT and Prod then merge your change to demo, ithc, and perftest branches.

## LICENSE

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.i

test
