#import "StarHtmlPrintLibrary.h"
#import <React/RCTLog.h>
#import "StarPRNT.sdk.h"

@implementation StarHtmlPrintLibrary
{
    WKWebView* _webView;
    NSString* _portName;
    NSString* _portSettings;
    NSNumber* _width;
}


RCT_EXPORT_MODULE()

- (instancetype)init
{
    if (self = [super init]) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 120, 10)];
//        _webView.scalesPageToFit = true;
        _webView.UIDelegate = self;
        [_webView addSubview:_webView];
    }
    return self;
}

// RCT_EXPORT_METHOD(sampleMethod:(NSString *)stringArgument numberParameter:(nonnull NSNumber *)numberArgument callback:(RCTResponseSenderBlock)callback)
RCT_EXPORT_METHOD(printHtml:(NSString *)html portName:(NSString*)portName portSettings:(NSString*)portSettings width:(nonnull NSNumber*)width)
{
    // TODO: Implement some actually useful functionality
    // callback(@[[NSString stringWithFormat: @"numberArgument: %@ stringArgument: %@", numberArgument, stringArgument]]);
    RCTLogInfo(@"PRINTING HTML %@ at port %@, %@, %@", html, portName,
               portSettings, width);
    _portName = portName;
    _portSettings = portSettings;
    _width = width;
    [_webView loadHTMLString:html baseURL:nil];

//    NSString *html = [command valueForKey:@"appendHtml"];
//    NSInteger width = ([command valueForKey:@"width"]) ? [[command valueForKey:@"width"] intValue] : 576;
//    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
//    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 120, 10)];
////    webView.navigationDelegate = self;
//    NSURL *nsurl=[NSURL URLWithString:@"http://www.apple.com"];
//    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
//    [webView loadRequest:nsrequest];
//    UIView * wrapper = [[UIView alloc] init];
//    [wrapper addSubview:webView];
//    RCTLogInfo(@"WEBVIEW %@", webView);
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    RCTLogInfo(@"PRINTING HTML WEB VIEW DID FINISH LOAD ");

    
    UIImage* image = [StarHtmlPrintLibrary imageFromWebview:webView];
    
    ISCBBuilder *builder = [StarIoExt createCommandBuilder:1];
    
    [builder beginDocument];
    
    [builder appendBitmap:image diffusion:YES width:[_width intValue] bothScale:YES];
    
    [builder appendCutPaper:3];
    
    [builder endDocument];
    
    StarIoExtManager* starIoExtManager =
    [[StarIoExtManager alloc] initWithType:0
                                  portName:_portName
                              portSettings:_portSettings
                           ioTimeoutMillis:10000]; // 10000mS!!!
    BOOL connect = [starIoExtManager connect];
    
    if (!connect) {
        // TODO
        NSLog(@"[StarHtmlPrintLibrary] ERROR CONNECTING");
    } else {
        [starIoExtManager.lock lock];
        [StarHtmlPrintLibrary sendCommands:[builder commands] port:[starIoExtManager port]];
        [starIoExtManager.lock lock];
    }

    [starIoExtManager disconnect];
}

+(BOOL)sendCommands:(NSData *)commands port:(SMPort *)port {
    BOOL result = NO;
    NSUInteger commandLength = [commands length];
    const u_int8_t* commandsBytes = [commands bytes];
    
    @try {
        while (YES) {
            
            StarPrinterStatus_2 printerStatus;
            
            [port beginCheckedBlock:&printerStatus :2];
            
            if (printerStatus.offline == SM_TRUE) {
                break;
            }
            
            NSDate *startDate = [NSDate date];
            
            uint32_t total = 0;
            
            while (total < commandLength) {
                uint32_t written = [port writePort:commandsBytes :total :commandLength - total];
                
                total += written;
                
                if ([[NSDate date] timeIntervalSinceDate:startDate] >= 30.0) { // 30000mS!!!
                    break;
                }
            }
            
            if (total < commandLength) {
                break;
            }
            
            port.endCheckedBlockTimeoutMillis = 30000; // 30000mS!!!
            
            [port endCheckedBlock:&printerStatus :2];
            
            if (printerStatus.offline == SM_TRUE) {
                break;
            }
            
            result = YES;
            break;
        }
    }
    @catch (PortException *exc) {
    }
    
    return result;
}

+(UIImage*) imageFromWebview:(UIWebView*) webview {
    
    //store the original framesize to put it back after the snapshot
    CGRect originalFrame = webview.frame;
    
    //get the width and height of webpage using js (you might need to use another call, this doesn't work always)
    NSInteger webViewHeight = [[webview stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] integerValue];
    NSInteger webViewWidth = [[webview stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth;"] integerValue];
    
    //set the webview's frames to match the size of the page
    [webview setFrame:CGRectMake(0, 0, webViewWidth, webViewHeight)];
    
    //make the snapshot
    UIGraphicsBeginImageContextWithOptions(webview.frame.size, false, 0.0);
    [webview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //set the webview's frame to the original size
    [webview setFrame:originalFrame];
    
    //and VOILA :)
    return image;
}

@end
