/*****************************************************************************
 *
 * FILE:	MWXInfiniteScrollView.m
 * DESCRIPTION:	MagickWorX: Infinite scroll view class
 * DATE:	Sat, Oct 29 2011
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
 * $Id: MWXInfiniteScrollView.m,v 1.2 2011/11/03 17:14:24 kouichi Exp $
 *
 *****************************************************************************/

#import <QuartzCore/QuartzCore.h>
#import "MWXInfiniteScrollView.h"

enum {
  kPagePrevious,
  kPageCurrent,
  kPageNext,
  kNumberOfPages
};

@interface MWXInfiniteScrollView ()
@property (nonatomic,retain) UIScrollView *	scrollView;
@property (nonatomic,retain) UIView *		previousView;
@property (nonatomic,retain) UIView *		currentView;
@property (nonatomic,retain) UIView *		nextView;
@end

@interface MWXInfiniteScrollView (Private)
-(void)adjustViewFrame;
-(void)didShowPreviousPage;
-(void)didShowNextPage;
@end

@implementation MWXInfiniteScrollView

@synthesize	delegate	= _delegate;
@synthesize	scrollView	= _scrollView;
@synthesize	previousView	= _previousView;
@synthesize	currentView	= _currentView;
@synthesize	nextView	= _nextView;

-(id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self != nil) {
    [self setDelegate:nil];
    [self setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];

    CGFloat	x = 0.0;
    CGFloat	y = 0.0;
    CGFloat	w = frame.size.width;
    CGFloat	h = frame.size.height;

    UIScrollView *	scrollView;
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    scrollView.delegate	= self;
    scrollView.bounces	= NO;
    scrollView.pagingEnabled	= YES;
    scrollView.contentOffset	= CGPointMake(w, y);
    scrollView.contentSize	= CGSizeMake(w * 3.0, h);
    scrollView.showsHorizontalScrollIndicator	= NO;
    scrollView.showsVerticalScrollIndicator	= NO;
    scrollView.scrollsToTop	= NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    [scrollView release];

    UIView *	view;
    view = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [view setBackgroundColor:[UIColor redColor]];
    [self.scrollView addSubview:view];
    self.previousView = view;
    [view release];

    x += w;
    view = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [view setBackgroundColor:[UIColor greenColor]];
    [self.scrollView addSubview:view];
    self.currentView = view;
    [view release];

    x += w;
    view = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [view setBackgroundColor:[UIColor blueColor]];
    [self.scrollView addSubview:view];
    self.nextView = view;
    [view release];
  }
  return self;
}

-(void)dealloc
{
  [_scrollView release];
  [_previousView release];
  [_currentView release];
  [_nextView release];
  [super dealloc];
}

/*****************************************************************************/

-(void)fetchPreviousView
{
  if (_delegate &&
      [_delegate respondsToSelector:@selector(infiniteScrollView:previousViewForView:)]) {
    UIView *	view;
    view = [_delegate infiniteScrollView:self
		      previousViewForView:self.currentView];
    if (view != nil) {
      CGRect	frame = self.previousView.frame;

      [self.previousView removeFromSuperview];
      [self.scrollView addSubview:view];
      [view setFrame:frame];
      self.previousView = view;
    }
  }
}

-(void)fetchNextView
{
  if (_delegate &&
      [_delegate respondsToSelector:@selector(infiniteScrollView:nextViewForView:)]) {
    UIView *	view;
    view = [_delegate infiniteScrollView:self nextViewForView:self.currentView];
    if (view != nil) {
      CGRect	frame = self.nextView.frame;

      [self.nextView removeFromSuperview];
      [self.scrollView addSubview:view];
      [view setFrame:frame];
      self.nextView = view;
    }
  }
}

-(void)setFirstView:(UIView *)view
{
  if (view != nil) {
    CGRect	frame = self.currentView.frame;

    [self.currentView removeFromSuperview];
    [self.scrollView addSubview:view];
    [view setFrame:frame];
    self.currentView = view;

    [self fetchPreviousView];
    [self fetchNextView];

    [self setNeedsDisplay];
  }
}

-(UIView *)presentView
{
  return self.currentView;
}

/*****************************************************************************/

-(void)adjustViewFrame
{
  CGFloat	width	= self.scrollView.frame.size.width;
  CGFloat	height	= self.scrollView.frame.size.height;

  CGFloat	x = 0.0;
  CGFloat	y = 0.0;
  CGFloat	w = width;
  CGFloat	h = height;
  self.previousView.frame = CGRectMake(x, y, w, h); x += w;
  self.currentView.frame  = CGRectMake(x, y, w, h); x += w;
  self.nextView.frame	  = CGRectMake(x, y, w, h);

  [self.scrollView setContentOffset:CGPointMake(width, 0.0) animated:NO];
}

-(void)didShowPreviousPage
{
  UIView *	tmpView	= self.nextView;
  self.nextView		= self.currentView;
  self.currentView	= self.previousView;
  self.previousView	= tmpView;

  [self adjustViewFrame];

  [self fetchPreviousView];
}

-(void)didShowNextPage
{
  UIView *	tmpView	= self.previousView;
  self.previousView	= self.currentView;
  self.currentView	= self.nextView;
  self.nextView		= tmpView;

  [self adjustViewFrame];

  [self fetchNextView];
}

/*****************************************************************************/

#pragma mark UIScrollViewDelegate
// called when scroll view grinds to a halt
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  CGFloat	width	= scrollView.frame.size.width;
  NSInteger	page	= (NSInteger)floorf((scrollView.contentOffset.x - width * 0.5) / width) + 1;

  switch (page) {
    case kPagePrevious:	[self didShowPreviousPage]; break;
    case kPageNext:	[self didShowNextPage];	    break;
    default: break;
  }

  if (_delegate &&
      [_delegate respondsToSelector:@selector(infiniteScrollView:didChangeView:)]) {
    [_delegate infiniteScrollView:self didChangeView:self.currentView];
  }
}

@end
