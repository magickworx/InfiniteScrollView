/*****************************************************************************
 *
 * FILE:	ExampleViewController.m
 * DESCRIPTION:	InfiniteScrollView: Example view controller
 * DATE:	Thu, Dec  8 2011
 * UPDATED:	Fri, Dec  9 2011
 * AUTHOR:	Kouichi ABE (WALL) / 阿部康一
 * E-MAIL:	kouichi@MagickWorX.COM
 * URL:		http://www.MagickWorX.COM/
 * COPYRIGHT:	(c) 2011 阿部康一／Kouichi ABE (WALL), All rights reserved.
 * LICENSE:
 *
 *  Copyright (c) 2011 Kouichi ABE (WALL) <kouichi@MagickWorX.COM>,
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *
 *   1. Redistributions of source code must retain the above copyright
 *      notice, this list of conditions and the following disclaimer.
 *
 *   2. Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *
 *   THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 *   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 *   THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 *   PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
 *   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 *   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 *   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 *   INTERRUPTION)  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 *   THE POSSIBILITY OF SUCH DAMAGE.
 *
 * $Id: ExampleViewController.m,v 1.5 2011/10/20 17:20:33 kouichi Exp $
 *
 *****************************************************************************/

#import "ExampleViewController.h"

@interface ExampleViewController ()
@property (nonatomic,retain) NSArray *	views;
@end

@implementation ExampleViewController

@synthesize	views	= _views;

-(id)init
{
  self = [super init];
  if (self != nil) {
    self.title	= NSLocalizedString(@"Demo", @"");
  }
  return self;
}

-(void)dealloc
{
  self.views = nil;
  [super dealloc];
}

-(void)didReceiveMemoryWarning
{
  /*
   * Invoke super's implementation to do the Right Thing,
   * but also release the input controller since we can do that.
   * In practice this is unlikely to be used in this application,
   * and it would be of little benefit,
   * but the principle is the important thing.
   */
  [super didReceiveMemoryWarning];
}

/*
 * Automatically invoked after -loadView
 * This is the preferred override point for doing additional setup
 * after -initWithNibName:bundle:
 */
-(void)viewDidLoad
{
  [super viewDidLoad];

  NSArray *	colors = [NSArray arrayWithObjects:
				[UIColor redColor],
				[UIColor greenColor],
				[UIColor blueColor],
				[UIColor cyanColor],
				[UIColor yellowColor],
				[UIColor magentaColor],
				[UIColor orangeColor],
				[UIColor purpleColor],
				[UIColor brownColor],
				[UIColor grayColor],
				[UIColor whiteColor],
				nil];
  NSMutableArray *	views = [[NSMutableArray alloc] init];
  UIView *	view;
  NSInteger	count = [colors count];
  for (NSInteger i = 0; i < count; i++) {
    view = [[UIView alloc] initWithFrame:self.view.bounds];
    [view setTag:i];
    [view setBackgroundColor:[colors objectAtIndex:i]];
    [views addObject:view];
    [view release];
  }
  self.views = views;
  [views release];

  MWXInfiniteScrollView *	scrollView;
  scrollView = [[MWXInfiniteScrollView alloc] initWithFrame:self.view.bounds];
  [scrollView setDelegate:self];
  [self.view addSubview:scrollView];
  [scrollView setFirstView:[views objectAtIndex:0]];
  [scrollView release];
}

-(void)viewDidUnload
{
  self.views = nil;
  [super viewDidUnload];
}

/*****************************************************************************/

#pragma mark MWXInfiniteScrollViewDelegate
-(UIView *)infiniteScrollView:(MWXInfiniteScrollView *)scrollView
	previousViewForView:(UIView *)view
{
  NSInteger	pos = [view tag];
  NSInteger	end = self.views.count - 1;

  if (--pos < 0) { pos = end; }

  return [self.views objectAtIndex:pos];
}

#pragma mark MWXInfiniteScrollViewDelegate
-(UIView *)infiniteScrollView:(MWXInfiniteScrollView *)scrollView
	nextViewForView:(UIView *)view
{
  NSInteger	pos = [view tag];
  NSInteger	end = self.views.count - 1;

  if (++pos > end) { pos = 0; }

  return [self.views objectAtIndex:pos];
}

@end
