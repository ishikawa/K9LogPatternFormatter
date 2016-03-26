#import "K9LogPatternDateComponent.h"

@interface K9LogPatternDateComponent ()

@property (nonatomic, nonnull) NSDateFormatter *dateFormatter;

@end

@implementation K9LogPatternDateComponent

+ (nonnull NSDateFormatter *)createDateFormatterWithNameOrFormat:(nonnull NSString *)nameOfFormat
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
    if ((self = [super init])) {
        if (parameters.count > 0) {
            _nameOrFormat = parameters[0];
        }
    }

    return self;
}

- (nonnull NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[self class] createDateFormatterWithNameOrFormat:_nameOrFormat];
    }

    return _dateFormatter;
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
