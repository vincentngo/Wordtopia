//
//  HangManViewController.h
//  Wordtopia
//
//  Created by Vincent Ngo on 12/14/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface HangManViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
- (IBAction)showNoteBooks:(id)sender;
- (IBAction)doneHidePicker:(id)sender;


@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

//This UIView contains the UIPickerView and the ToolBar
@property (strong, nonatomic) IBOutlet UIView *pickerViewContainer;

@property (strong, nonatomic) IBOutlet UIPickerView *thePickerView;

//This "mutable" dictionary will contain all the notebooks from the plist app delegate
@property (nonatomic, strong) NSMutableDictionary *notebookDict;

//This will contain all the names of the notebookDict
@property (nonatomic, strong) NSMutableArray *listOfNotebooks;

//get a particular notebook
@property (nonatomic, strong) NSMutableDictionary *notebookDictToData;

//Gets a dictionary containing all the words within a notebook
@property (nonatomic, strong) NSMutableDictionary *notebookDictToAllWords;

//The letters will appear here. 
@property (strong, nonatomic) IBOutlet UILabel *wordQuestionLabel;

//list of words for a particular notebook
@property (strong, nonatomic)NSMutableArray *listOfWordsForBook;

//
//Correct word
@property (strong, nonatomic) NSString *correctWord;
@property (nonatomic) int wrongLetter;

- (IBAction)startGame:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *numberOfTries;

//Hangman images
@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIImageView *image2;
@property (strong, nonatomic) IBOutlet UIImageView *image3;
@property (strong, nonatomic) IBOutlet UIImageView *image4;
@property (strong, nonatomic) IBOutlet UIImageView *image5;
@property (strong, nonatomic) IBOutlet UIImageView *image6;
@property (strong, nonatomic) IBOutlet UIImageView *image7;
@property (strong, nonatomic) IBOutlet UIImageView *image8;
@property (strong, nonatomic) IBOutlet UIImageView *image9;
@property (strong, nonatomic) IBOutlet UIImageView *image10;
@property (strong, nonatomic) IBOutlet UIImageView *image11;
@property (strong, nonatomic) IBOutlet UIImageView *image12;
@property (strong, nonatomic) IBOutlet UIImageView *image13;
@property (strong, nonatomic) IBOutlet UIImageView *image14;


//Reference of all the letter buttons. 
@property (strong, nonatomic) IBOutlet UIButton *AButton;
@property (strong, nonatomic) IBOutlet UIButton *BButton;
@property (strong, nonatomic) IBOutlet UIButton *CButton;
@property (strong, nonatomic) IBOutlet UIButton *DButton;
@property (strong, nonatomic) IBOutlet UIButton *EButton;
@property (strong, nonatomic) IBOutlet UIButton *FButton;
@property (strong, nonatomic) IBOutlet UIButton *HButton;
@property (strong, nonatomic) IBOutlet UIButton *IButton;
@property (strong, nonatomic) IBOutlet UIButton *JButton;
@property (strong, nonatomic) IBOutlet UIButton *KButton;
@property (strong, nonatomic) IBOutlet UIButton *GButton;
@property (strong, nonatomic) IBOutlet UIButton *LButton;
@property (strong, nonatomic) IBOutlet UIButton *MButton;
@property (strong, nonatomic) IBOutlet UIButton *NButton;
@property (strong, nonatomic) IBOutlet UIButton *OButton;
@property (strong, nonatomic) IBOutlet UIButton *PButton;
@property (strong, nonatomic) IBOutlet UIButton *QButton;
@property (strong, nonatomic) IBOutlet UIButton *RButton;
@property (strong, nonatomic) IBOutlet UIButton *SButton;
@property (strong, nonatomic) IBOutlet UIButton *TButton;
@property (strong, nonatomic) IBOutlet UIButton *UButton;
@property (strong, nonatomic) IBOutlet UIButton *VButton;
@property (strong, nonatomic) IBOutlet UIButton *WButton;
@property (strong, nonatomic) IBOutlet UIButton *XButton;
@property (strong, nonatomic) IBOutlet UIButton *YButton;
@property (strong, nonatomic) IBOutlet UIButton *ZButton;

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;


- (IBAction)letterPressed:(id)sender;






@end
