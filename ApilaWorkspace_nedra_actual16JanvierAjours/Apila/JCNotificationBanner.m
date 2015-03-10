#import "JCNotificationBanner.h"

@implementation JCNotificationBanner

@synthesize title;
@synthesize message;
@synthesize timeout;
@synthesize tapHandler;

- (JCNotificationBanner*) initWithTitle:(NSString*)_title
                                message:(NSString*)_message
                             tapHandler:(JCNotificationBannerTapHandlingBlock)_tapHandler {
  
  return [self initWithTitleWithoutDelay:_title message:_message tapHandler:_tapHandler];
}


- (JCNotificationBanner*) initWithTitle:(NSString*)_title
                                message:(NSString*)_message
                                timeout:(NSTimeInterval)_timeout
                             tapHandler:(JCNotificationBannerTapHandlingBlock)_tapHandler {
  
  self = [super init];
  if (self) {
    self.title = _title;
    self.message = _message;
    self.timeout = _timeout;
    self.tapHandler = _tapHandler;
  }
  return self;
}
- (JCNotificationBanner*) initWithTitleWithoutDelay:(NSString*)_title
                                message:(NSString*)_message
                             tapHandler:(JCNotificationBannerTapHandlingBlock)_tapHandler {
    
    self = [super init];
    if (self) {
        self.title = _title;
        self.message = _message;
        self.tapHandler = _tapHandler;
    }
    return self;
}

@end
