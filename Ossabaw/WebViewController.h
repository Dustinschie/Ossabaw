//
//  WebViewController.h
//  Ossabaw
//
//  Created by Dustin Schie on 4/11/14.
//  Copyright (c) 2014 Dustin Schie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
{
    UIWebView *webView;
}
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end
