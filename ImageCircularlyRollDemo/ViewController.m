//
//  ViewController.m
//  ImageCircularlyRollDemo
//
//  Created by mac on 16/6/20.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define IMAGEVIEW_COUNT 3

@interface ViewController ()<UIScrollViewDelegate>
{
    UIScrollView *scrollView_;
    UIImageView *leftImageView_;
    UIImageView *centerImageView_;
    UIImageView *rightImageView_;
    UIPageControl *pageControl_;
    UILabel *infoLabel_;
    NSMutableDictionary *imageData_;
    NSInteger imageCount_;
    NSInteger currentImageIndex_;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadImageData];
    [self addScrollView];
    [self addImageViews];
    [self setDefaultImage];
    [self addPageControl];
    [self addLabel];
}

- (void)loadImageData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"imageInfo" ofType:@"plist"];
    imageData_ = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    imageCount_ = imageData_.count;
}

- (void)addScrollView
{
    scrollView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:scrollView_];
    
    scrollView_.showsVerticalScrollIndicator = NO;
    scrollView_.showsHorizontalScrollIndicator = NO;
    scrollView_.delegate = self;
    scrollView_.contentSize = CGSizeMake(IMAGEVIEW_COUNT * SCREEN_WIDTH, SCREEN_HEIGHT);
    scrollView_.pagingEnabled = YES;
    scrollView_.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
}

//添加图片三个控件
- (void)addImageViews
{
    leftImageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    leftImageView_.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView_ addSubview:leftImageView_];
    
    centerImageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    centerImageView_.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView_ addSubview:centerImageView_];
    
    rightImageView_ = [[UIImageView alloc] initWithFrame:CGRectMake(2 * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    rightImageView_.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView_ addSubview:rightImageView_];
}

//设置默认显示图片
- (void)setDefaultImage
{
    leftImageView_.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", imageCount_ - 1]];
    centerImageView_.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", 0]];
    rightImageView_.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", 1]];
    currentImageIndex_ = 0;
    pageControl_.currentPage = currentImageIndex_;
    NSString *imageName = [NSString stringWithFormat:@"%ld.jpg", (long)currentImageIndex_];
    infoLabel_.text = imageData_[imageName];
}

- (void)addPageControl
{
    pageControl_ = [[UIPageControl alloc] init];
    CGSize size = [pageControl_ sizeForNumberOfPages:imageCount_];
    pageControl_.bounds = CGRectMake(0, 0, size.width, size.height);
    pageControl_.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 100);
    pageControl_.pageIndicatorTintColor = [UIColor colorWithRed:193 / 255.0 green:219 / 255.0 blue:249 / 255.0 alpha:1];
    pageControl_.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:150 / 255.0 blue:1 alpha:1];
    pageControl_.numberOfPages = imageCount_;
    [self.view addSubview:pageControl_];
}

//添加信息描述控件
- (void)addLabel
{
    infoLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 30)];
    infoLabel_.textAlignment = NSTextAlignmentCenter;
    infoLabel_.textColor = [UIColor colorWithRed:0 green:150 / 255.0 blue:1 alpha:1];
    [self.view addSubview:infoLabel_];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //重新加载图片
    [self reloadImage];
    [scrollView_ setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    pageControl_.currentPage = currentImageIndex_;
    NSString *imageName = [NSString stringWithFormat:@"%ld.jpg", (long)currentImageIndex_];
    infoLabel_.text = imageData_[imageName];
}

- (void)reloadImage
{
    NSInteger leftImageIndex, rightImageIndex;
    CGPoint offset = [scrollView_ contentOffset];
    if (offset.x > SCREEN_WIDTH) {//向右滑动
        currentImageIndex_ = (currentImageIndex_ + 1) % imageCount_;
    }
    else if (offset.x < SCREEN_WIDTH){//向左滑动
        currentImageIndex_ = (currentImageIndex_ + imageCount_ - 1) % imageCount_;
    }
    centerImageView_.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", (long)currentImageIndex_]];
    leftImageIndex = (currentImageIndex_ + imageCount_ - 1) % imageCount_;
    rightImageIndex = (currentImageIndex_ + 1) % imageCount_;
    leftImageView_.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", (long)leftImageIndex]];
    rightImageView_.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg", (long)rightImageIndex]];
}

@end
