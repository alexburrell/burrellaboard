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
@property UILongPressGestureRecognizer* longPressRecognizer;
@property UISwipeGestureRecognizer* swipeRecognizer;
@property NSTimer* timer;
@property NSString* displayedText;
@property KeyViewType type;

@end

@implementation KeyView

- (instancetype)initWithDisplayedText:(NSString*)text type:(KeyViewType)type handler:(void (^)(KeyView*))handler {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        self.handler = handler;
        self.type = type;

        if (self.type == KeyViewTypeReturn) {
            self.displayedText = @"\n";
        } else {
            self.displayedText = text;
        }
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
                
        [self createLabelWithText:text];
        [self createGestureRecognizers];
    }
    
    return self;
}

- (void)invokeHandler:(NSTimer*)timer {
    self.handler(self);
}

- (void)handleSingleTap:(UIGestureRecognizer*)tapRecognizer {
    if (tapRecognizer.state == UIGestureRecognizerStateRecognized) {
        self.handler(self);
    }
}

- (void)handleLongPress:(UIGestureRecognizer*)longPressRecognizer {
    if (self.type == KeyViewTypeBackspace) {
        if (longPressRecognizer.state == UIGestureRecognizerStateBegan) {
            if (!self.timer || !self.timer.valid) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(invokeHandler:) userInfo:nil repeats:YES];
            }
        } else if (longPressRecognizer.state == UIGestureRecognizerStateEnded ||
                   longPressRecognizer.state == UIGestureRecognizerStateFailed ||
                   longPressRecognizer.state == UIGestureRecognizerStateFailed) {
            [self.timer invalidate];
        }
    }
}

- (void)handleSwipe:(UIGestureRecognizer*)swipeRecognizer {
    if (swipeRecognizer.state == UIGestureRecognizerStateRecognized) {
        self.displayedText = [self.displayedText uppercaseString];
        self.handler(self);
        self.displayedText = [self.displayedText lowercaseString];
    }
}

- (void)createGestureRecognizers {
    self.singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:self.singleTapRecognizer];
    
    self.longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:self.longPressRecognizer];
    
    self.swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [self.swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [self addGestureRecognizer:self.swipeRecognizer];
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
    
}

@end
