/*****************************************************************************
 *
 * FILE:	MWXInfiniteScrollView.h
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
 * $Id: MWXInfiniteScrollView.h,v 1.2 2011/11/03 17:14:24 kouichi Exp $
 *
 *****************************************************************************/

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol MWXInfiniteScrollViewDelegate;

@interface MWXInfiniteScrollView : UIView <UIScrollViewDelegate>
{
@private
  id <MWXInfiniteScrollViewDelegate>	_delegate;

  UIScrollView *	_scrollView;
  UIView *		_previousView;
  UIView *		_currentView;
  UIView *		_nextView;
}

@property (nonatomic,assign) id <MWXInfiniteScrollViewDelegate>	delegate;

-(void)setFirstView:(UIView *)view;	// set current view at start

-(UIView *)presentView;

@end

@protocol MWXInfiniteScrollViewDelegate <NSObject>
@required
-(UIView *)infiniteScrollView:(MWXInfiniteScrollView *)scrollView previousViewForView:(UIView *)view;
-(UIView *)infiniteScrollView:(MWXInfiniteScrollView *)scrollView nextViewForView:(UIView *)view;
@optional
-(void)infiniteScrollView:(MWXInfiniteScrollView *)scrollView didChangeView:(UIView *)view;
@end
