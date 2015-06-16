//
//  KeyView.m
//  Burrellaboard
//
//  Created by Alex Burrell on 6/14/15.
//  Copyright © 2015 Alex Burrell. All rights reserved.
//

#import "KeyView.h"

@interface KeyView ()
@property UILabel* keyLabel;
@property (nonatomic, copy) void (^handler)(KeyView*);
@property UITapGestureRecognizer* singleTapRecognizer;
@property NSString* displayedText;
@property KeyViewType type;

@end

@implementation KeyView

- (instancetype)initWithDisplayedText:(NSString*)text type:(KeyViewType)type handler:(void (^)(KeyView*))handler {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        self.handler = handler;
        self.displayedText = text;
        self.type = type;
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
                
        [self createLabelWithText:text];
    }
    
    return self;
}

- (void)handleSingleTap:(UIGestureRecognizer*)tapRecognizer {
    if (tapRecognizer.state == UIGestureRecognizerStateRecognized) {
        self.handler(self);
    }
}

- (void)createLabelWithText:(NSString*)text {
    self.keyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.keyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.keyLabel.text = text;
    self.keyLabel.textAlignment = NSTextAlignmentCenter;
    
    if (self.type == KeyViewTypeLetter) {
        [self.keyLabel setTextColor:[UIColor blackColor]];
    } else if (self.type == KeyViewTypeBackspace) {
        [self.keyLabel setTextColor:[UIColor redColor]];
    } else {
        [self.keyLabel setTextColor:[UIColor blueColor]];
    }
    
    [self addSubview:self.keyLabel];
    
    UILabel* keyLabel = self.keyLabel;
    [NSLayoutConstraint activateConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[keyLabel]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(keyLabel)]];
    [NSLayoutConstraint activateConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[keyLabel]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(keyLabel)]];
    
    self.singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:self.singleTapRecognizer];
}

@end
