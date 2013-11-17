//
//  ECSlidingViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//  Documented by Kyle Schutt on 10/1/2012
//

/*
 ## MIT License
 Copyright (C) 2012 EdgeCase
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#import "ECSlidingViewController.h"
/** Notification that gets posted when the underRight view will appear */
NSString *const ECSlidingViewUnderRightWillAppear = @"ECSlidingViewUnderRightWillAppear";
/** Notification that gets posted when the underLeft view will appear */
NSString *const ECSlidingViewUnderLeftWillAppear  = @"ECSlidingViewUnderLeftWillAppear";
/** Notification that gets posted when the top view is anchored to the left side of the screen */
NSString *const ECSlidingViewTopDidAnchorLeft     = @"ECSlidingViewTopDidAnchorLeft";
/** Notification that gets posted when the top view is anchored to the right side of the screen */
NSString *const ECSlidingViewTopDidAnchorRight    = @"ECSlidingViewTopDidAnchorRight";
NSString *const ECSlidingViewTopDidReset          = @"ECSlidingViewTopDidReset";
/** Notification that gets posted when the top view is centered on the screen */

@interface ECSlidingViewController()
// Holds a reference for the main view snapshot [used when anchoring]
// This is essentially a screen shot of the current TopView before sliding
@property (nonatomic, strong) UIView *topViewSnapshot;
// The initial horizonal position
@property (nonatomic, unsafe_unretained) CGFloat initialTouchPositionX;
// The initial horizontal position from center
@property (nonatomic, unsafe_unretained) CGFloat initialHoizontalCenter;
// Holds a reference to the pan gesture recognizer
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
// Holds a reference to the tap geasture
@property (nonatomic, strong) UITapGestureRecognizer *resetTapGesture;
// Flag for displaying the left View
@property (nonatomic, unsafe_unretained) BOOL underLeftShowing;
// Flag for displaying the right View
@property (nonatomic, unsafe_unretained) BOOL underRightShowing;
// Flag for when the top view has slid of the screen
@property (nonatomic, unsafe_unretained) BOOL topViewIsOffScreen;

- (NSUInteger)autoResizeToFillScreen;
- (UIView *)topView;
- (UIView *)underLeftView;
- (UIView *)underRightView;
- (void)adjustLayout;
- (void)updateTopViewHorizontalCenterWithRecognizer:(UIPanGestureRecognizer *)recognizer;
- (void)updateTopViewHorizontalCenter:(CGFloat)newHorizontalCenter;
- (void)topViewHorizontalCenterWillChange:(CGFloat)newHorizontalCenter;
- (void)topViewHorizontalCenterDidChange:(CGFloat)newHorizontalCenter;
- (void)addTopViewSnapshot;
- (void)removeTopViewSnapshot;
- (CGFloat)anchorRightTopViewCenter;
- (CGFloat)anchorLeftTopViewCenter;
- (CGFloat)resettedCenter;
- (CGFloat)screenWidth;
- (CGFloat)screenWidthForOrientation:(UIInterfaceOrientation)orientation;
- (void)underLeftWillAppear;
- (void)underRightWillAppear;
- (void)topDidReset;
- (BOOL)topViewHasFocus;
- (void)updateUnderLeftLayout;
- (void)updateUnderRightLayout;

@end

@implementation UIViewController(SlidingViewExtension)

// Fetches a reference to the sliding view controller from the parent view controller.
- (ECSlidingViewController *)slidingViewController
{
    UIViewController *viewController = self.parentViewController;
    while (!(viewController == nil || [viewController isKindOfClass:[ECSlidingViewController class]])) {
        viewController = viewController.parentViewController;
    }
    
    return (ECSlidingViewController *)viewController;
}

@end

@implementation ECSlidingViewController

