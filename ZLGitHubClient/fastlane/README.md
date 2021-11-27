fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios local_test
```
fastlane ios local_test
```

### ios adhoc
```
fastlane ios adhoc
```
build one adhoc release local
### ios github_action_build_check
```
fastlane ios github_action_build_check
```
just build check, prevent any build or link error
### ios jenkins_adhoc
```
fastlane ios jenkins_adhoc
```
build one adhoc release local
### ios github_action_adhoc
```
fastlane ios github_action_adhoc
```
build one adhoc release on github actions
### ios travis_adhoc
```
fastlane ios travis_adhoc
```
build one adhoc release on travis
### ios github_action_testFlight
```
fastlane ios github_action_testFlight
```
build one TestFlight release on github action
### ios beta
```
fastlane ios beta
```
build one TestFlight release
### ios release
```
fastlane ios release
```
build one release for apple check

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
