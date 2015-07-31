//
//  ViewController.m
//  LoveCalculator
//
//  Created by Rahul on 7/29/15.
//  Copyright (c) 2015 Rahul. All rights reserved.
//

#import "ViewController.h"
#import "UNIRest.h"

@interface ViewController ()
{
    UIActivityIndicatorView * activity;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.frame = CGRectMake(142, 200, 50, 50);
    activity.center = self.percentage.center;
    [self.view addSubview:activity];
    self.calCulate.layer.cornerRadius = 8;
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)GetPercentage:(id)sender
{
    [activity startAnimating];
    __block NSString * getthis;
    NSDictionary *headers = @{@"X-Mashape-Key": @"rXWGEmuyq3mshblZphrmA85lD0TBp1rb9Qkjsndmkbm1uvcGmp", @"Accept": @"application/json"};
    UNIUrlConnection *asyncConnection = [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:[NSString stringWithFormat:@"https://love-calculator.p.mashape.com/getPercentage?fname=%@&sname=%@",self.firstName.text,self.secondName.text]];
        [request setHeaders:headers];
    }] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error) {
        NSError *jsonError;
        NSData *rawBody = response.rawBody;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:rawBody
                                                             options:kNilOptions
                                                               error:&jsonError];
        getthis = [NSString stringWithFormat:@"%@%% \n %@",[json objectForKey:@"percentage"],[json objectForKey:@"result"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            CATransition *transitionAnimation = [CATransition animation];
            [transitionAnimation setType:kCATransitionFade];
            [transitionAnimation setDuration:0.3f];
            [transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [transitionAnimation setFillMode:kCAFillModeBoth];
            [self.percentage.layer addAnimation:transitionAnimation forKey:@"fadeAnimation"];
            [self.percentage setText:getthis];
            [activity stopAnimating];
        });
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
     
@end


