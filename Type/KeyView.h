//
//  KeyView.h
//  Burrellaboard
//
//  Created by Alex Burrell on 6/14/15.
//  Copyright © 2015 Alex Burrell. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KeyViewType) {
    KeyViewTypeLetter = 0,
    KeyViewTypeReturn,
    KeyViewTypeBackspace,
    KeyViewTypeExpand
};

@interface KeyView : UIView

- (instancetype)initWithDisplayedText:(NSString*)text type:(KeyViewType)type handler:(void (^)(KeyView*))handler;

@property (readonly) NSString* displayedText;

@end
