//
//  WordDetailViewController.m
//  Wordtopia
//
//  Created by Vincent Ngo on 12/12/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import "WordDetailViewController.h"
#import <UIKit/UIKit.h> 


@interface WordDetailViewController ()

@end

@implementation WordDetailViewController


- (void)viewDidLoad
{
    
    //Sets all the respective data from the NoteBookWordsViewController
    self.numberContext = [self.selectedWord objectForKey:@"number of context"];
    self.prounciation = [self.selectedWord objectForKey:@"pronunciation"];
    self.soundFile = [self.selectedWord objectForKey:@"soundFile"];
    //self.selectedWordInfoDict = [self.selectedWord objectForKey:self.selectedWordString];
    
    
    self.wordInfo = [NSMutableString stringWithString:[self wordToString:self.selectedWordInfoDict]];
    
    NSLog(@"wordInfo is %@\n",self.wordInfo);
    
    self.wordInformationLabel.text = self.wordInfo;
    self.wordLabel.numberOfLines = 0; //Set number of lines to zero so we can allow as many breakpoints
    self.wordLabel.text = [NSString stringWithFormat:@"%@\n%@",self.selectedWordString,self.prounciation];

    self.title = _selectedWordString;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSString *)wordToString:(NSMutableDictionary *)wordInfo{
    
    NSMutableString *wordDetails = [[NSMutableString alloc]init];
    
    if ([self.numberContext intValue] != 0){
        
        for (int i = 1; i <= [self.numberContext intValue]; i++){
            //If there is more than one of the same word in the dictionary, means they are used
            //in different context.
            NSString *wordNumber = [NSString stringWithFormat:@"%@[%d]", self.selectedWordString, i];
            NSMutableDictionary *wordInfo = [self.selectedWord objectForKey:wordNumber];
            
            //Grabbing all the information out of the dictionary to be string formatted in a nice way.
            NSArray *definitionList = [wordInfo objectForKey:@"definitions"];
            NSArray *exampleList = [wordInfo objectForKey:@"examples"];
            NSString *type = [wordInfo objectForKey:@"type"];
            
            
            //Combine definitions, examples and types.
            [wordDetails appendFormat:@"%@[%d]\n",self.selectedWordString, i];
            [wordDetails stringByAppendingFormat:@"Word Type: %@\n\n", type];

            NSString *definitionString = [self toStringDefinition:definitionList];
            NSString *exampleString = [self toStringExample:exampleList];
            
            [wordDetails appendFormat:@"Definition: \n\n%@\n\n",definitionString];
            
            [wordDetails appendFormat:@"Examples: \n\n%@\n\n",exampleString];
            
        }
        
        }else{
            
            NSString *wordNumber = [NSString stringWithFormat:@"%@", self.selectedWordString];
            NSMutableDictionary *wordInfo = [self.selectedWord objectForKey:wordNumber];
            
            //Grabbing all the information out of the dictionary to be string formatted in a nice way.
            NSArray *definitionList = [wordInfo objectForKey:@"definitions"];
            NSArray *exampleList = [wordInfo objectForKey:@"examples"];
            NSString *type = [wordInfo objectForKey:@"type"];
            
            
            //Combine definitions, examples and types.

            [wordDetails stringByAppendingFormat:@"Word Type: %@\n\n", type];
            
            NSString *definitionString = [self toStringDefinition:definitionList];
            NSString *exampleString = [self toStringExample:exampleList];
            
            [wordDetails appendFormat:@"Definition: \n\n%@\n\n",definitionString];
            
            [wordDetails appendFormat:@"Examples: \n\n%@\n\n",exampleString];

            
            
        }
        
        return wordDetails;
    }
    



-(NSMutableString *)toStringDefinition:(NSArray *)list{
    
    
    
    NSMutableString *definitionString = [[NSMutableString alloc]init];
    
    if ([list count] == 0){
        return definitionString;
    }
    
    for (int i = 0; i < [list count]; i++){
        [definitionString appendFormat:@"%d -%@\n",i+1,[list objectAtIndex:i]];
    }
    
    NSLog(@"definition string is %@\n", definitionString);
    return definitionString;
}

-(NSMutableString *)toStringExample:(NSArray *)list{
    
    
    
     NSMutableString *exampleString = [[NSMutableString alloc]init];
    
    if ([list count] == 0){
        return exampleString;
    }
    for (int i = 0; i < [list count]; i++){
        [exampleString appendFormat:@"%d -%@\n",i+1,[list objectAtIndex:i]];
    }
    
    NSLog(@"definition string is %@\n", exampleString);
    return exampleString;
}



- (IBAction)playSound:(id)sender {
    
    NSURL *fileURL = [NSURL URLWithString:self.soundFile];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:fileURL];
    self.avPLayer = [AVPlayer playerWithPlayerItem:playerItem];
    [self.avPLayer play];
    self.avPLayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    
}


@end