// public properties [see header file for documentation about these properties]
@synthesize underLeftViewController  = _underLeftViewController;
@synthesize underRightViewController = _underRightViewController;
@synthesize topViewController        = _topViewController;
@synthesize anchorLeftPeekAmount;
@synthesize anchorRightPeekAmount;
@synthesize anchorLeftRevealAmount;
@synthesize anchorRightRevealAmount;
@synthesize underRightWidthLayout = _underRightWidthLayout;
@synthesize underLeftWidthLayout  = _underLeftWidthLayout;
@synthesize shouldAllowUserInteractionsWhenAnchored;
@synthesize resetStrategy = _resetStrategy;

// category properties [see interface definition for documentation]
@synthesize topViewSnapshot;
@synthesize initialTouchPositionX;
@synthesize initialHoizontalCenter;
@synthesize panGesture = _panGesture;
@synthesize resetTapGesture;
@synthesize underLeftShowing   = _underLeftShowing;
@synthesize underRightShowing  = _underRightShowing;
@synthesize topViewIsOffScreen = _topViewIsOffScreen;

// Assigns a new top view controller to the SlidingViewController
- (void)setTopViewController:(UIViewController *)theTopViewController
{
    [self removeTopViewSnapshot];
    // Remove the old TopView from the superview
    [_topViewController.view removeFromSuperview];
    [_topViewController willMoveToParentViewController:nil];
    [_topViewController removeFromParentViewController];
    
    _topViewController = theTopViewController;
    //  Add the TopView to our main view controller
    [self addChildViewController:self.topViewController];
    [self.topViewController didMoveToParentViewController:self];
    
    [_topViewController.view setAutoresizingMask:self.autoResizeToFillScreen];
    [_topViewController.view setFrame:self.view.bounds];
    _topViewController.view.layer.shadowOffset = CGSizeZero;
    _topViewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.layer.bounds].CGPath;
    //  Add the view of the new TopViewController
    [self.view addSubview:_topViewController.view];
}

// Sets the view that should be displayed when the TopView slides to the right
// I.e., when we display a view on the left side of the view
// The workflow is similar to adding a TopViewController
- (void)setUnderLeftViewController:(UIViewController *)theUnderLeftViewController
{
    [_underLeftViewController.view removeFromSuperview];
    [_underLeftViewController willMoveToParentViewController:nil];
    [_underLeftViewController removeFromParentViewController];
    
    _underLeftViewController = theUnderLeftViewController;
    
    if (_underLeftViewController) {
        [self addChildViewController:self.underLeftViewController];
        [self.underLeftViewController didMoveToParentViewController:self];
        
        [self updateUnderLeftLayout];
        
        [self.view insertSubview:_underLeftViewController.view atIndex:0];
    }
}

// Sets the view that should be displayed when the TopView slides to the left
// I.e., when we display a view on the right side of the view
// The workflow is similar to adding a TopViewController
- (void)setUnderRightViewController:(UIViewController *)theUnderRightViewController
{
    [_underRightViewController.view removeFromSuperview];
    [_underRightViewController willMoveToParentViewController:nil];
    [_underRightViewController removeFromParentViewController];
    
    _underRightViewController = theUnderRightViewController;
    
    if (_underRightViewController) {
        [self addChildViewController:self.underRightViewController];
        [self.underRightViewController didMoveToParentViewController:self];
        
        [self updateUnderRightLayout];
        
        [self.view insertSubview:_underRightViewController.view atIndex:0];
    }
}

// Set the total width of the layout on the left side
// This also sets the width of the view that will be shown when the TopView is moved
// to reveal the underLeft view
- (void)setUnderLeftWidthLayout:(ECViewWidthLayout)underLeftWidthLayout
{
    if (underLeftWidthLayout == ECVariableRevealWidth && self.anchorRightPeekAmount <= 0) {
        [NSException raise:@"Invalid Width Layout" format:@"anchorRightPeekAmount must be set"];
    } else if (underLeftWidthLayout == ECFixedRevealWidth && self.anchorRightRevealAmount <= 0) {
        [NSException raise:@"Invalid Width Layout" format:@"anchorRightRevealAmount must be set"];
    }
    
    _underLeftWidthLayout = underLeftWidthLayout;
}

