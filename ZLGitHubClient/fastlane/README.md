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

### ios local_test

```sh
[bundle exec] fastlane ios local_test
```



### ios local_adhoc

```sh
[bundle exec] fastlane ios local_adhoc
```

build one adhoc release local

### ios github_action_build_check

```sh
[bundle exec] fastlane ios github_action_build_check
```

just build check, prevent any build or link error

### ios jenkins_adhoc

```sh
[bundle exec] fastlane ios jenkins_adhoc
```

build one adhoc release local

### ios github_action_adhoc

```sh
[bundle exec] fastlane ios github_action_adhoc
```

build one adhoc release on github actions

### ios travis_adhoc

```sh
[bundle exec] fastlane ios travis_adhoc
```

build one adhoc release on travis

### ios github_action_testFlight

```sh
[bundle exec] fastlane ios github_action_testFlight
```

build one TestFlight release on github action

### ios beta

```sh
[bundle exec] fastlane ios beta
```

build one TestFlight release

### ios release

```sh
[bundle exec] fastlane ios release
```

build one release for apple check

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
