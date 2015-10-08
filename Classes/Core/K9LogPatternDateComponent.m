#import "K9LogPatternDateComponent.h"
#import "K9ThreadLocal.h"

@interface K9LogPatternDateComponent ()

// Prior to iOS 7.0 / OS X 10.9: NSDateFormatter is NOT thread safe.
@property (nonatomic) K9ThreadLocal *threadLocalDateFormatter;

@end

@implementation K9LogPatternDateComponent

+ (NSDateFormatter *)createDateFormatterWithNameOrFormat:(NSString *)nameOfFormat
{
    static NSDictionary *predefinedDateFormats;
    static NSLocale *en_US_POSIX;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        en_US_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];

        // Predefined date formats are defined in Log4j 2 PatternLayout
        // http://logging.apache.org/log4j/2.x/manual/layouts.html#PatternLayout
        predefinedDateFormats = @{
                                  @"ISO8601" : @"yyyy'-'MM'-'dd' 'HH':'mm':'ss','SSS",
                                  @"ISO8601_BASIC" : @"yyyyMMdd' 'HHmmss','SSS",
                                  @"ABSOLUTE" : @"HHmmss','SSS",
                                  @"DATE" : @"dd' 'MMM' 'yyyy' 'HH':'mm':'ss','SSS",
                                  @"COMPACT" : @"yyyyMMddHHmmssSSS",
                                  };
    });

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    formatter.locale = en_US_POSIX; // For predefined formats

    // TODO: Take time zone id from parameter if specified
    formatter.timeZone = [NSTimeZone systemTimeZone];

    // TODO: Add more predefined formats

    // If no format is given, "ISO8601" is assumed
    if (!nameOfFormat) {
        nameOfFormat = @"ISO8601";
    }

    NSAssert(nameOfFormat != nil, @"nameOfFormat");

    NSString *format = predefinedDateFormats[nameOfFormat];

    if (format) {
        formatter.dateFormat = format;
    } else {
        formatter.locale     = [NSLocale currentLocale];
        formatter.dateFormat = nameOfFormat;
    }

    return formatter;
}

- (instancetype)initWithNameOrFormat:(NSString *)nameOrFormat
{
    return [self initWithParameters:@[ nameOrFormat ]];
}

- (instancetype)initWithParameters:(NSArray *)parameters
{
    if ((self = [super initWithParameters:parameters])) {
        if (parameters.count > 0) {
            _nameOrFormat = parameters[0];
        }

        _threadLocalDateFormatter = [[K9ThreadLocal alloc] init];
    }

    return self;
}

- (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = _threadLocalDateFormatter.value;

    if (!dateFormatter) {
        dateFormatter = [[self class] createDateFormatterWithNameOrFormat:_nameOrFormat];

        _threadLocalDateFormatter.value = dateFormatter;
    }

    return dateFormatter;
}

- (NSLocale *)locale
{
    return [[self dateFormatter] locale];
}

- (NSTimeZone *)timeZone
{
    return [[self dateFormatter] timeZone];
}

- (nonnull NSString *)stringFromLogMessage:(nonnull id<K9LogMessage>)logMessage
{
    NSDateFormatter *dateFormatter = [self dateFormatter];

    return [dateFormatter stringFromDate:[logMessage k9_timestamp]];
}

@end