// Similar to above but with respect to the underRight view
- (void)setUnderRightWidthLayout:(ECViewWidthLayout)underRightWidthLayout
{
    if (underRightWidthLayout == ECVariableRevealWidth && self.anchorLeftPeekAmount <= 0) {
        [NSException raise:@"Invalid Width Layout" format:@"anchorLeftPeekAmount must be set"];
    } else if (underRightWidthLayout == ECFixedRevealWidth && self.anchorLeftRevealAmount <= 0) {
        [NSException raise:@"Invalid Width Layout" format:@"anchorLeftRevealAmount must be set"];
    }
    
    _underRightWidthLayout = underRightWidthLayout;
}

// Initial the ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    //    Disabled all user interaction with the TopView when it is moved [anchored]
    self.shouldAllowUserInteractionsWhenAnchored = NO;
    //    The reset tap gesture brings the TopView back to fill the entire screen
    self.resetTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetTopView)];
    //    The gesture recognizer allows us to move the TopView in order to display the
    //    underLeft or underRight views [depending on swipe direction]
    _panGesture          = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(updateTopViewHorizontalCenterWithRecognizer:)];
    //    On start up we want to disable the tap gesture
    self.resetTapGesture.enabled = NO;
    //    Custom enumeration for determining the reset strategy
    //    This tells us how the TopView should respond when it is anchored
    self.resetStrategy = ECTapping | ECPanning;
    
    //    Creates a snapshot of the frame where we wish to hold the TopView
    self.topViewSnapshot = [[UIView alloc] initWithFrame:self.topView.bounds];
    [self.topViewSnapshot setAutoresizingMask:self.autoResizeToFillScreen];
    [self.topViewSnapshot addGestureRecognizer:self.resetTapGesture];
}

// Perform some actions when the view is about to appear
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    Shadow the edges to keep a clean interface between the TopView and underViews
    self.topView.layer.shadowOffset = CGSizeZero;
    //    Uses Quartz and UI to create a soft edge around the view
    self.topView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.layer.bounds].CGPath;
    [self adjustLayout];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //    Remove the shadow on rotation, we need to recreate it after the view is done rotating
    self.topView.layer.shadowPath = nil;
    self.topView.layer.shouldRasterize = YES;
    
    if(![self topViewHasFocus]){
        [self removeTopViewSnapshot];
    }
    
    //    Call to readjust the layout before the rotation action has finished
    [self adjustLayout];
}

// Method call when the view has finished rotating
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    //    Add the shadow effects that we removed during rotation.
    self.topView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.layer.bounds].CGPath;
    self.topView.layer.shouldRasterize = NO;
    
    if(![self topViewHasFocus]){
        [self addTopViewSnapshot];
    }
}

// Setter for the reset strategy [this shows how we can interact with the anchored view]
- (void)setResetStrategy:(ECResetStrategy)theResetStrategy
{
    _resetStrategy = theResetStrategy;
    //    Enables/disabled the tapping gesture based on the input
    if (_resetStrategy & ECTapping) {
        self.resetTapGesture.enabled = YES;
    } else {
        self.resetTapGesture.enabled = NO;
    }
}

