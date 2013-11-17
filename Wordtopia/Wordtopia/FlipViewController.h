//
//  FlipViewController.h
//  Wordtopia
//
//  Created by Vincent Ngo on 12/15/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlipViewControllerDelegate;

@interface FlipViewController : UIViewController

@property (nonatomic, strong) id <FlipViewControllerDelegate> delegate;


@property (strong, nonatomic) NSMutableDictionary *selectedWord;
@property (strong, nonatomic) NSString *selectedWordString;


@property (strong, nonatomic) IBOutlet UILabel *wordLabel;
@property (strong, nonatomic) IBOutlet UITextView *wordInformation;

- (IBAction)flipBack:(id)sender;





//number of context of word.
@property (strong, nonatomic) NSNumber *numberContext;

//prounciation
@property (strong, nonatomic) NSString *prounciation;

//soundFile
@property (strong, nonatomic) NSString *soundFile;

@end

@protocol FlipViewControllerDelegate
- (void)flipViewControllerDidFinish:(FlipViewController *)controller;
@end