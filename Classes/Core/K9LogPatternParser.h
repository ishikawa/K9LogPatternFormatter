#import <Foundation/Foundation.h>

@interface K9LogPatternParser : NSObject

// TODO: Parse result class (can be confirmed to K9LogPatternComponent)

- (NSArray *)parse:(NSString *)pattern error:(NSError **)errorPtr;

// TODO: Customization API

@end
