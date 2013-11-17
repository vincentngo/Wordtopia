//
//  FlipViewController.m
//  Wordtopia
//
//  Created by Vincent Ngo on 12/15/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import "FlipViewController.h"

@interface FlipViewController ()

@end

@implementation FlipViewController


- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"woodbg.png"]];

    self.numberContext = [self.selectedWord objectForKey:@"number of context"];
    self.prounciation = [self.selectedWord objectForKey:@"pronunciation"];
    self.soundFile = [self.selectedWord objectForKey:@"soundFile"];
    self.wordInformation.text = [self wordToString:self.selectedWord];
    self.wordLabel.text = self.selectedWordString;
    [super viewDidLoad];
    
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)flipBack:(id)sender {
    
    [self.delegate flipViewControllerDidFinish:self];
    
}


#pragma mark - wordDetail methods:

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




@end
