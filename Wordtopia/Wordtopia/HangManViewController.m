//
//  HangManViewController.m
//  Wordtopia
//
//  Created by Vincent Ngo on 12/14/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import "HangManViewController.h"
#import "AppDelegate.h"

@interface HangManViewController ()

@end

@implementation HangManViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    UIImage *toolbarImage = [UIImage imageNamed:@"nav-bar.png"];
    [self.toolBar setBackgroundImage:toolbarImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    


    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"woodbg.png"]];
    self.pickerViewContainer.frame = CGRectMake(0,460,320,261);
    
    
    //Obtain an object reference to the App Delegate object
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //data structure created in the App Delegate class
    self.notebookDict = appDelegate.notebookDict;
    
    
    NSLog(@"notebookDict size: %d", [self.notebookDict count]);
    
    //What if i want to organize them by the time of day?
    //
    //
    
    self.listOfNotebooks = (NSMutableArray *)[[self.notebookDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    self.numberOfTries.text = @"";
    
    [self hideButtons];
	// Do any additional setup after loading the view.
}

//Similar to UITableViews :)
#pragma mark - UIPickerView Methods


//Number of notebooks in my pickerview
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.listOfNotebooks count];
}

//Number of columns, in this case only 1 for the notebooks
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//Title for each row. 
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return [self.listOfNotebooks objectAtIndex:row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSString *notebookSelected = [self.listOfNotebooks objectAtIndex:row];
    self.notebookDictToData = [self.notebookDict objectForKey:notebookSelected];
    self.notebookDictToAllWords = [self.notebookDictToData objectForKey:@"all the words"];
    
    self.listOfWordsForBook = (NSMutableArray *)[[self.notebookDictToAllWords allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
}

#pragma mark - Hangman game methods
//Gets the letter pressed. 
-(void)checkHangmanLetterInput: (NSString *)letter{
    
    
    
    bool matching = NO;
    
    NSRange letterRange;
    self.correctWord = [self.correctWord uppercaseString];
    
    //Since there is only character in the string.
    char letterTocheck = [letter characterAtIndex:0];
    
    //For loop that runs through the correct word to find a matching letter.
    for (int i = 0; i < self.correctWord.length; i++){
        
        //gets a letter in the correctword
        char letterInCorrectWord = [self.correctWord characterAtIndex: i];
        
        //checks to see if the letter input is equal to that letter
        if (letterTocheck == letterInCorrectWord){
            //set matching to YES so we don't display another piece of the hangman
            matching = YES;
            
            //Gets the position of the letter in correct word
            letterRange = NSMakeRange(i, 1);
            
            //replaces the invisible label at position letterRange with the correct letter output.
            self.wordQuestionLabel.text = [self.wordQuestionLabel.text stringByReplacingCharactersInRange: letterRange withString:[NSString stringWithFormat:@"%c",letterTocheck]];
            
            if ([self.wordQuestionLabel.text isEqualToString:self.correctWord]){
                [self playWin];
                NSString *messageToDisplay = [NSString stringWithFormat:@"You Win! Congrats!, Press Start to play with a new word or select a different notebook!, The word was: %@", self.correctWord];
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Alert" message:messageToDisplay delegate:self
                                      cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                [self hideButtons];
            }
        }
    }
    
    if (matching == NO){
    
        self.wrongLetter ++;
        
        switch(self.wrongLetter){
            case 1:
                self.image1.hidden = NO;
                break;
            case 2:
                self.image2.hidden = NO;
                break;
            case 3:
                self.image3.hidden = NO;
                break;
            case 4:
                self.image4.hidden = NO;
                break;
            case 5:
                self.image5.hidden = NO;
                break;
            case 6:
                self.image6.hidden = NO;
                break;
            case 7:
                self.image7.hidden = NO;
                break;
            case 8:
                self.image8.hidden = NO;
                break;
            case 9:
                self.image9.hidden = NO;
                break;
            case 10:
                self.image10.hidden = NO;
                break;
            case 11:
                self.image11.hidden = NO;
                break;
            case 12:
                self.image12.hidden = NO;
                break;
            case 13:
                self.image13.hidden = NO;
                break;
            case 14:
                self.image14.hidden = NO;
                break;
                
            default:
                break;
        }
        
        self.numberOfTries.text = [NSString stringWithFormat:@"%d/14", self.wrongLetter];
        
        if (self.wrongLetter == 14) {
            
            [self playLose];
            
            NSString *messageToDisplay = [NSString stringWithFormat:@"You lose! Press Start for a new random word, or select a different notebook to play with! The word was actually: %@", self.correctWord];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Alert" message:messageToDisplay delegate:self
                                  cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            
            [alert show];
            self.wordQuestionLabel.lineBreakMode = 0;
            self.wordQuestionLabel.text = @" Click Start for another word or select a new notebook!";
            
            [self hideButtons];
            
            self.wrongLetter = 0;
            self.numberOfTries.text = @"0/14";
        }
        
        
        
    }
    
    
}

-(void) ResetHangManImages{
    
    self.image1.hidden = YES;
    self.image2.hidden = YES;
    self.image3.hidden = YES;
    self.image4.hidden = YES;
    self.image5.hidden = YES;
    self.image6.hidden = YES;
    self.image7.hidden = YES;
    self.image8.hidden = YES;
    self.image9.hidden = YES;
    self.image10.hidden = YES;
    self.image11.hidden = YES;
    self.image12.hidden = YES;
    self.image13.hidden = YES;
    self.image14.hidden = YES;
    
    [self showButtons];
    
}
-(void)showButtons{
    self.AButton.hidden = NO;
    self.BButton.hidden = NO;
    self.CButton.hidden = NO;
    self.DButton.hidden = NO;
    self.EButton.hidden = NO;
    self.FButton.hidden = NO;
    self.GButton.hidden = NO;
    self.HButton.hidden = NO;
    self.IButton.hidden = NO;
    self.JButton.hidden = NO;
    self.KButton.hidden = NO;
    self.LButton.hidden = NO;
    self.MButton.hidden = NO;
    self.NButton.hidden = NO;
    self.OButton.hidden = NO;
    self.PButton.hidden = NO;
    self.QButton.hidden = NO;
    self.RButton.hidden = NO;
    self.SButton.hidden = NO;
    self.TButton.hidden = NO;
    self.UButton.hidden = NO;
    self.VButton.hidden = NO;
    self.WButton.hidden = NO;
    self.XButton.hidden = NO;
    self.YButton.hidden = NO;
    self.ZButton.hidden = NO;
}

-(void)hideButtons{
    self.AButton.hidden = YES;
    self.BButton.hidden = YES;
    self.CButton.hidden = YES;
    self.DButton.hidden = YES;
    self.EButton.hidden = YES;
    self.FButton.hidden = YES;
    self.GButton.hidden = YES;
    self.HButton.hidden = YES;
    self.IButton.hidden = YES;
    self.JButton.hidden = YES;
    self.KButton.hidden = YES;
    self.LButton.hidden = YES;
    self.MButton.hidden = YES;
    self.NButton.hidden = YES;
    self.OButton.hidden = YES;
    self.PButton.hidden = YES;
    self.QButton.hidden = YES;
    self.RButton.hidden = YES;
    self.SButton.hidden = YES;
    self.TButton.hidden = YES;
    self.UButton.hidden = YES;
    self.VButton.hidden = YES;
    self.WButton.hidden = YES;
    self.XButton.hidden = YES;
    self.YButton.hidden = YES;
    self.ZButton.hidden = YES;
}

-(NSString *)chooseRandomWordFromNoteBook: (NSMutableArray *)noteBook{
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - showing and hiding the UIPickerView

- (IBAction)showNoteBooks:(id)sender {

    int selectedRow = [self.thePickerView selectedRowInComponent:0];
    
    //Default, first selected.
    NSString *notebookSelected = [self.listOfNotebooks objectAtIndex:selectedRow];
    self.notebookDictToData = [self.notebookDict objectForKey:notebookSelected];
    self.notebookDictToAllWords = [self.notebookDictToData objectForKey:@"all the words"];
    
    self.listOfWordsForBook = (NSMutableArray *)[[self.notebookDictToAllWords allKeys] sortedArrayUsingSelector:@selector(compare:)];

    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.pickerViewContainer.frame = CGRectMake(0, 200, 320, 261);
    [UIView commitAnimations];
}

- (IBAction)doneHidePicker:(id)sender {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.pickerViewContainer.frame = CGRectMake(0, 460, 320, 261);
    [UIView commitAnimations];
    
}
- (IBAction)letterPressed:(id)sender {
    
    
    UIButton *button = (UIButton *)sender;   // Typecast the sender to point to a button object
    
    [self checkHangmanLetterInput:button.titleLabel.text];
   
    button.hidden = YES;
}




- (IBAction)startGame:(id)sender {
    
    [self.audioPlayer stop];
    
    self.numberOfTries.text = @"0/14";
    
    if ([self.listOfWordsForBook count] != 0){
    int randomNumberForArray = arc4random() % [self.listOfWordsForBook count];
    NSString *wordForHangManSelected = [self.listOfWordsForBook objectAtIndex:randomNumberForArray];
        
        NSLog(@"selected word to play is %@", wordForHangManSelected);
        
        self.correctWord = wordForHangManSelected;
        
        NSString *hyphenString = @"";
        for (int i = 0; i < self.correctWord.length; i++){
            hyphenString = [hyphenString stringByAppendingString:@"-"];
        }
        
        self.wordQuestionLabel.text = hyphenString;
        
        [self ResetHangManImages];
        self.wrongLetter = 0;
    }else if ([self.listOfWordsForBook count] == 0 ){
        
       

        NSString *messageToDisplay = @"You have no words in notebook, or you haven't selected a notebook yet!";
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Alert" message:messageToDisplay delegate:self
                              cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        
        [alert show];
        
    }


}

-(void)playWin{
    NSURL *soundFileURL = [[NSBundle mainBundle] URLForResource:@"win" withExtension:@"wav"];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundFileURL error:nil];
    [self.audioPlayer play];
    
}

-(void)playLose{
    NSURL *soundFileURL = [[NSBundle mainBundle] URLForResource:@"sadTrombone_byJoe_Lamb" withExtension:@"wav"];
    self.audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:soundFileURL error:nil];
    [self.audioPlayer play];
    
}
@end
