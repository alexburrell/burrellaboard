//
//  KeyboardViewController.m
//  Type
//
//  Created by Alex Burrell on 6/14/15.
//  Copyright © 2015 Alex Burrell. All rights reserved.
//

#import "KeyboardViewController.h"
#import "KeyView.h"

typedef void (^KeyHandler)(KeyView*);

@interface KeyboardViewController ()
@property (nonatomic, strong) UIButton* nextKeyboardButton;
@property NSArray* handlerMap;
@end

@implementation KeyboardViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    KeyHandler Insert = ^(KeyView* keyView) { [self.textDocumentProxy insertText:[keyView displayedText]]; };
    KeyHandler Delete = ^(KeyView* keyView) { [self.textDocumentProxy deleteBackward]; };
    self.handlerMap = @[Insert, Insert, Delete, Insert, Insert, Insert];
    
    // Adding a top border to the keyboard
    UIView* topBorder = [[UIView alloc] initWithFrame:CGRectZero];
    [topBorder setBackgroundColor:[UIColor lightGrayColor]];
    topBorder.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:topBorder];
    [NSLayoutConstraint activateConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topBorder]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(topBorder)]];
    [NSLayoutConstraint activateConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topBorder(==1)]"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(topBorder)]];
    
    [self addKeyboardButtons];
    
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
    
}

- (void)addKeyboardButtons {
    
    // Set up the alphabet keys
    NSString* keySettingsPath = [[NSBundle mainBundle] pathForResource:@"Keys.en" ofType:@"plist"];
    NSDictionary* keySettings = [NSDictionary dictionaryWithContentsOfFile:keySettingsPath];
    NSArray* keyboardRows = [keySettings objectForKey:@"rows"];
    UIView* previousRow = nil;
    for (NSArray* keyboardRow in keyboardRows) {
        UIView* row = [[UIView alloc] init];
        row.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:row];
        
        NSDictionary* lastLetter = [keyboardRow lastObject];
        UIView* previousLetter = nil;
        for (NSDictionary* alphabetLetter in keyboardRow) {
            NSString* displayedText = [alphabetLetter objectForKey:@"displayedText"];
            NSInteger type = [[alphabetLetter objectForKey:@"type"] intValue];
            KeyView* alphabetKey = [[KeyView alloc] initWithDisplayedText:displayedText type:type handler:self.handlerMap[type]];
            [row addSubview:alphabetKey];
            
            [NSLayoutConstraint activateConstraints:
             [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[alphabetKey]|"
                                                     options:0
                                                     metrics:nil
                                                       views:NSDictionaryOfVariableBindings(alphabetKey)]];
            
            NSString* lettersVisualFormat = @"H:|[alphabetKey]";
            NSDictionary* letterViews = NSDictionaryOfVariableBindings(alphabetKey);
            if (previousLetter) {
                lettersVisualFormat = @"[previousLetter][alphabetKey(==previousLetter)]";
                letterViews = NSDictionaryOfVariableBindings(previousLetter, alphabetKey);
            }
            if (alphabetLetter == lastLetter) {
                lettersVisualFormat = @"[previousLetter][alphabetKey(==previousLetter)]|";
            }
            [NSLayoutConstraint activateConstraints:
             [NSLayoutConstraint constraintsWithVisualFormat:lettersVisualFormat
                                                     options:0
                                                     metrics:nil
                                                       views:letterViews]];
            previousLetter = alphabetKey;
        }
        
        [NSLayoutConstraint activateConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[row]|"
                                                 options:0
                                                 metrics:nil
                                                   views:NSDictionaryOfVariableBindings(row)]];
        
        NSString* rowsVisualFormat = @"V:|[row(==60)]";
        NSDictionary* rowViews = NSDictionaryOfVariableBindings(row);
        if (previousRow) {
            rowsVisualFormat = @"V:[previousRow][row(==60)]";
            rowViews = NSDictionaryOfVariableBindings(previousRow, row);
        }
        [NSLayoutConstraint activateConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:rowsVisualFormat
                                                 options:0
                                                 metrics:nil
                                                   views:rowViews]];
        previousRow = row;
    }
    
    [self layoutBottomRow];
    
}

- (void)layoutBottomRow {
    // Add space key
    KeyView* spaceKey = [[KeyView alloc] initWithDisplayedText:@"space" type:KeyViewTypeSpace handler:self.handlerMap[KeyViewTypeSpace]];
    [self.view addSubview:spaceKey];
    
    // Add next button
    self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    UIButton* nextKeyboardButton = self.nextKeyboardButton;
    [self.nextKeyboardButton setTitle:@"🌐" forState:UIControlStateNormal];
    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.nextKeyboardButton addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextKeyboardButton];
    
    // Add space key
    KeyView* smileKey = [[KeyView alloc] initWithDisplayedText:@"😊" type:KeyViewTypeEmoji handler:self.handlerMap[KeyViewTypeEmoji]];
    [self.view addSubview:smileKey];
    
    // Layout bottom row buttons
    [NSLayoutConstraint activateConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[nextKeyboardButton]-[spaceKey]-[smileKey]-10-|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(nextKeyboardButton, spaceKey, smileKey)]];
    [NSLayoutConstraint activateConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[nextKeyboardButton]-8-|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(nextKeyboardButton)]];
    [NSLayoutConstraint activateConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[spaceKey]-13-|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(spaceKey)]];
    [NSLayoutConstraint activateConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[smileKey]-13-|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(smileKey)]];
    
}

@end
