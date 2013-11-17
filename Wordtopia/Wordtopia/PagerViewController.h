//
//  PagerViewController.h
//  testPageView
//
//  Created by Vincent Ngo on 12/14/12.
//  Copyright (c) 2012 Vincent Ngo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagerViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

- (IBAction)changePage:(id)sender;

@end
