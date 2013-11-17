//
//  AddNoteBookViewController.m
//  Wordtopia
//
//  Created by Vincent Ngo on 12/6/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import "AddNoteBookViewController.h"
#import "AppDelegate.h"

@interface AddNoteBookViewController ()

@end

@implementation AddNoteBookViewController


- (void)viewDidLoad
{

    
    
    [super viewDidLoad];
      
    
    // Instantiate a Add button to invoke the save: method when tapped
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self action:@selector(save:)];
    
    // Set up the add custom button on the right of the navigation bar
    self.navigationItem.rightBarButtonItem = addButton;


    
    
	// Do any additional setup after loading the view.
}

#pragma mark - Custom Add Buton's action method

// Adds the word to the notebooks selected.
- (void)save:(id)sender
{
    if (self.notebookName.text.length != 0){
    NSString *notebookName = self.notebookName.text;
        self.notebooknewName = notebookName;
        
        [self.delegate addNoteBookController:self didFinishWithSave:YES];
        
    }else{
        
        NSString *messageToDisplay = @"Please enter a special name.";
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Alert" message:messageToDisplay delegate:self
                              cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        
        [alert show];

    }
    
    //Add All of words key in plist
    
    //Add date created in plist
    
    
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Fix feature when break starts.

/*- (IBAction)selectImage:(id)sender {
    
    UIImagePickerController *pickerC =
    [[UIImagePickerController alloc] init];
    pickerC.delegate = self;
    [self presentViewController:pickerC animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerController delegate

//Methods below are needed to exit the photo album.

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    NSMutableArray *test = (NSMutableArray *)[[info allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    for (int i = 0 ; i < [test count]; i++){
        NSLog(@"something %@", [test objectAtIndex:i]);
    }
    
    
    UIImage *gotImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"original image --->%@",UIImagePickerControllerOriginalImage);
    [self.chosenImageView setImage:gotImage];
    NSLog(@"just info --- >%@", info);
    
[self dismissViewControllerAnimated:YES completion:nil];

}

//Cancel button to dismiss the photo album view.
- (void)imagePickerControllerDidCancel:
(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}*/
@end
