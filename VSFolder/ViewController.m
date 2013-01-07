//
//  ViewController.m
//  VSFolder
//
//  Created by Manuel Meyer on 31.12.12.
//  Copyright (c) 2012 yourcompany. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *upperView;
@property (nonatomic, strong) UIView *lowerView;

@property (nonatomic, strong) UIImageView *upperImageView;
@property (nonatomic, strong) UIImageView *lowerImageView;

@property (nonatomic, strong) UIView *folderContentsView;

@property (nonatomic, assign) CGRect startRect;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage *bgImg = [UIImage imageNamed:@"bg.png"];
    self.upperImageView = [[UIImageView alloc] initWithImage:bgImg];
    self.lowerImageView = [[UIImageView alloc] initWithImage:bgImg];
    [self.upperImageView setContentMode:UIViewContentModeTop];
    [self.lowerImageView setContentMode:UIViewContentModeTop];
    
    self.upperView = [[UIView alloc] initWithFrame:self.upperImageView.frame];
    self.lowerView = [[UIView alloc] initWithFrame:self.lowerImageView.frame];
    [self.upperView addSubview:_upperImageView];
    [self.lowerView addSubview:_lowerImageView];
    
    [self.view addSubview:_lowerView];
    [self.view addSubview:_upperView];
    
    UITapGestureRecognizer *upperTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(openOverlay:)];
    UITapGestureRecognizer *lowerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(openOverlay:)];

    [self.upperView setUserInteractionEnabled:YES];
    [self.upperView addGestureRecognizer:upperTapRecognizer];
    [self.upperView setClipsToBounds:YES];
    
    [self.lowerView setUserInteractionEnabled:YES];
    [self.lowerView addGestureRecognizer:lowerTapRecognizer];
    [self.lowerView setClipsToBounds:YES];
    
    self.folderContentsView = [[UIView alloc] initWithFrame:CGRectZero];
    self.folderContentsView.backgroundColor = [UIColor redColor];
    UITapGestureRecognizer *closeTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(closeOverlay:)];
    [self.folderContentsView addGestureRecognizer:closeTapRecognizer];
    [self.view addSubview:self.folderContentsView];
    
    [self.folderContentsView addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgFolder.png"]]];
    [self.folderContentsView setClipsToBounds:YES];
    
    self.startRect = [self.upperView frame];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)openOverlay:(UITapGestureRecognizer *) sender
{
    [self.upperView setUserInteractionEnabled:NO];
    [self.lowerView setUserInteractionEnabled:NO];
    CGPoint location = [sender locationInView:sender.view];
    
    self.folderContentsView.frame = CGRectMake(0, location.y,
                                    _lowerView.frame.size.width, 0);
    self.lowerView.frame = CGRectMake(0, location.y,
                                      _lowerView.frame.size.width, _lowerView.frame.size.height);
    self.upperView.frame = CGRectMake(0, 0,
                                      _upperView.frame.size.width, location.y);
    self.lowerImageView.frame = CGRectMake(_lowerImageView.frame.origin.x, -location.y,
                                           _lowerImageView.frame.size.width, _lowerImageView.frame.size.height);
        
    [UIView animateWithDuration:.5 animations:^{
        self.folderContentsView.frame = CGRectMake(0, location.y,
                                    _lowerView.frame.size.width, 200);
        self.lowerView.frame = CGRectOffset(_lowerView.frame, 0, 200);
    }];    
}

-(void) closeOverlay:(UITapGestureRecognizer*) sender
{
    [UIView animateWithDuration:.5 animations:^{
        self.lowerView.frame = CGRectOffset(_lowerView.frame, 0, -200);
        self.folderContentsView.frame = CGRectMake(0, self.folderContentsView.frame.origin.y,
                                        self.folderContentsView.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [self.upperView setUserInteractionEnabled:YES];
        [self.lowerView setUserInteractionEnabled:YES];
        self.upperView.frame = self.startRect;
    }];
}


@end
