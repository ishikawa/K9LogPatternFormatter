# K9LogPatternFormatter

**K9LogPatternFormatter** is flexible logging message formatter configurable with pattern string (inspired by [Log4j PatternLayout](http://logging.apache.org/log4j/2.x/manual/layouts.html#PatternLayout)). It includes a formatter implementation for [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack). Writing a new formatter for other framework is easy.

## Usage

```objc
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "K9LogLumberjackPatternFormatter.h"
...
id<DDLogger> consoleLogger = [DDTTYLogger sharedInstance];

consoleLogger.logFormatter = [[K9LogLumberjackPatternFormatter alloc] initWithPattern:@"%.1p: %m"];

[DDLog addLogger:consoleLogger];
```

Supported patterns:

* `%d{pattern}` timestamp
  * `pattern` is `dateFormat` of `NSDateFormatter`
* `%m` message
* `%p` log level

Min/max width modifier is also supported:

* `%20m` Left pad with spaces and min width = 20
* `%-5m` Right pad with spaces and min width = 5
* `%.10m` Truncate if message is longer than 10
* `%-5.10m` Right pad with spaces and min:5, max:10

For example, if the conversion pattern is `@"[%-5p] %d{HH':'mm':'ss} %m"`,  it would yield the output:

```
[DEBUG] 00:45:20 Message1
[WARN ] 00:45:21 Message2
```

## Requirements

- Mac OS X 10.8
- iOS 7.0

## Installation

In your Podfile

    pod "K9LogPatternFormatter/Core"
    pod "K9LogPatternFormatter/Lumberjack"

## License

MIT license

