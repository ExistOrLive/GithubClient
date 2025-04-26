fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios matchNewCert

```sh
[bundle exec] fastlane ios matchNewCert
```



### ios github_action_build_check

```sh
[bundle exec] fastlane ios github_action_build_check
```

just build check, prevent any build or link error

### ios github_action_adhoc

```sh
[bundle exec] fastlane ios github_action_adhoc
```

build one adhoc release on github actions

### ios github_action_testFlight

```sh
[bundle exec] fastlane ios github_action_testFlight
```

build one TestFlight release on github action

### ios localMatch

```sh
[bundle exec] fastlane ios localMatch
```

local match

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