// Call for adjusting the layout during device rotation
- (void)adjustLayout
{
    //    we taked a the current bounds from the TopView and assign it to the snapshot that we will maintain during rotation
    self.topViewSnapshot.frame = self.topView.bounds;
    
    //    Structure for updating the view that are currently displayed
    //    there are 4 different combinations between the TopView and each of the underViews
    if ([self underRightShowing] && ![self topViewIsOffScreen]) {
        [self updateUnderRightLayout];
        [self updateTopViewHorizontalCenter:self.anchorLeftTopViewCenter];
    } else if ([self underRightShowing] && [self topViewIsOffScreen]) {
        [self updateUnderRightLayout];
        [self updateTopViewHorizontalCenter:-self.resettedCenter];
    } else if ([self underLeftShowing] && ![self topViewIsOffScreen]) {
        [self updateUnderLeftLayout];
        [self updateTopViewHorizontalCenter:self.anchorRightTopViewCenter];
    } else if ([self underLeftShowing] && [self topViewIsOffScreen]) {
        [self updateUnderLeftLayout];
        [self updateTopViewHorizontalCenter:self.screenWidth + self.resettedCenter];
    }
}

// method for updating the horizontal position of the TopView based on the actions of the Pan Gesture Recognizer
// Because this is a horizontal motion only, we will focus on the X direction only
- (void)updateTopViewHorizontalCenterWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
    //    Fetch our current position from the gesture
    CGPoint currentTouchPoint     = [recognizer locationInView:self.view];
    CGFloat currentTouchPositionX = currentTouchPoint.x;
    //  Check the state of the recognizer
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //      Set the initial position of the horizontal center that will be moved
        self.initialTouchPositionX = currentTouchPositionX;
        self.initialHoizontalCenter = self.topView.center.x;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        //      React to a state change by determining the change in X position of the pan gesture
        CGFloat panAmount = self.initialTouchPositionX - currentTouchPositionX;
        CGFloat newCenterPosition = self.initialHoizontalCenter - panAmount;
        
        //      Depending on how far the view is moved we can either anchor the TopView to thr right or left side of the screen
        //      If the pan amount is not more [or less] then the reset center for a particular underView [e.g., the center of the screen] then we will bring the TopView back into focus
        if ((newCenterPosition < self.resettedCenter && self.anchorLeftTopViewCenter == NSNotFound) || (newCenterPosition > self.resettedCenter && self.anchorRightTopViewCenter == NSNotFound)) {
            newCenterPosition = self.resettedCenter;
        }
        
        //      Notify ourselves that the center is changing
        [self topViewHorizontalCenterWillChange:newCenterPosition];
        //      Change the center
        [self updateTopViewHorizontalCenter:newCenterPosition];
        //      Notify users that the center has changed
        [self topViewHorizontalCenterDidChange:newCenterPosition];
    } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        //      If the gesture has ended or cancelled we want to check on the velocity of the motion that ended
        CGPoint currentVelocityPoint = [recognizer velocityInView:self.view];
        CGFloat currentVelocityX     = currentVelocityPoint.x;
        
        //      if the velocity of the pan motion exceed 100 [points per second] then either display the underLeft or underRight [depending on the velocity]
        if ([self underLeftShowing] && currentVelocityX > 100) {
            [self anchorTopViewTo:ECRight];
        } else if ([self underRightShowing] && currentVelocityX < 100) {
            [self anchorTopViewTo:ECLeft];
        } else {
            //        If neither were matched, then we can simply reset the top view
            [self resetTopView];
        }
    }
}

// Getter method for the pan gesture
- (UIPanGestureRecognizer *)panGesture
{
    return _panGesture;
}

// Polymorphic method for anchoring the top view
- (void)anchorTopViewTo:(ECSide)side
{
    [self anchorTopViewTo:side animations:nil onComplete:nil];
}

