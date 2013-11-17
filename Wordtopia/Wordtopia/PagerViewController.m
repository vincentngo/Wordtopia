//
//  PagerViewController.m
//  This is a class made by Tom Fewster, using PageControl with UIScrollView.
//
//Created by Tom Fewster on 11/01/2012.
//

#import "PagerViewController.h"

@interface PagerViewController ()

@property (assign) BOOL pageControlUsed;
@property (assign) NSUInteger page;
@property (assign) BOOL rotating;
- (void)loadScrollViewWithPage:(int)page;

@end

@implementation PagerViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setPagingEnabled:YES];
	[self.scrollView setScrollEnabled:YES];
	[self.scrollView setShowsHorizontalScrollIndicator:NO];
	[self.scrollView setShowsVerticalScrollIndicator:NO];
	[self.scrollView setDelegate:self];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - View Appearance

/*
 * So the four methods below does the following.
 * automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers handles
 * information where the UIViewController can control the rotation calls of the
 * view. By stating NO meaning you will rotate the UIviews yourself.
 */
- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers {
	return NO;
}

//Three methods below. When the pager view comes in to the view. We need to signal the current active child view controller that it is visible.


- (void)viewDidAppear:(BOOL)animated {
    //Notifies the view that it has been added to the stack.
	[super viewDidAppear:animated];
    
    //Creatings a UIViewController represent, and grabs a view from the array.
    
    //self.childViewController is basically an array that stores all the views.
    //The objectAtIndex value will be the current page the pageControl is on.
	UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
    
    //
	if (viewController.view.superview != nil) {
		[viewController viewDidAppear:animated];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
	if (viewController.view.superview != nil) {
		[viewController viewWillDisappear:animated];
	}
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
	if (viewController.view.superview != nil) {
		[viewController viewDidDisappear:animated];
	}
	[super viewDidDisappear:animated];
}



- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
	for (NSUInteger i =0; i < [self.childViewControllers count]; i++) {
		[self loadScrollViewWithPage:i];
	}
    
    //Sets the current page to zero
	self.pageControl.currentPage = 0;
    self.page = 0;
	//_page = 0;
    
    //Sets the number of pages (number of dots indicated in the view)
	[self.pageControl setNumberOfPages:[self.childViewControllers count]];
    
    //Well you have to load the first view controller to the screen, so its
    //going to load the first view. Which is at page = 0;
	UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
    
	if (viewController.view.superview != nil) {
		[viewController viewWillAppear:animated];
	}
    
    //Its going to make the scrollView's width size to be really long. So basically
    //Your going to have views that are outside the boundaries of the iPhone
    //E.g. [iPhoneScreen][view][view][view]
    //Your multiplying it by array size, to make room for however many views.
    //The height will stay the same... because we are not scrolling north south.. just east west...
    //Making the scrollview big enough to accomadate al these views.
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * [self.childViewControllers count], self.scrollView.frame.size.height);
}

//To load the content of the UIViewController into the UIScrollView,
- (void)loadScrollViewWithPage:(int)page {
    
    //Conditions. Just to be safe, page < 0 doesn't make sense because
    //Page starts from 0 to childViewController count... So we return nothing.
    if (page < 0)
        return;
    
    //If page is greater than the array return nothing....
    if (page >= [self.childViewControllers count])
        return;
    
	// replace the placeholder if necessary
    UIViewController *controller = [self.childViewControllers objectAtIndex:page];
    if (controller == nil) {
		return;
    }
    
	// add the controller's view to the scroll view
    if (controller.view.superview == nil) {
        
        //Create a frame based on scrollView's own frame.
        CGRect frame = self.scrollView.frame;
        //change the origin for frame to be multiplied by a page, depending on page 0 1 2 or 3....
        frame.origin.x = frame.size.width * page;
        
        //y axis does not change at all
        frame.origin.y = 0;
        //Set's the controller's frame
        controller.view.frame = frame;
        
        //We are going to add the controller in the scrollview... at that position.
        //Which is probably off the screen somewhere... on the right....
        [self.scrollView addSubview:controller.view];
    }
    
    
}


//Don't really follow the code below....


// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControlUsed = NO;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
    UIViewController *newViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
    [oldViewController viewDidDisappear:YES];
    [newViewController viewDidAppear:YES];
    
    _page = self.pageControl.currentPage;
}


- (IBAction)changePage:(id)sender {
    int page = ((UIPageControl *)sender).currentPage;
    
    // update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    
    UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
    UIViewController *newViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
    [oldViewController viewWillDisappear:YES];
    [newViewController viewWillAppear:YES];
    
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    _pageControlUsed = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (_pageControlUsed || _rotating) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (self.pageControl.currentPage != page) {
        UIViewController *oldViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
        UIViewController *newViewController = [self.childViewControllers objectAtIndex:page];
        [oldViewController viewWillDisappear:YES];
        [newViewController viewWillAppear:YES];
        self.pageControl.currentPage = page;
        [oldViewController viewDidDisappear:YES];
        [newViewController viewDidAppear:YES];
        _page = page;
    }
}



@end
