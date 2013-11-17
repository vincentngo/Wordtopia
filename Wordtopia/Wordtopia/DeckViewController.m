//
//  DeckViewController.m
//  Wordtopia
//
//  Created by Vincent Ngo on 12/15/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import "DeckViewController.h"

@interface DeckViewController ()

@end

@implementation DeckViewController



#pragma mark - FlipViewController delegate
-(void)flipViewControllerDidFinish:(FlipViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"woodbg.png"]];

    [super viewDidLoad];
    self.wordLabel.text = self.word;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToTabView:(id)sender {
    [self.delegate deckViewControllerDidFinish:self];
}

- (IBAction)flipToBack:(id)sender {
    
    FlipViewController *controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:NULL] instantiateViewControllerWithIdentifier:@"cardBack"];
    
    controller.delegate = self;
    controller.wordLabel.text = self.word;
    controller.selectedWordString = self.word;
    controller.selectedWord = [self.wordDict objectForKey:self.word];
    
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}




@end
