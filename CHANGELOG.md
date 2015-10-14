# CHANGELOG

## 1.1.0

* New patterns
  - Single percent sign pattern `%%`

## 1.0.0

* Migrating to CocoaLumberjack 2.x

**IMPORTANT: Version 0.y.z is for initial develpment. Anything may change at any time. The public API should not be considered stable.**

## 0.4.0

* Add `%M` pattern to print method/function name
* Add more predefined date formats
* Refactor predefined date formats

## 0.3.0

* Remove k9_fileName from K9LogMessage protocol
* Implement fileName manipulation in K9LogPatternFileNameComponent
* Change return type of k9_filePath

## 0.2.0

* Change return type of `[K9LogPatternParser parse:error:]`
* Clarify errors
* Add fileName, filePath, lineNumber convertion specifiers

## 0.1.1

* Minor documentation fixes
* Fix `pod spec lint` raises error for subspec

## 0.1.0

Initial release.