// Method for anchoring the top view to one side of the screen with named parameters to anonymous methods
- (void)anchorTopViewTo:(ECSide)side animations:(void (^)())animations onComplete:(void (^)())complete
{
    //    Get the current center
    CGFloat newCenter = self.topView.center.x;
    //  If we are assigned a specfic side, we will fetch the anchor values for that side
    if (side == ECLeft) {
        newCenter = self.anchorLeftTopViewCenter;
    } else if (side == ECRight) {
        newCenter = self.anchorRightTopViewCenter;
    }
    //    Notify ourselves that the view is about to change and be anchored to one side of the screen
    [self topViewHorizontalCenterWillChange:newCenter];
    //  Generate an animation to enabled smooth transition between views
    [UIView animateWithDuration:0.25f animations:^{
        // call our passed in animations method
        if (animations) {
            animations();
        }
        // update the view to the new center
        [self updateTopViewHorizontalCenter:newCenter];
    } completion:^(BOOL finished){
        // set up the pan gesture based on the reset strategy
        if (_resetStrategy & ECPanning) {
            self.panGesture.enabled = YES;
        } else {
            self.panGesture.enabled = NO;
        }
        // call the passed in complete method
        if (complete) {
            complete();
        }
        _topViewIsOffScreen = NO;
        // add a snapshot of the TopView
        [self addTopViewSnapshot];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *key = (side == ECLeft) ? ECSlidingViewTopDidAnchorLeft : ECSlidingViewTopDidAnchorRight;
            // Notify the application of the anchor slide
            [[NSNotificationCenter defaultCenter] postNotificationName:key object:self userInfo:nil];
        });
    }];
}

// Slides the TopView completely off screen
- (void)anchorTopViewOffScreenTo:(ECSide)side
{
    [self anchorTopViewOffScreenTo:side animations:nil onComplete:nil];
}

// Similar to achorTopViewTo except the view is completely off screen
- (void)anchorTopViewOffScreenTo:(ECSide)side animations:(void(^)())animations onComplete:(void(^)())complete
{
    CGFloat newCenter = self.topView.center.x;
    
    if (side == ECLeft) {
        newCenter = -self.resettedCenter;
    } else if (side == ECRight) {
        newCenter = self.screenWidth + self.resettedCenter;
    }
    
    [self topViewHorizontalCenterWillChange:newCenter];
    
    [UIView animateWithDuration:0.25f animations:^{
        if (animations) {
            animations();
        }
        [self updateTopViewHorizontalCenter:newCenter];
    } completion:^(BOOL finished){
        if (complete) {
            complete();
        }
        _topViewIsOffScreen = YES;
        [self addTopViewSnapshot];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *key = (side == ECLeft) ? ECSlidingViewTopDidAnchorLeft : ECSlidingViewTopDidAnchorRight;
            [[NSNotificationCenter defaultCenter] postNotificationName:key object:self userInfo:nil];
        });
    }];
}

- (void)resetTopView
{
    [self resetTopViewWithAnimations:nil onComplete:nil];
}

// Moved the anchored TopView back to the center of the screen
- (void)resetTopViewWithAnimations:(void(^)())animations onComplete:(void(^)())complete
{
    [self topViewHorizontalCenterWillChange:self.resettedCenter];
    
    [UIView animateWithDuration:0.25f animations:^{
        if (animations) {
            animations();
        }
        [self updateTopViewHorizontalCenter:self.resettedCenter];
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
        [self topViewHorizontalCenterDidChange:self.resettedCenter];
    }];
}

// set up the auto resize function
- (NSUInteger)autoResizeToFillScreen
{
    return (UIViewAutoresizingFlexibleWidth |
            UIViewAutoresizingFlexibleHeight |
            UIViewAutoresizingFlexibleTopMargin |
            UIViewAutoresizingFlexibleBottomMargin |
            UIViewAutoresizingFlexibleLeftMargin |
            UIViewAutoresizingFlexibleRightMargin);
}

// topView accessor
- (UIView *)topView
{
    return self.topViewController.view;
}
// underLeft accessor
- (UIView *)underLeftView
{
    return self.underLeftViewController.view;
}

// underRight accessor
- (UIView *)underRightView
{
    return self.underRightViewController.view;
}

// on update, change the new horizontal position of the topView
// used when animating the opening and closing of the TopView
- (void)updateTopViewHorizontalCenter:(CGFloat)newHorizontalCenter
{
    CGPoint center = self.topView.center;
    center.x = newHorizontalCenter;
    self.topView.layer.position = center;
}

