# create-github-release

A composite action to automatically create a GitHub release using conventional commits to determine the version number.

## Usage

```yaml
name: Release

on:
  push:
    branches:
    - main

permissions:
  contents: write
  issues: write
  pull-requests: write

jobs:
  release:
    name: GitHub
    runs-on: ubuntu-24.04

    outputs:
      new-release-published: ${{ steps.release.outputs.new-release-published }}
      new-release-version: ${{ steps.release.outputs.new-release-version }}

    steps:
      - name: Checkout
        uses: actions/checkout@v6

      - name: Create a GitHub Release
        id: release
        uses: craigsloggett/create-github-release@v1
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
```

## Inputs

| Input                                                 | Required | Default  | Description                                                                                    |
| ----------------------------------------------------- | -------- | -------- | --------------------------------------------------------------------------------------------- |
| `semantic-release-version`                            | No       | `25.0.3` | The version of semantic-release to use.                                                        |
| `semantic-release-plugin-git-version`                 | No       | `10.0.1` | The version of the semantic-release git plugin to use.                                         |
| `semantic-release-plugin-conventionalcommits-version` | No       | `9.3.1`  | The version of the semantic-release conventional-changelog-conventionalcommits plugin to use. |
| `token`                                               | Yes      |          | The token used to authenticate to GitHub to create a new release.                             |
| `dry-run`                                             | No       | `false`  | Compute the version and expose outputs without creating a release.                            |

## Outputs

| Output                  | Description                                     |
| ----------------------- | ----------------------------------------------- |
| `new-release-published` | Whether or not a new version has been released. |
| `new-release-version`   | The new release version number.                 |
