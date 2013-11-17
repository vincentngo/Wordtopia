//
//  AppDelegate.h
//  Wordtopia
//
//  Created by Vincent Ngo on 11/19/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableDictionary *wordOfDayDict;

@property (strong, nonatomic) NSMutableDictionary *notebookDict;

@end
