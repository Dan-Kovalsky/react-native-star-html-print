#import "StarHtmlPrintLibrary.h"
#import <React/RCTLog.h>

@implementation StarHtmlPrintLibrary

RCT_EXPORT_MODULE()

// RCT_EXPORT_METHOD(sampleMethod:(NSString *)stringArgument numberParameter:(nonnull NSNumber *)numberArgument callback:(RCTResponseSenderBlock)callback)
RCT_EXPORT_METHOD(printHtml:(NSString *)html portName:(NSString*)portName portSettings:(NSString*)portSettings width:(nonnull NSNumber*)width)
{
    // TODO: Implement some actually useful functionality
    // callback(@[[NSString stringWithFormat: @"numberArgument: %@ stringArgument: %@", numberArgument, stringArgument]]);
    RCTLogInfo(@"PRINTING HTML %@ at port %@, %@, %@", html, portName, portSettings, width);

}

@end
