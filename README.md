# K9LogPatternFormatter

**K9LogPatternFormatter** is flexible logging message formatter configurable with pattern string (inspired by [Log4j PatternLayout](http://logging.apache.org/log4j/2.x/manual/layouts.html#PatternLayout)). It includes a formatter implementation for [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack). Writing a new formatter for other framework is easy.

## Usage

```objc
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <K9LogPatternFormatter/K9LogLumberjackPatternFormatter.h>

...
id<DDLogger> consoleLogger = [DDTTYLogger sharedInstance];

consoleLogger.logFormatter = [[K9LogLumberjackPatternFormatter alloc] initWithPattern:@"%.1p: %m"];

[DDLog addLogger:consoleLogger];
```

Supported patterns:

* `%d{pattern}` timestamp formatted by using `NSDateFormatter`
    * `%d{HH':'mm':'ss}` prints `14:34:02`
    * Threre are some predefined formats:
        1. `%d{ISO8601}` prints `2014-03-12 14:34:02,781`
        2. `%d{ISO8601_BASIC}` prints `20140312 143402,781`
        3. `%d{ABSOLUTE}` prints `14:34:02,781`
        4. `%d{DATE}` prints `12 Mar 2014 14:34:02,781`
        5. `%d{COMPACT}` prints `20140312143402781`
    * If no format is given, `ISO8601` is used.
* `%m` message
* `%p` log level
* `%F` file name without extension
* `%l` file path
* `%L` line number
* `%M` function or method name
* `%%` single percent sign (`'%'`)

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

`@"%.1p: %m at %F:%L"` would yield:

```
D: Message1 at File1:15
W: Message2 at File2:32
```

## Requirements

- Mac OS X 10.8
- iOS 7.0

## Installation

If you want formatter for [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack), in your Podfile:

    pod "K9LogPatternFormatter/Lumberjack"

or, you can grab core classes to writting your own formatter:

    pod "K9LogPatternFormatter/Core"

## License

MIT license

