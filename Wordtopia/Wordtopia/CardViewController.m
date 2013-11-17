//
//  CardViewController.m
//  Wordtopia
//
//  Created by Vincent Ngo on 12/14/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import "CardViewController.h"
#import "DeckViewController.h"

@interface CardViewController ()

@end

@implementation CardViewController

- (void)viewDidLoad
{

    
   // NSArray *dataArray = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"Good"],[NSString stringWithFormat:@"Better"],[NSString stringWithFormat:@"Best"], nil];
    [super viewDidLoad];
    
        //self.listOfWords = (NSMutableArray *)[[self.wordDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    int numberOfViews = 5;
    for (int i=0; i< [self.listOfWords count]; i++) {
        
        DeckViewController *controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:NULL] instantiateViewControllerWithIdentifier:@"flashcard"];
        
        controller.word = [self.listOfWords objectAtIndex:i];
        controller.delegate = self.delegate;
        controller.wordDict = self.wordDict;
        
        [self addChildViewController:controller];
    }
    

    
    

	// Do any additional setup after loading the view.
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
