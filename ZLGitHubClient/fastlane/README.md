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
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios adhoc
```
fastlane ios adhoc
```
build one adhoc release local
### ios travis_adhoc
```
fastlane ios travis_adhoc
```
build one adhoc release on travis
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
