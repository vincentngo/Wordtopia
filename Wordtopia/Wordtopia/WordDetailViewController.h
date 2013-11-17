//
//  WordDetailViewController.h
//  Wordtopia
//
//  Created by Vincent Ngo on 12/12/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
@interface WordDetailViewController : UIViewController


//Maybe add recording for the user? TO see his pronuouciation? 


@property (strong, nonatomic) NSMutableDictionary *selectedWord;
@property (strong, nonatomic) NSString *selectedWordString;

//selectedWord's dictionary that contains definitions and examples
@property (strong, nonatomic) NSMutableDictionary *selectedWordInfoDict;

//number of context of word.
@property (strong, nonatomic) NSNumber *numberContext;

//prounciation
@property (strong, nonatomic) NSString *prounciation;

//soundFile
@property (strong, nonatomic) NSString *soundFile;



//Displays the words label
@property (strong, nonatomic) IBOutlet UILabel *wordLabel;

//Plays the word's sound
- (IBAction)playSound:(id)sender;

//Displays all the information related to that word.

@property (strong, nonatomic) IBOutlet UITextView *wordInformationLabel;
@property (strong, nonatomic) NSMutableString *wordInfo;

@property (strong, nonatomic)AVPlayer *avPLayer;

@end
