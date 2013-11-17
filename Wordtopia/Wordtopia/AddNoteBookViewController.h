//
//  AddNoteBookViewController.h
//  Wordtopia
//
//  Created by Vincent Ngo on 12/6/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddNoteBookViewControllerDelegate;


@interface AddNoteBookViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *notebookName;
@property (nonatomic, assign) id <AddNoteBookViewControllerDelegate> delegate;

@property (nonatomic,strong) NSString *notebooknewName;


//DO this later in the future...
/*- (IBAction)selectImage:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *chosenImageView;*/

@end


/*
 The Protocol must be specified after the Interface specification is ended.
 Guidelines:
 - Create a protocol name as ClassNameDelegate as we did above.
 - Create a protocol method name starting with the name of the class defining the protocol.
 - Make the first method parameter to be the object reference of the caller as we did below.
 */
@protocol AddNoteBookViewControllerDelegate

- (void)addNoteBookController:(AddNoteBookViewController *)controller didFinishWithSave:(BOOL)save;

@end