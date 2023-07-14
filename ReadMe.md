# Chocolatey Package: [Paraffin](https://community.chocolatey.org/packages/paraffin)

[![Latest package version shield](https://img.shields.io/chocolatey/v/paraffin.svg)](https://community.chocolatey.org/packages/paraffin)
[![Total package download count shield](https://img.shields.io/chocolatey/dt/paraffin.svg)](https://community.chocolatey.org/packages/paraffin)

## Install

[Install Chocolatey](https://chocolatey.org/install), and run the following command to install the latest approved stable version from the Chocolatey Community Repository:

```shell
choco install paraffin --source="'https://community.chocolatey.org/api/v2'"
```

Alternatively, the packages as published on the Chocolatey Community Repository will also be mirrored on this repository's [Releases page](https://github.com/brogers5/chocolatey-package-paraffin/releases). The `nupkg` can be installed from the current directory (with dependencies sourced from the Community Repository) as follows:

```shell
choco install paraffin --source="'.;https://community.chocolatey.org/api/v2/'"
```

## Build

[Install Chocolatey](https://chocolatey.org/install), the [Chocolatey Automatic Package Updater Module](https://github.com/majkinetor/au), and the [PowerShellForGitHub PowerShell Module](https://github.com/microsoft/PowerShellForGitHub), then clone this repository.

Once cloned, simply run `build.ps1`. The ZIP archive is intentionally untracked to avoid bloating the repository, so the script will download the Paraffin portable ZIP archive from the official distribution point, then packs everything together.

A successful build will create `paraffin.x.y.z.nupkg`, where `x.y.z` should be the Nuspec's normalized `version` value at build time.

>**Note**
>Chocolatey package builds are non-deterministic. Consequently, an independently built package's checksum will not match that of the officially published package.

## Update

This package has an update script implemented with the [Chocolatey Automatic Package Updater Module](https://github.com/majkinetor/au), with update queries implemented by the [PowerShellForGitHub PowerShell Module](https://github.com/microsoft/PowerShellForGitHub), but the project does not appear to be actively maintained anymore, so it is not included with my normally scheduled update runs. If the project has a new release, please [open an issue](https://github.com/brogers5/chocolatey-package-paraffin/issues).

AU expects the parent directory that contains this repository to share a name with the Nuspec (`paraffin`). Your local repository should therefore be cloned accordingly:

```shell
git clone git@github.com:brogers5/chocolatey-package-paraffin.git paraffin
```

Alternatively, a junction point can be created that points to the local repository (preferably within a repository adopting the [AU packages template](https://github.com/majkinetor/au-packages-template)):

```shell
mklink /J paraffin ..\chocolatey-package-paraffin
```

Once created, simply run `update.ps1` from within the created directory/junction point. Assuming all goes well, all relevant files should change to reflect the latest version available. This will also build a new package version using the modified files.

Before submitting a pull request, please [test the package](https://docs.chocolatey.org/en-us/community-repository/moderation/package-verifier#steps-for-each-package) using the [Chocolatey Testing Environment](https://github.com/chocolatey-community/chocolatey-test-environment) first.
