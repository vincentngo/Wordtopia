//
//  AppDelegate.m
//  Wordtopia
//
//  Created by Vincent Ngo on 11/19/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    
    NSLog(@"document %@", documentsDirectoryPath);
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"wordOfTheDay.plist"];
    
    
    NSString *documentsDirectoryPathNoteB = [paths objectAtIndex:0];
    NSString *plistFilePathInDocumentsDirectoryNoteB = [documentsDirectoryPathNoteB stringByAppendingPathComponent:@"notebook.plist"];
    
    
    
    // Instantiate a modifiable dictionary and initialize it with the content of the plist file
    NSMutableDictionary *wordOfDayData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInDocumentsDirectory];
    
    NSMutableDictionary *notebookData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInDocumentsDirectoryNoteB];
    
    
    
    if (!wordOfDayData && !notebookData) {
        /*
         In this case, the myPoints.plist file does not exist in the documents directory.
         This will happen when the user launches the app for the very first time.
         Therefore, read the plist file from the main bundle to show the user some example favorite cities.
         
         Get the file path to the CountryCities.plist file in application's main bundle.
         */
        NSString *plistFilePathInMainBundle = [[NSBundle mainBundle] pathForResource:@"wordOfTheDay" ofType:@"plist"];
        
        NSString *plistFilePathInMainBundleNoteB = [[NSBundle mainBundle]pathForResource:@"notebook" ofType:@"plist"];
    
        // Instantiate a modifiable dictionary and initialize it with the content of the plist file in main bundle
        wordOfDayData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInMainBundle];
        
        notebookData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInMainBundleNoteB];
        
    }
    self.wordOfDayDict = wordOfDayData;
    self.notebookDict = notebookData;
    
    [self customizeAppearance];
    
    //Initalizing the different storyboard, based on the type of device
    //[self initializeStoryboardBasedOnScreenSize];
    
    return YES;

}
							
// Write the countryCities dictionary data structure to hard disk before the app becomes inactive
- (void)applicationWillResignActive:(UIApplication *)application
{
    
    NSLog(@"i'm writing ");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *documentsDirectoryPathNoteB = [paths objectAtIndex:0];
    
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"wordOfTheDay.plist"];
    
    NSString *plistFilePathInDocumentsDirectoryNoteB = [documentsDirectoryPathNoteB stringByAppendingPathComponent:@"notebook.plist"];
    
    [self.wordOfDayDict writeToFile:plistFilePathInDocumentsDirectory atomically:YES];
    [self.notebookDict writeToFile:plistFilePathInDocumentsDirectoryNoteB atomically:YES];
    
    /*
     The flag "atomically" specifies whether the file should be written atomically or not.
     
     If flag is YES, the countryCities dictionary is written to an auxiliary file, and then the auxiliary file is
     renamed to path plistFilePathInDocumentsDirectory
     
     If flag is NO, the countryCities dictionary is written directly to path plistFilePathInDocumentsDirectory.
     
     The YES option guarantees that the path will not be corrupted even if the system crashes during writing.
     */
}

/*******************************
 CUSTOMIZE APPEARANCE
 ******************************/

-(void)customizeAppearance {
    /******************************
     NavigationBar customization
     *****************************/
    
    
    // Obtain an object reference to the navigation bar background image
    UIImage *navBarImage = [UIImage imageNamed:@"nav-bar.png"];
    
    
    
    // Set the navigation bar background image
    [[UINavigationBar appearance] setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    
    //create a button image for generic use that can be resizable
    UIImage *barButton = [[UIImage imageNamed:@"bar-button1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    
    //set the button background image
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    
    // Create a back button image
    UIImage *backButton = [[UIImage imageNamed:@"back-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 6)];
    
    
    
    // Set the back button background image
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    /*
     
     For detailed information about how to "USER INTERFACE CUSTOMIZATION" in iOS please check the links at below
     
     http://developer.apple.com/library/ios/#documentation/uikit/reference/UIAppearance_Protocol/Reference/Reference.html
     http://mobileorchard.com/how-to-make-your-app-stand-out-with-the-new-ios-5-appearance-api/
     http://www.raywenderlich.com/4344/user-interface-customization-in-ios-5
     http://mobiledevelopertips.com/user-interface/ios-5-customize-uinavigationbar-and-uibarbuttonitem-with-appearance-api.html
     
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




@end