// Set up the Will CHange based and notify our underView which side is going to show up
- (void)topViewHorizontalCenterWillChange:(CGFloat)newHorizontalCenter
{
    CGPoint center = self.topView.center;
    
    if (center.x <= self.resettedCenter && newHorizontalCenter > self.resettedCenter) {
        // the center of the TopView is less then the reset and the newHorizontal center is greater than the center so the underLeft view will be shown
        [self underLeftWillAppear];
    } else if (center.x >= self.resettedCenter && newHorizontalCenter < self.resettedCenter) {
        // the opposite of above
        [self underRightWillAppear];
    }
}

// Called once the center has been successfully changed
- (void)topViewHorizontalCenterDidChange:(CGFloat)newHorizontalCenter
{
    // if the horizontal center is the same as the reset center
    if (newHorizontalCenter == self.resettedCenter) {
        // Notify that the topView is back in its original position
        [self topDidReset];
    }
}

// take a snapshot of the topView to be used while anchored. this is an easy way to prevent user interaction with
- (void)addTopViewSnapshot
{
    if (!self.topViewSnapshot.superview && !self.shouldAllowUserInteractionsWhenAnchored) {
//        topViewSnapshot.layer.contents = (id)[UIImage imageWithUIView:self.topView].CGImage;
        [self.topView addSubview:self.topViewSnapshot];
    }
}

// remove ths snapshot image
- (void)removeTopViewSnapshot
{
    if (self.topViewSnapshot.superview) {
        [self.topViewSnapshot removeFromSuperview];
    }
}

// moves the topView to the right of the screen based on the user provided peek amounts [if set] or the reveal amount
- (CGFloat)anchorRightTopViewCenter
{
    if (self.anchorRightPeekAmount) {
        return self.screenWidth + self.resettedCenter - self.anchorRightPeekAmount;
    } else if (self.anchorRightRevealAmount) {
        return self.resettedCenter + self.anchorRightRevealAmount;
    } else {
        return NSNotFound;
    }
}

// same as above but for the left side
- (CGFloat)anchorLeftTopViewCenter
{
    if (self.anchorLeftPeekAmount) {
        return -self.resettedCenter + self.anchorLeftPeekAmount;
    } else if (self.anchorLeftRevealAmount) {
        return -self.resettedCenter + (self.screenWidth - self.anchorLeftRevealAmount);
    } else {
        return NSNotFound;
    }
}

// get the center of the screen in the X-direction [width, horizontal, etc.]
- (CGFloat)resettedCenter
{
    return ceil(self.screenWidth / 2);
}

// get the screen width for the current orientation [based on a reference to the status bar]
- (CGFloat)screenWidth
{
    return [self screenWidthForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

// go out to the main screen and get the orienttion direction
- (CGFloat)screenWidthForOrientation:(UIInterfaceOrientation)orientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    // check if it is in landscape [if so, reverse the X and Y]
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    // make sure the height is updated based on whether the status bar exists or not
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size.width;
}

// prepare to display the underLeft view
- (void)underLeftWillAppear
{
    // send out a notification
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ECSlidingViewUnderLeftWillAppear object:self userInfo:nil];
    });
    // hide the right view
    self.underRightView.hidden = YES;
    // notifies the view that it is about to be displayed [does not animate]
    [self.underLeftViewController viewWillAppear:NO];
    // show the left view
    self.underLeftView.hidden = NO;
    // update the layout
    [self updateUnderLeftLayout];
    // set our flags for the underView
    _underLeftShowing  = YES;
    _underRightShowing = NO;
}

// same as above but reverse for underRight
- (void)underRightWillAppear
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ECSlidingViewUnderRightWillAppear object:self userInfo:nil];
    });
    self.underLeftView.hidden = YES;
    [self.underRightViewController viewWillAppear:NO];
    self.underRightView.hidden = NO;
    [self updateUnderRightLayout];
    _underLeftShowing  = NO;
    _underRightShowing = YES;
}

