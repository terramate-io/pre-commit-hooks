<p align="center">
  <picture width="160px" align="center">
      <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/terramate-io/brand/5a799813d429116741243b9b06a9f034a3991bf3/darkmode/stamp.svg">
      <img alt="Terramate" src="https://raw.githubusercontent.com/terramate-io/brand/5a799813d429116741243b9b06a9f034a3991bf3/whitemode/stamp.svg" width="160px" align="center">
    </picture>
  <h1 align="center">Terramate</h1>
</p>
<br/>

[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/terramate-io/pre-commit-hooks.svg?label=latest&sort=semver)](https://github.com/terramate-io/pre-commit-hooks/releases)
[![license](https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg)](https://opensource.org/licenses/Apache-2.0)
[![Terraform Version](https://img.shields.io/badge/terraform-~%3E%200.12.20-623CE4.svg)](https://github.com/hashicorp/terraform/releases)
[<img src="https://img.shields.io/discord/1088753599951151154?label=Discord&logo=discord&logoColor=white">](https://terramate.io/discord)

# pre-commit-hooks

This repository is a collection of Git hooks to be used with the
[pre-commit](https://pre-commit.com/) framework.

- [Available Hooks](#available-hooks)
  - [Terraform](#terraform)
  - [Go](#go)
  - [GNU Make](#gnu-make)
  - [Markdown](#markdown)
  - [Bash](#bash)
- [Installation & Dependencies](#installation--dependencies)
- [Usage](#usage)
  - [Run](#run)
    - [Example: Run All Hooks](#example-run-all-hooks)
    - [Example: Run A Specific Hook](#example-run-a-specific-hook)
  - [Pre-Commit and Continuous Integration](#pre-commit-and-continuous-integration)
  - [Add Custom Hooks](#add-custom-hooks)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Terramate](#about-terramate)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Available Hooks

Currently, the following hooks are supported:

### Terraform

- [terraform-fmt](https://www.terraform.io/docs/commands/fmt.html): The terraform fmt command is used to rewrite
  Terraform configuration `*.tf` files to a canonical format and style.
- [terraform-validate](https://www.terraform.io/docs/commands/validate.html): The terraform validate command validates
  all Terraform configuration `*.tf` files, referring only to the configuration and not accessing any remote services
  such as remote state, provider APIs, etc.
- [tflint](https://github.com/terraform-linters/tflint): TFLint is a Terraform linter focused on possible errors, best
  practices, etc. (Terraform >= 0.12). Applied to all Terraform configuration `*.tf` files.

### Go

- [golangci-lint](https://github.com/golangci/golangci-lint): GolangCI-Lint is a linters aggregator.
  It's fast: on average 5 times faster than gometalinter. It's easy to integrate and use, has nice output and has a
  minimum number of false positives. An example configuration can be found in
  [.golangci.example.yml](https://github.com/terramate-io/pre-commit-hooks/blob/master/.golangci.example.yml).

#### The following hooks can be configured through golangci-lint and are therefore redundant when golangci-lint is being used

- [gofmt](https://golang.org/cmd/gofmt/): Go fmt is a tool that automatically formats Go `*.go` files to canonical
  format and style.
- [goimports](https://godoc.org/golang.org/x/tools/cmd/goimports): The goimports command updates import lines in Go
  `*.go` files, adding missing ones and removing unreferenced ones.

### GNU Make

- [phony-targets](https://github.com/terramate-io/pre-commit-hooks/blob/master/pre_commit_hooks/make/phony-targets.sh):
  This hook validates if targets that are marked as `PHONY` actually exist.

### Markdown

- [markdown-link-check](https://github.com/tcort/markdown-link-check): Validates that all hyperlinks in a markdown
  text alive or dead.

### Bash

- [shellcheck](https://github.com/koalaman/shellcheck): ShellCheck is a GPLv3 tool that gives warnings and suggestions
  for bash/sh shell scripts.

### Terradoc

- [terradoc-fmt](https://github.com/mineiros-io/terradoc): The terradoc fmt command is used to rewrite Terradoc
    configuration configuration `*.tfdoc.hcl` files to a canonical format and
    style.
- [terradoc-generate](https://github.com/mineiros-io/terradoc): The terradoc generate command generates a markdown document
    from Terradoc configuration `*.tfdoc.hcl` files.
- [terradoc-validate](https://github.com/mineiros-io/terradoc): The terradoc validate command is used validate Terradoc
    configuration in `README.tfdoc.hcl` file against Terraform variable
    definitions.

### Terramate

- [terramate-fmt](https://github.com/terramate-io/terramate): The terramate generate command formats code in Terramate configuration files.
- [terramate-generate](https://github.com/terramate-io/terramate): The terramate generate command generates code from Terramate configuration files.

## Installation & Dependencies

1. Install [pre-commit](https://pre-commit.com/). E.g. `brew install pre-commit`
1. Install [Terraform](https://www.terraform.io/), [TFLint](https://github.com/terraform-linters/tflint),
   [Go](https://golang.org/), [markdown-link-check](https://github.com/tcort/markdown-link-check),
   [shellcheck](https://github.com/koalaman/shellcheck). E.g

   ```shell script
     brew install terraform \
         tflint \
         go \
         golangci/tap/golangci-lint \
         shellcheck && \
         npm install -g markdown-link-check && \
         go install github.com/mineiros-io/terradoc/cmd/terradoc@latest
   ```

## Usage

Create a `.pre-commit-config.yaml` inside your repositories and add the desired list of hooks.
Please see the [documentation](https://pre-commit.com/#usage) for further information.

```yaml
repos:
  - repo: https://github.com/terramate-io/pre-commit-hooks
    rev: <VERSION> # Check for the latest version: https://github.com/terramate-io/pre-commit-hooks/releases
    hooks:
      - id: terraform-fmt
      - id: terraform-validate
      - id: tflint
      - id: golangci-lint
      - id: phony-targets
      - id: markdown-link-check
        args: [-p] # When adding the -p flag, markdown-link-check will always with an exit code 0, even if dead links are found
      - id: shellcheck
      - id: terradoc-validate
      - id: terradoc-fmt
      - id: terradoc-generate
      - id: terramate-generate

      # The following hooks are redundant when golangci-lint is being. Our recommendation is to use golangci-lint
      # as the main linter for go since it enables you to run all available linters in parallel.
      # For details please see the example configuration https://github.com/terramate-io/pre-commit-hooks/blob/master/.golangci.example.yml
      # - id: gofmt
      # - id: goimports
```

Once you created the configuration file inside your repository, you must run `pre-commit install` to activate the hooks.
That's it, pre-commit will now listen for changes in your files and run the checks accordingly.

### Run

It's usually a good idea to run the hooks against all of the files when adding new hooks (usually pre-commit will only
run on the changed files during git hooks).

#### Example: Run All Hooks

```shell script
pre-commit run --all-files
```

#### Example: Run A Specific Hook

```shell script
pre-commit run terraform-validate --all-files
```

### Pre-Commit and Continuous Integration

It's recommended to run pre-commit as part of CI pipeline/build as there will be always that one rebel in the team
who won't run them locally. On CI, replace `pre-commit install` by `pre-commit run -a`. We don't need to install it on
CI as it'll be a one-shot operation. run -a will run the hooks over all files (taking into account excludes if
configured).

### Add Custom Hooks

All `*.sh` files inside pre_commit_hooks need to be flagged as executable. Otherwise the pre-commit hooks won't be
executable by default. You apply the flag to all `*.sh` files with the following command:

```bash
find pre_commit_hooks/ -type f -iname "*.sh" -exec chmod +x {} \;
```

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)](https://semver.org/).

Using the given version number of `MAJOR.MINOR.PATCH`, we apply the following constructs:

1. Use the `MAJOR` version for incompatible changes.
1. Use the `MINOR` version when adding functionality in a backwards compatible manner.
1. Use the `PATCH` version when introducing backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- In the context of initial development, backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is
  increased. (Initial development)
- In the context of pre-release, backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is
  increased. (Pre-release)

## About Terramate

Terramate CLI is an open-source orchestration and code generation engine that allows Infrastructure as Code (IaC) such
as Terraform, OpenTofu, Terragrunt and Kubernetes to scale.

Terramate CLI can optionally be paired with [Terramate Cloud](https://terramate.io), a fully managed SaaS service that
adds additional features to manage and observe all your infrastructure managed with IaC in one or multiple repositories.

With Terramate, you can:

1. Break up large, monolithic state files into multiple smaller stacks to limit blast radius, reduce runtimes and unlock better collaboration.
2. Reduce code duplication by programmatically generating native Terraform backend and provider configurations or any other arbitrary files using the Terramate compiler.
3. Using a graph-based orchestration engine, orchestrate any command such as `terraform apply` in stacks. Only deploy stacks that contain changes using change detection built on top of Git.
4. Automate your IaC using pull requests and GitOps workflows that turn your existing CI/CD, such as GitHub Actions, GitLab CI/CD, BitBucket Pipelines, Azure DevOps, etc, into infrastructure vending machines.
5. Use Terramate Cloud to add observability, drift detection, asset management, misconfiguration detection, incident management, developer self-service with scaffolding, and Slack notifications.

## Reporting Issues

We use GitHub [Issues](https://github.com/terramate-io/pre-commit-hooks/issues)
to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests](https://github.com/terramate-io/pre-commit-hooks/pulls). If you'd like more information, please
see our [Contribution Guidelines](https://github.com/terramate-io/pre-commit-hooks/blob/master/CONTRIBUTING.md).

## Makefile Targets

This repository comes with a handy
[Makefile](https://github.com/terramate-io/pre-commit-hooks/blob/master/Makefile).
Run `make help` to see details on each available target.

## License

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](https://github.com/terramate-io/pre-commit-hooks/blob/master/LICENSE) for full details.

Copyright &copy; 2025 Terramate GmbH
