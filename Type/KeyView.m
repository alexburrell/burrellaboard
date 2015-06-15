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

@end

@implementation KeyView

- (instancetype)initWithDisplayedText:(NSString*)text handler:(void (^)(KeyView*))handler {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        self.handler = handler;
        self.displayedText = text;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.keyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.keyLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.keyLabel.text = text;
        self.keyLabel.textAlignment = NSTextAlignmentCenter;
        self.keyLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.keyLabel.layer.borderWidth = 1;
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
    
    return self;
}

- (void)handleSingleTap:(UIGestureRecognizer*)tapRecognizer {
    if (tapRecognizer.state == UIGestureRecognizerStateRecognized) {
        self.handler(self);
    }
}

@end