// method for resetting the view notification
- (void)topDidReset
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ECSlidingViewTopDidReset object:self userInfo:nil];
    });
    // remove the gesture
    [self.topView removeGestureRecognizer:self.resetTapGesture];
    // remove the snapshot
    [self removeTopViewSnapshot];
    // enable the pan gesture
    self.panGesture.enabled = YES;
    // set the appropriate flags for our views
    _underLeftShowing   = NO;
    _underRightShowing  = NO;
    _topViewIsOffScreen = NO;
}

// check if the topView has the main focus by looking at our flags
- (BOOL)topViewHasFocus
{
    return !_underLeftShowing && !_underRightShowing && !_topViewIsOffScreen;
}

- (void)updateUnderLeftLayout
{
    // updated the width based on the flags
    if (self.underLeftWidthLayout == ECFullWidth) {
        // show the view completely on the main screen
        [self.underLeftView setAutoresizingMask:self.autoResizeToFillScreen];
        [self.underLeftView setFrame:self.view.bounds];
    } else if (self.underLeftWidthLayout == ECVariableRevealWidth && !self.topViewIsOffScreen) {
        // mainly used for changed widths [i.e., rotating the device]
        // set the width of the view to a specific user determined value
        CGRect frame = self.view.bounds;
        CGFloat newWidth;
        // needs to be updated based on the status bar in landscape mode
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            newWidth = [UIScreen mainScreen].bounds.size.height - self.anchorRightPeekAmount;
        } else {
            newWidth = [UIScreen mainScreen].bounds.size.width - self.anchorRightPeekAmount;
        }
        // set the frame  for the view
        frame.size.width = newWidth;
        
        self.underLeftView.frame = frame;
    } else if (self.underLeftWidthLayout == ECFixedRevealWidth) {
        // set up the frame 
        CGRect frame = self.view.bounds;
        
        frame.size.width = self.anchorRightRevealAmount;
        self.underLeftView.frame = frame;
    } else {
        // something went terribly wrong with our system
        [NSException raise:@"Invalid Width Layout" format:@"underLeftWidthLayout must be a valid ECViewWidthLayout"];
    }
}

// same thing for the underRightView as the underLeft
- (void)updateUnderRightLayout
{
    if (self.underRightWidthLayout == ECFullWidth) {
        [self.underRightViewController.view setAutoresizingMask:self.autoResizeToFillScreen];
        self.underRightView.frame = self.view.bounds;
    } else if (self.underRightWidthLayout == ECVariableRevealWidth) {
        CGRect frame = self.view.bounds;
        
        CGFloat newLeftEdge;
        CGFloat newWidth;
        
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            newWidth = [UIScreen mainScreen].bounds.size.height;
        } else {
            newWidth = [UIScreen mainScreen].bounds.size.width;
        }
        
        if (self.topViewIsOffScreen) {
            newLeftEdge = 0;
        } else {
            newLeftEdge = self.anchorLeftPeekAmount;
            newWidth   -= self.anchorLeftPeekAmount;
        }
        
        frame.origin.x   = newLeftEdge;
        frame.size.width = newWidth;
        
        self.underRightView.frame = frame;
    } else if (self.underRightWidthLayout == ECFixedRevealWidth) {
        CGRect frame = self.view.bounds;
        
        CGFloat newLeftEdge = self.screenWidth - self.anchorLeftRevealAmount;
        CGFloat newWidth = self.anchorLeftRevealAmount;
        
        frame.origin.x   = newLeftEdge;
        frame.size.width = newWidth;
        
        self.underRightView.frame = frame;
    } else {
        [NSException raise:@"Invalid Width Layout" format:@"underRightWidthLayout must be a valid ECViewWidthLayout"];
    }
}

@end
