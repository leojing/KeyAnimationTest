//
//  ViewController.m
//  KeyAnimationTest
//
//  Created by luojing on 14/11/21.
//  Copyright (c) 2014年 luojing. All rights reserved.
//

#import "PAGuide_FourWLTViewController.h"
#import "GeoView.h"

#define PI 3.1415926
#define w_show_durtaion 0.2
#define w_move_durtaion 0.3

//自适应的一些参数配置
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define baseSizeWidth 375  //多分辨率适配基准宽度，用来计算倍率
#define baseWidthMultiple SCREEN_WIDTH/baseSizeWidth  //基准倍率

#define xOffset_square_show 180
#define yOffset_square_show -30

#define xOffset_square_move 45
#define yOffset_square_move 95

#define xOffset_4_show 135
#define yOffset_4_show 315

//#define xOffset_4_move 30
//#define yOffset_4_move 5

#define xOffset_redBall_show 190
#define yOffset_redBall_show 335

#define xOffset_redBall_move 180
#define yOffset_redBall_move SCREEN_HEIGHT/2-25*baseWidthMultiple

@interface PAGuide_FourWLTViewController ()<GeoViewDelgate> {
    UIPageControl *_pageControl;
    
    UILabel *welcomLab; // welcome
    UILabel *backLab;   // back
    UILabel *hyhlLab;   // 欢迎回来
    UIImageView *broderImageView;  // 红色边框
    UIImageView *noticeImageView;  // 全新UI
    UIImageView *pigImageView;  // 猪图片
    UIImageView *useWithPointsImageView; // 积分当钱花
    UIButton *startWLT4Button;    // 开启万里通4.0
    UIImageView *startWLT4ImageView; // 开启万里通4.0文字描述
    
    NSArray *colorArray;
    NSInteger colorNum;
    NSTimer *colorTimer;
    
    UIView *squarePanelView;
    
    // 后面出现的彩色的各个圆圈
    UIImageView *yellowCircle_big;
    UIImageView *yellowCircle_small;
    UIImageView *greenCircle;
    UIImageView *redCircle;
    UIImageView *blueCircle;
    UIImageView *purpleCircle_big;
    UIImageView *purpleCircle_small;
    // 圆圈里面的图片
    UIImageView *yellowCircle_logo;
    UIImageView *greenCircle_logo;
    UIImageView *redCircle_logo;
    UIImageView *blueCircle_logo;
    UIImageView *purpleCircle_logo;
    // 三个掉下来的方块
    UIView *fallSquare_1;
    UIView *fallSquare_2;
    UIView *fallSquare_3;
    
    // 3个椭圆边框
    UIImageView *blueEllipse;
    UIImageView *purpleEllipse;
    UIImageView *yellowEllipse;
    
    UIImageView *view_5FinalImage;
    
    BOOL addOffset;
    BOOL canMakeChange;
    
    CGFloat xOffset_4_move;
    CGFloat yOffset_4_move;
    
    
    CGFloat yellowCircleForPigOffsetY;
    CGFloat _offsetX;
    NSInteger currentPage;
    BOOL canAnimation;
}

// 1-4为小的w的四条边
@property(nonatomic, strong) GeoView *view_1;
@property(nonatomic, strong) GeoView *view_2;
@property(nonatomic, strong) GeoView *view_3;
@property(nonatomic, strong) GeoView *view_4;

// 5为那个红的圆
@property(nonatomic, strong) GeoView *view_5;

// 6-9右上方出来的正方形，要转变为4.0的0
@property(nonatomic, strong) GeoView *view_6;
@property(nonatomic, strong) GeoView *view_7;
@property(nonatomic, strong) GeoView *view_8;
@property(nonatomic, strong) GeoView *view_9;

@end

@implementation PAGuide_FourWLTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    currentPage = 0;
    addOffset = 0;
    xOffset_4_move = 28;
    yOffset_4_move = 5;
    // 4s的情况下，要单独调整彩色球体相对椭圆弧线的位置
    if (self.view.frame.size.height == 480) { // 4s
        addOffset = 1;
        yellowCircleForPigOffsetY = -42;
        xOffset_4_move -= 30;
        yOffset_4_move -= 100;
    }
    if (self.view.frame.size.height == 568) { // 5/5s/5c
        yellowCircleForPigOffsetY = -49;
        xOffset_4_move -= 30;
        yOffset_4_move -= 55;
    }
    if (self.view.frame.size.height == 736) { // 6+
        yellowCircleForPigOffsetY = -4;
        xOffset_4_move += 20;
        yOffset_4_move += 30;
    }
    
    colorNum = -1;
    colorArray = [[NSArray alloc] init];
    colorArray = @[
                   @[@"229", @"61", @"80", @"1"],
                   @[@"255", @"255", @"255", @"255"],
                   @[@"252", @"215", @"67", @"1"],
                   @[@"90", @"251", @"81", @"1"],
                   @[@"76", @"173", @"253", @"1"],
                   @[@"148", @"73", @"243", @"1"],
                   @[@"255", @"255", @"255", @"1"]];
    
    // welcome back 欢迎回来
    welcomLab = [[UILabel alloc] initWithFrame:CGRectMake(-50+xOffset_redBall_show*baseWidthMultiple, -15+yOffset_redBall_show*baseWidthMultiple, 200, 30)];
    welcomLab.text = @"elc   me";
    welcomLab.font = [UIFont fontWithName:@"Helvetica Light" size:30];
    welcomLab.textColor = [UIColor grayColor];
    welcomLab.alpha = 0;
    [self.view addSubview:welcomLab];
    
    backLab = [[UILabel alloc] initWithFrame:CGRectMake(welcomLab.frame.origin.x, CGRectGetMaxY(welcomLab.frame)+2, 200, 30)];
    backLab.text = @"back";
    backLab.font = [UIFont fontWithName:@"Helvetica Light" size:30];
    backLab.textColor = [UIColor grayColor];
    backLab.alpha = 0;
    [self.view addSubview:backLab];
    
    hyhlLab = [[UILabel alloc] initWithFrame:CGRectMake(welcomLab.frame.origin.x, CGRectGetMaxY(backLab.frame)+2, 200, 30)];
    hyhlLab.text = @"欢迎回来";
    hyhlLab.font = [UIFont fontWithName:@"FZLTHJW--GB1-0" size:26];
    hyhlLab.textColor = [UIColor colorWithRed:234/255.0f green:46/255.0f blue:71/255.0f alpha:1.0];
    hyhlLab.alpha = 0;
    [self.view addSubview:hyhlLab];
    
    broderImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-140)/2, (self.view.frame.size.height-230)/2-75, 140, 230)];
    broderImageView.image = [UIImage imageNamed:@"splashScreen_border"];
    broderImageView.alpha = 0;
    [self.view addSubview:broderImageView];
    
    UIImage *noticeImage = [UIImage imageNamed:@"splashScreen_notice_second"];
    noticeImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-noticeImage.size.width)/2, self.view.frame.size.height-180, noticeImage.size.width, noticeImage.size.height)];
    noticeImageView.image = noticeImage;
    noticeImageView.alpha = 0;
    [self.view addSubview:noticeImageView];
    
    pigImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-173)/2, (self.view.frame.size.height/2+80)*baseWidthMultiple, 173, 92)];
    if (self.view.frame.size.height == 736) { // 6+
        pigImageView.frame = CGRectMake((self.view.frame.size.width-173)/2, self.view.frame.size.height/2+80, 173, 92);
    }
    pigImageView.image = [UIImage imageNamed:@"splashScreen_pig"];
    pigImageView.alpha = 0;
    pigImageView.transform = CGAffineTransformMakeScale((self.view.frame.size.width+80)/173, 2);
    [self.view addSubview:pigImageView];
    
    UIImage *useWithPointsImage = [UIImage imageNamed:@"splashScreen_notice_third"];
    useWithPointsImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-useWithPointsImage.size.width)/2, (self.view.frame.size.height/2+210)*baseWidthMultiple, useWithPointsImage.size.width, useWithPointsImage.size.height)];
    if (self.view.frame.size.height == 736) { // 6+
        useWithPointsImageView.frame = CGRectMake((self.view.frame.size.width-useWithPointsImage.size.width)/2, self.view.frame.size.height-150, useWithPointsImage.size.width, useWithPointsImage.size.height);
    }
    useWithPointsImageView.image = useWithPointsImage;
    useWithPointsImageView.alpha = 0;
    [self.view addSubview:useWithPointsImageView];
    
    // 开始动画
    [self setView_5ShowKeyAnimation];
    
    CGFloat durtaion = w_move_durtaion+0.6;
    [NSTimer scheduledTimerWithTimeInterval:durtaion target:self selector:@selector(setView_1ShowKeyAnimation) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:durtaion target:self selector:@selector(setView_3ShowKeyAnimation) userInfo:nil repeats:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:durtaion target:self selector:@selector(setView_6ShowKeyAnimation) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:durtaion target:self selector:@selector(setView_7ShowKeyAnimation) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:durtaion target:self selector:@selector(setView_8ShowKeyAnimation) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:durtaion target:self selector:@selector(setView_9ShowKeyAnimation) userInfo:nil repeats:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:w_move_durtaion target:self selector:@selector(showWelcomeLab) userInfo:nil repeats:NO];
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = 4;
    _pageControl.backgroundColor = [UIColor blackColor];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"splashScreen_pageControl_gray"]];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"splashScreen_pageControl_red"]];
    _pageControl.center = CGPointMake(SCREEN_WIDTH/2, self.view.frame.size.height-30);
    [self.view addSubview:_pageControl];
    
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] init];
    [swipeGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeGestureRecognizer];
    
    canAnimation = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GeoViewDelgate Methods

- (void)drawRectByCustom:(GeoView *)geoView {
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (geoView.tag < 5) {
        /*椭圆*/
        CGContextSetRGBStrokeColor(context, 252.0/255.0f,217/255.0f,117/255.0f, 0.8);
        CGContextSetLineWidth(context, 0.0);
        switch (geoView.tag) {
            case 1:
            case 3:
                CGContextSetRGBFillColor (context, 252.0/255.0f,201/255.0f,81/255.0f,0.8);//设置填充颜色
                break;
                
            case 2:
                CGContextSetRGBFillColor (context, 71.0/255.0f,97/255.0f,220/255.0f,0.8);//设置填充颜色
                break;
                
            case 4:
                CGContextSetRGBFillColor (context, 241.0/255.0f,89/255.0f,125/255.0f,0.8);//设置填充颜色
                break;
                
            default:
                break;
        }
        
        CGContextAddEllipseInRect(context, CGRectMake(0, 0, 46, 20)); //椭圆
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    if (geoView.tag == 5) {
        /*画圆*/
        //填充圆，无边框
        CGContextSetRGBFillColor (context, 229.0/255.0f,61/255.0f,80/255.0f, 1.0);//设置填充颜色
        CGContextAddArc(context, 10, 10, 10, 0, 2*PI, 0); //添加一个圆
        CGContextDrawPath(context, kCGPathFill);//绘制填充
    }
    if (geoView.tag > 5 && geoView.tag < 10) {
        /*椭圆*/
        CGContextSetLineWidth(context, 0.0);
        CGContextSetRGBFillColor (context, 254.0/255.0f,203/255.0f,82/255.0f,0.8);//设置填充颜色
        CGContextAddEllipseInRect(context, CGRectMake(0, 0, 184, 80)); //椭圆
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    if (geoView.tag > 10 && geoView.tag < 15) {
        /*椭圆*/
        CGContextSetLineWidth(context, 0.0);
        CGContextSetRGBFillColor (context, 252.0/255.0f,201/255.0f,81/255.0f,0.8);//设置填充颜色
        CGContextAddEllipseInRect(context, CGRectMake(0, 0, 50, 20)); //椭圆
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

#pragma mark - view Methods

- (void)showWelcomeLab {
    [UIView animateWithDuration:0.3 animations:^{
        welcomLab.alpha = 1;
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showBackLab) userInfo:nil repeats:NO];
}

- (void)showBackLab {
    [UIView animateWithDuration:0.3 animations:^{
        backLab.alpha = 1;
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(showhyhlLab) userInfo:nil repeats:NO];
}

- (void)showhyhlLab {
    [UIView animateWithDuration:0.3 animations:^{
        hyhlLab.alpha = 1;
    }];
}

// 小w，四条边依次出现的动画
- (void)setView_1ShowKeyAnimation {
    self.view_1 = [[GeoView alloc] initWithFrame:CGRectMake(xOffset_redBall_show*baseWidthMultiple-xOffset_4_show, 0+yOffset_4_show*baseWidthMultiple, 46, 20)];
    self.view_1.backgroundColor = [UIColor clearColor];
    self.view_1.delegate = self;
    self.view_1.tag = 1;
    self.view_1.alpha = 0.0;
    CGAffineTransform transformL =CGAffineTransformMakeRotation(PI*0.38);
    self.view_1.transform = transformL;
    [self.view addSubview:self.view_1];
    
    [UIView animateWithDuration:w_show_durtaion animations:^{
        self.view_1.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:w_show_durtaion-0.2 target:self selector:@selector(setView_2ShowKeyAnimation) userInfo:nil repeats:NO];
}

- (void)setView_2ShowKeyAnimation {
    self.view_2 = [[GeoView alloc] initWithFrame:CGRectMake(xOffset_redBall_show*baseWidthMultiple-xOffset_4_show+15, 0+yOffset_4_show*baseWidthMultiple, 46, 20)];
    self.view_2.backgroundColor = [UIColor clearColor];
    self.view_2.delegate = self;
    self.view_2.tag = 2;
    self.view_2.alpha = 0.0;
    CGAffineTransform transformL =CGAffineTransformMakeRotation(PI*0.62);
    self.view_2.transform = transformL;
    [self.view addSubview:self.view_2];
    
    [UIView animateWithDuration:w_show_durtaion animations:^{
        self.view_2.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:w_show_durtaion-0.1 target:self selector:@selector(setView_4ShowKeyAnimation) userInfo:nil repeats:NO];
}

- (void)setView_3ShowKeyAnimation {
    self.view_3 = [[GeoView alloc] initWithFrame:CGRectMake(xOffset_redBall_show*baseWidthMultiple-xOffset_4_show+30, 0+yOffset_4_show*baseWidthMultiple, 46, 20)];
    self.view_3.backgroundColor = [UIColor clearColor];
    self.view_3.delegate = self;
    self.view_3.tag = 3;
    self.view_3.alpha = 0.0;
    CGAffineTransform transformL =CGAffineTransformMakeRotation(PI*0.38);
    self.view_3.transform = transformL;
    [self.view addSubview:self.view_3];
    
    [UIView animateWithDuration:w_show_durtaion animations:^{
        self.view_3.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}

- (void)setView_4ShowKeyAnimation {
    self.view_4 = [[GeoView alloc] initWithFrame:CGRectMake(xOffset_redBall_show*baseWidthMultiple-xOffset_4_show+45, 0+yOffset_4_show*baseWidthMultiple, 46, 20)];
    self.view_4.backgroundColor = [UIColor clearColor];
    self.view_4.delegate = self;
    self.view_4.tag = 4;
    self.view_4.alpha = 0.0;
    CGAffineTransform transformL =CGAffineTransformMakeRotation(PI*0.62);
    self.view_4.transform = transformL;
    [self.view addSubview:self.view_4];
    
    [UIView animateWithDuration:w_show_durtaion animations:^{
        self.view_4.alpha = 1.0;
    } completion:^(BOOL finished) {
        canAnimation = YES;
        NSLog(@"scroll yes 0");
    }];
}

// 红色圆
- (void)setView_5ShowKeyAnimation {
    self.view_5 = [[GeoView alloc] initWithFrame:CGRectMake(-5+xOffset_redBall_show*baseWidthMultiple, -10, 20, 20)];
    self.view_5.backgroundColor = [UIColor clearColor];
    self.view_5.delegate = self;
    self.view_5.tag = 5;
    [self.view addSubview:self.view_5];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(-5+xOffset_redBall_show*baseWidthMultiple, -40)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(2+xOffset_redBall_show*baseWidthMultiple, 40+yOffset_redBall_show*baseWidthMultiple)];
    keyAnima.values=@[value1, value2];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [self.view_5.layer addAnimation:keyAnima forKey:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:w_move_durtaion target:self selector:@selector(setView_5Bounce) userInfo:nil repeats:NO];
}

- (void)setView_5Bounce {
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(2+xOffset_redBall_show*baseWidthMultiple, 40+yOffset_redBall_show*baseWidthMultiple)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(2+xOffset_redBall_show*baseWidthMultiple, -60+yOffset_redBall_show*baseWidthMultiple)];
    NSValue *value3=[NSValue valueWithCGPoint:CGPointMake(2+xOffset_redBall_show*baseWidthMultiple, 20+yOffset_redBall_show*baseWidthMultiple)];
    NSValue *value4=[NSValue valueWithCGPoint:CGPointMake(2+xOffset_redBall_show*baseWidthMultiple, 2+yOffset_redBall_show*baseWidthMultiple)];
    keyAnima.values=@[value1, value2, value3, value4];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [self.view_5.layer addAnimation:keyAnima forKey:nil];
}


// 大的正方形，4条边
- (void)setView_6ShowKeyAnimation {
    self.view_6 = [[GeoView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-xOffset_square_show, -20+yOffset_square_show*baseWidthMultiple, 184, 80)];
    self.view_6.backgroundColor = [UIColor clearColor];
    self.view_6.delegate = self;
    self.view_6.tag = 6;
    self.view_6.alpha = 0.0;
    CGAffineTransform transformL =CGAffineTransformMakeRotation(PI*0.2);
    self.view_6.transform = transformL;
    [self.view addSubview:self.view_6];
    
    // 放大和调整角度
    [UIView animateWithDuration:w_move_durtaion+0.1 animations:^{
        self.view_6.alpha = 1.0;
        self.view_6.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.8), 1, 1);
    } completion:^(BOOL finished) {
    }];
}

- (void)setView_7ShowKeyAnimation {
    self.view_7 = [[GeoView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-xOffset_square_show+100, -5+yOffset_square_show*baseWidthMultiple, 184, 80)];
    self.view_7.backgroundColor = [UIColor clearColor];
    self.view_7.delegate = self;
    self.view_7.tag = 7;
    self.view_7.alpha = 0.0;
    CGAffineTransform transformL =CGAffineTransformMakeRotation(PI*0.7);
    self.view_7.transform = transformL;
    [self.view addSubview:self.view_7];
    
    // 放大和调整角度
    [UIView animateWithDuration:w_move_durtaion+0.1 animations:^{
        self.view_7.alpha = 1.0;
        self.view_7.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.3), 1, 1);
    } completion:^(BOOL finished) {
    }];
}

- (void)setView_8ShowKeyAnimation {
    self.view_8 = [[GeoView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-xOffset_square_show+83/*258+xOffset_square_show*baseWidthMultiple*/, 95+yOffset_square_show*baseWidthMultiple, 184, 80)];
    self.view_8.backgroundColor = [UIColor clearColor];
    self.view_8.delegate = self;
    self.view_8.tag = 8;
    self.view_8.alpha = 0.0;
    CGAffineTransform transformL =CGAffineTransformMakeRotation(PI*0.2);
    self.view_8.transform = transformL;
    [self.view addSubview:self.view_8];
    
    // 放大和调整角度
    [UIView animateWithDuration:w_move_durtaion+0.1 animations:^{
        self.view_8.alpha = 1.0;
        self.view_8.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.8), 1, 1);
    } completion:^(BOOL finished) {
    }];
}

- (void)setView_9ShowKeyAnimation {
    self.view_9 = [[GeoView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-xOffset_square_show-17/*158+xOffset_square_show*baseWidthMultiple*/, 80+yOffset_square_show*baseWidthMultiple, 184, 80)];
    self.view_9.backgroundColor = [UIColor clearColor];
    self.view_9.delegate = self;
    self.view_9.tag = 9;
    self.view_9.alpha = 0.0;
    CGAffineTransform transformL =CGAffineTransformMakeRotation(PI*0.7);
    self.view_9.transform = transformL;
    [self.view addSubview:self.view_9];
    
    // 放大和调整角度
    [UIView animateWithDuration:w_move_durtaion+0.1 animations:^{
        self.view_9.alpha = 1.0;
        self.view_9.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.3), 1, 1);
    } completion:^(BOOL finished) {
        canAnimation = YES;
        NSLog(@"scroll yes 0");
        //        [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(setView_9MoveKeyAnimation) userInfo:nil repeats:NO];
    }];
}

// 移除彩色圆和椭圆边框
- (void)removeAllCirclesAndEllipses {
    [UIView animateWithDuration:0.3 animations:^{
        yellowCircle_big.alpha = 0;
        yellowCircle_small.alpha = 0;
        greenCircle.alpha = 0;
        redCircle.alpha = 0;
        blueCircle.alpha = 0;
        purpleCircle_small.alpha = 0;
        // 圆圈里面的图片
        greenCircle_logo.alpha= 0;
        redCircle_logo.alpha = 0;
        blueCircle_logo.alpha = 0;
        // 3个椭圆边框
        blueEllipse.alpha = 0;
        purpleEllipse.alpha = 0;
        yellowEllipse.alpha = 0;
        
        startWLT4Button.alpha = 0;
        startWLT4ImageView.alpha = 0;
        view_5FinalImage.alpha = 0;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:w_move_durtaion animations:^{
            self.view_5.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI), 0.6, 0.6);
        }];
        
        //1.创建核心动画
        CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
        //平移
        keyAnima.keyPath=@"position";
        
        //1.1告诉系统要执行什么动画
        NSValue *value1=[NSValue valueWithCGPoint:CGPointMake((self.view.frame.size.width-20)/2, 200*baseWidthMultiple-10)];
        NSValue *value2=[NSValue valueWithCGPoint:CGPointMake((self.view.frame.size.width-self.view_5.frame.size.width)/2+10, (self.view.frame.size.height-self.view_5.frame.size.height)/2)];
        keyAnima.values=@[value1, value2];
        //1.2设置动画执行完毕后，不删除动画
        keyAnima.removedOnCompletion=NO;
        //1.3设置保存动画的最新状态
        keyAnima.fillMode=kCAFillModeForwards;
        //1.4设置动画执行的时间
        keyAnima.duration=w_move_durtaion;
        //1.5设置动画的节奏
        keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        //设置代理，开始—结束
        keyAnima.delegate=self;
        //2.添加核心动画
        [self.view_5.layer addAnimation:keyAnima forKey:nil];
        
        [NSTimer scheduledTimerWithTimeInterval:w_move_durtaion target:self selector:@selector(setColorCircleShowKeyAnimation) userInfo:nil repeats:NO];
    }];
}

- (void)setColorCircleShowKeyAnimation {
    if (colorNum == colorArray.count-1) {
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(goToNextStep) userInfo:nil repeats:NO];
        return;
    }
    colorNum ++;
    
    CGFloat time = 0.04;
    if (self.view.frame.size.height == 736) { // 6+
        time = 0.08;
    }
    if (colorNum == 0) {
        self.view_5.alpha = 0;
        [self.view_5 removeFromSuperview];
        
        CGFloat radiusWidth = 150;
        CALayer *waveLayer=[CALayer layer];
        waveLayer.frame = CGRectMake((self.view.frame.size.width-radiusWidth)/2, (self.view.frame.size.height-radiusWidth)/2, radiusWidth, radiusWidth);
        CGFloat r = [[[colorArray objectAtIndex:colorNum] objectAtIndex:0] integerValue]/255.0f;
        CGFloat g = [[[colorArray objectAtIndex:colorNum] objectAtIndex:1] integerValue]/255.0f;
        CGFloat b = [[[colorArray objectAtIndex:colorNum] objectAtIndex:2] integerValue]/255.0f;
        CGFloat a = [[[colorArray objectAtIndex:colorNum] objectAtIndex:3] integerValue];
        waveLayer.borderColor = [UIColor colorWithRed:r green:g blue:b alpha:a].CGColor;
        waveLayer.borderWidth =radiusWidth;
        waveLayer.cornerRadius = radiusWidth/2;
        
        [self.view.layer addSublayer:waveLayer];
        [self scaleBegin:waveLayer];
        
        [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(setColorCircleShowKeyAnimation) userInfo:nil repeats:NO];
    } else {
        CGFloat radiusWidth = 150;
        CALayer *waveLayer=[CALayer layer];
        waveLayer.frame = CGRectMake((self.view.frame.size.width-radiusWidth)/2, (self.view.frame.size.height-radiusWidth)/2, radiusWidth, radiusWidth);
        CGFloat r = [[[colorArray objectAtIndex:colorNum] objectAtIndex:0] integerValue]/255.0f;
        CGFloat g = [[[colorArray objectAtIndex:colorNum] objectAtIndex:1] integerValue]/255.0f;
        CGFloat b = [[[colorArray objectAtIndex:colorNum] objectAtIndex:2] integerValue]/255.0f;
        CGFloat a = [[[colorArray objectAtIndex:colorNum] objectAtIndex:3] integerValue];
        waveLayer.borderColor = [UIColor colorWithRed:r green:g blue:b alpha:a].CGColor;
        waveLayer.borderWidth =radiusWidth;
        waveLayer.cornerRadius = radiusWidth/2;
        
        [self.view.layer addSublayer:waveLayer];
        [self scaleBegin:waveLayer];
        
        [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(setColorCircleShowKeyAnimation) userInfo:nil repeats:NO];
    }
}

-(void)scaleBegin:(CALayer *)aLayer
{
    const float maxScale=120.0;
    if (aLayer.transform.m11<maxScale) {
        if (aLayer.transform.m11==1.0) {
            [aLayer setTransform:CATransform3DMakeScale( 1.1, 1.1, 1.0)];
            
        }else{
            [aLayer setTransform:CATransform3DScale(aLayer.transform, 1.1, 1.1, 1.0)];
        }
        if (self.view.frame.size.height == 736) { // 6+
            [self performSelector:_cmd withObject:aLayer afterDelay:0.005];
        } else {
            [self performSelector:_cmd withObject:aLayer afterDelay:0.002];
        }
    }else [aLayer removeFromSuperlayer];
}

- (void)goToNextStep {
}


#pragma mark - CAKeyframeAnimation Methods

// 小w，四条边移动为4的动画
- (void)setView_1MoveKeyAnimation {
    // 放大和调整角度
    [UIView animateWithDuration:w_move_durtaion-0.1 animations:^{
        canMakeChange = YES;
        self.view_1.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.75), 2.6, 1.5);
    } completion:^(BOOL finished) {
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(setView_2MoveKeyAnimation) userInfo:nil repeats:NO];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(xOffset_redBall_show*baseWidthMultiple-xOffset_4_show, yOffset_4_show*baseWidthMultiple)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(88+xOffset_4_move, 247+yOffset_4_move)];
    keyAnima.values = @[value1, value2];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion-0.1;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [self.view_1.layer addAnimation:keyAnima forKey:nil];
}

- (void)setView_2MoveKeyAnimation {
    // 放大和调整角度
    [UIView animateWithDuration:w_move_durtaion-0.1 animations:^{
        canMakeChange = YES;
        self.view_2.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.95), 2.6, 1.5);
    } completion:^(BOOL finished) {
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setView_3MoveKeyAnimation) userInfo:nil repeats:NO];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(xOffset_redBall_show*baseWidthMultiple-xOffset_4_show+15, yOffset_4_show*baseWidthMultiple)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(88+17+xOffset_4_move, 247+31+yOffset_4_move)];
    keyAnima.values=@[value1, value2];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion-0.1;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [self.view_2.layer addAnimation:keyAnima forKey:nil];
}

- (void)setView_3MoveKeyAnimation {
    [self setView_5MoveKeyAnimation];
    
    // 隐藏
    [UIView animateWithDuration:w_move_durtaion-0.1 animations:^{
        self.view_3.alpha = 0.0;
    } completion:^(BOOL finished) {
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(setView_4MoveKeyAnimation) userInfo:nil repeats:NO];
}

- (void)setView_4MoveKeyAnimation {
    
    // 放大和调整角度
    [UIView animateWithDuration:w_move_durtaion-0.1 animations:^{
        canMakeChange = YES;
        self.view_4.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.55), 2.6, 1.5);
    } completion:^(BOOL finished) {
    }];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(xOffset_redBall_show*baseWidthMultiple-xOffset_4_show+45, yOffset_4_show*baseWidthMultiple)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(88+31+xOffset_4_move, 247+14+yOffset_4_move)];
    keyAnima.values=@[value1, value2];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion-0.1;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [self.view_4.layer addAnimation:keyAnima forKey:nil];
}

- (void)setView_5MoveKeyAnimation {
    [UIView animateWithDuration:0.2 animations:^{
        welcomLab.alpha = 0;
        backLab.alpha = 0;
        hyhlLab.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            broderImageView.alpha = 1;
            noticeImageView.alpha = 1;
        }];
    }];
    
    // 对 红心圆进行移动
    // 缩小
    [UIView animateWithDuration:0.2 animations:^{
        self.view_5.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0), 0.7, 0.7);
    } completion:^(BOOL finished) {
        canAnimation = YES;
        NSLog(@"scroll yes 1");
        
        //        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startToRemoveFirstViews) userInfo:nil repeats:NO];
    }];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(0+xOffset_redBall_show*baseWidthMultiple, 0+yOffset_redBall_show*baseWidthMultiple)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(0+xOffset_redBall_move*baseWidthMultiple, 0+yOffset_redBall_move*baseWidthMultiple)];
    keyAnima.values=@[value1, value2];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=0.2;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [self.view_5.layer addAnimation:keyAnima forKey:nil];
}


// 大的正方形，4条边，进行移动变色
- (void)setView_6MoveKeyAnimation {
    // 放大和调整角度
    [UIView animateWithDuration:w_move_durtaion animations:^{
        self.view_6.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.75), 0.45, 0.45);
    } completion:^(BOOL finished) {
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setView_7MoveKeyAnimation) userInfo:nil repeats:NO];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(175+xOffset_square_move*baseWidthMultiple, -20+yOffset_square_move*baseWidthMultiple)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2+xOffset_square_move, self.view.frame.size.height/2-yOffset_square_move)];
    keyAnima.values=@[value1, value2];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [self.view_6.layer addAnimation:keyAnima forKey:nil];
}

- (void)setView_7MoveKeyAnimation {
    // 放大和调整角度
    [UIView animateWithDuration:w_move_durtaion animations:^{
        self.view_7.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.25), 0.45, 0.45);
    } completion:^(BOOL finished) {
    }];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(275+xOffset_square_move*baseWidthMultiple, -5+yOffset_square_move*baseWidthMultiple)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2+xOffset_square_move+49, self.view.frame.size.height/2-yOffset_square_move+0)];
    keyAnima.values=@[value1, value2];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [self.view_7.layer addAnimation:keyAnima forKey:nil];
}

- (void)setView_8MoveKeyAnimation {
    // 放大和调整角度
    [UIView animateWithDuration:w_move_durtaion animations:^{
        self.view_8.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.75), 0.45, 0.45);
    } completion:^(BOOL finished) {
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setView_6MoveKeyAnimation) userInfo:nil repeats:NO];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(258+xOffset_square_move*baseWidthMultiple, 95+yOffset_square_move*baseWidthMultiple)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2+xOffset_square_move+49, self.view.frame.size.height/2-yOffset_square_move+49)];
    keyAnima.values=@[value1, value2];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [self.view_8.layer addAnimation:keyAnima forKey:nil];
}

- (void)setView_9MoveKeyAnimation {
    // 放大和调整角度
    [UIView animateWithDuration:w_move_durtaion animations:^{
        self.view_9.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.25), 0.45, 0.45);
    } completion:^(BOOL finished) {
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setView_8MoveKeyAnimation) userInfo:nil repeats:NO];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(158+xOffset_square_move*baseWidthMultiple, 80+yOffset_square_move*baseWidthMultiple)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2+xOffset_square_move-0, self.view.frame.size.height/2-yOffset_square_move+49)];
    keyAnima.values=@[value1, value2];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [self.view_9.layer addAnimation:keyAnima forKey:nil];
}

- (void)startToRemoveFirstViews {
    // 其次移除除红点外的其它东西,移除结束后，移动红点的位置
    [self removeNotice];
}

- (void)startToRemoveView_6 {
    [UIView animateWithDuration:w_move_durtaion animations:^{
        self.view_6.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.6), 0.5, 0.5);
    } completion:^(BOOL finished) {
    }];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2+xOffset_square_move-10, self.view.frame.size.height/2-yOffset_square_move)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2+xOffset_square_move-10, -100)];
    keyAnima.values=@[value1, value2];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion+0.3;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [self.view_6.layer addAnimation:keyAnima forKey:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(startToRemoveView_7) userInfo:nil repeats:NO];
}

- (void)startToRemoveView_7 {
    [UIView animateWithDuration:w_move_durtaion animations:^{
        self.view_7.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.05), 0.5, 0.5);
    } completion:^(BOOL finished) {
    }];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2+xOffset_square_move-10, self.view.frame.size.height/2-yOffset_square_move+10)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2+xOffset_square_move+45, -100)];
    keyAnima.values=@[value1, value2];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion+0.3;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [self.view_7.layer addAnimation:keyAnima forKey:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(startToRemoveView_8) userInfo:nil repeats:NO];
}

- (void)startToRemoveView_8 {
    [UIView animateWithDuration:w_move_durtaion animations:^{
        self.view_8.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.6), 0.5, 0.5);
    } completion:^(BOOL finished) {
    }];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2+xOffset_square_move-10, self.view.frame.size.height/2-yOffset_square_move+50)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2+xOffset_square_move+35, -100)];
    keyAnima.values=@[value1, value2];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion+0.3;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [self.view_8.layer addAnimation:keyAnima forKey:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(startToRemoveView_9) userInfo:nil repeats:NO];
}

- (void)startToRemoveView_9 {
    [UIView animateWithDuration:w_move_durtaion animations:^{
        self.view_9.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.05), 0.5, 0.5);
    } completion:^(BOOL finished) {
    }];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2+xOffset_square_move-10, self.view.frame.size.height/2-yOffset_square_move+40)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2+xOffset_square_move-10, -140)];
    keyAnima.values=@[value1, value2];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion+0.3;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [self.view_9.layer addAnimation:keyAnima forKey:nil];
}

// 移除除红点外的其它东西
- (void)removeNotice {
    [UIView animateWithDuration:0.5 animations:^{
        broderImageView.alpha = 0;
        noticeImageView.alpha = 0;
        self.view_1.alpha = 0;
        self.view_2.alpha = 0;
        self.view_4.alpha = 0;
        self.view_6.alpha = 0;
        self.view_7.alpha = 0;
        self.view_8.alpha = 0;
        self.view_9.alpha = 0;
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view_5.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0), 0.3, 0.3);
    }];
    
    // 移动红点的位置
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(0+xOffset_redBall_move*baseWidthMultiple, 0+yOffset_redBall_move*baseWidthMultiple)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2+(pigImageView.frame.size.width/((self.view.frame.size.width+80)/173))/2-25, pigImageView.frame.origin.y+97)];
    keyAnima.values=@[value1, value2];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=0.5;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [self.view_5.layer addAnimation:keyAnima forKey:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(setPigShowKeyAnimation) userInfo:nil repeats:NO];
}

- (void)setPigShowKeyAnimation {
    [UIView animateWithDuration:w_move_durtaion animations:^{
        pigImageView.alpha = 1;
        pigImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0), 1, 1);
    } completion:^(BOOL finished) {
        [self setYellowCircleBigShowKeyAnimation];
    }];
}

- (void)setYellowCircleBigShowKeyAnimation {
    if (!yellowCircle_big) {
        yellowCircle_big = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-60)/2, self.view.frame.size.height/2+32*baseWidthMultiple+yellowCircleForPigOffsetY, 60, 60)];
        yellowCircle_big.image= [UIImage imageNamed:@"splashScreen_yellowCircle_big"];
        yellowCircle_big.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 0.1, 0.1);
        [self.view addSubview:yellowCircle_big];
    }
    if (!yellowCircle_logo) {
        yellowCircle_logo = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 30, 36)];
        yellowCircle_logo.image = [UIImage imageNamed:@"splashScreen_yellowCircle_logo"];
        yellowCircle_logo.alpha = 0;
        [yellowCircle_big addSubview:yellowCircle_logo];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        useWithPointsImageView.alpha = 1;
        yellowCircle_big.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            yellowCircle_big.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 1, 1);
        }];
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(setGreenCircleShowKeyAnimation) userInfo:nil repeats:NO];
}

- (void)setGreenCircleShowKeyAnimation {
    greenCircle = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+20*baseWidthMultiple, (yellowCircle_big.frame.origin.y-50)-baseWidthMultiple, 50, 50)];
    greenCircle.image = [UIImage imageNamed:@"splashScreen_greenCircle"];
    greenCircle.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 0.1, 0.1);
    [self.view addSubview:greenCircle];
    
    greenCircle_logo = [[UIImageView alloc] initWithFrame:CGRectMake(12, 13, 25, 24)];
    greenCircle_logo.image = [UIImage imageNamed:@"splashScreen_greenCircle_logo"];
    greenCircle_logo.alpha = 0;
    [greenCircle addSubview:greenCircle_logo];
    
    [UIView animateWithDuration:0.3 animations:^{
        yellowCircle_logo.alpha = 1;
        greenCircle.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            greenCircle.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 1, 1);
        }];
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(setRedCircleShowKeyAnimation) userInfo:nil repeats:NO];
    [self setFallSquareShowKeyAnimation];
}

- (void)setRedCircleShowKeyAnimation {
    redCircle = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-70*baseWidthMultiple, (yellowCircle_big.frame.origin.y-58)-25*baseWidthMultiple, 58, 58)];
    redCircle.image = [UIImage imageNamed:@"splashScreen_redCircle"];
    redCircle.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 0.1, 0.1);
    [self.view addSubview:redCircle];
    
    redCircle_logo = [[UIImageView alloc] initWithFrame:CGRectMake(11, 16, 36, 25)];
    redCircle_logo.image = [UIImage imageNamed:@"splashScreen_redCircle_logo"];
    redCircle_logo.alpha = 0;
    [redCircle addSubview:redCircle_logo];
    
    [UIView animateWithDuration:0.3 animations:^{
        greenCircle_logo.alpha = 1;
        redCircle.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            redCircle.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 1, 1);
        }];
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(setBlueCircleShowKeyAnimation) userInfo:nil repeats:NO];
}

- (void)setBlueCircleShowKeyAnimation {
    blueCircle = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+12*baseWidthMultiple, (greenCircle.frame.origin.y-55)-20*baseWidthMultiple, 55, 55)];
    blueCircle.image = [UIImage imageNamed:@"splashScreen_blueCircle"];
    blueCircle.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 0.1, 0.1);
    [self.view addSubview:blueCircle];
    
    blueCircle_logo = [[UIImageView alloc] initWithFrame:CGRectMake(12, 13, 30, 29)];
    blueCircle_logo.image = [UIImage imageNamed:@"splashScreen_blueCircle_logo"];
    blueCircle_logo.alpha = 0;
    [blueCircle addSubview:blueCircle_logo];
    
    [UIView animateWithDuration:0.3 animations:^{
        redCircle_logo.alpha = 1;
        blueCircle.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            blueCircle.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 1, 1);
        }];
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(setPurpleCircleBigShowKeyAnimation) userInfo:nil repeats:NO];
}

- (void)setPurpleCircleBigShowKeyAnimation {
    purpleCircle_big = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50*baseWidthMultiple, (blueCircle.frame.origin.y-43)+10*baseWidthMultiple, 43, 43)];
    purpleCircle_big.image = [UIImage imageNamed:@"splashScreen_purpleCircle_big"];
    purpleCircle_big.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 0.1, 0.1);
    [self.view addSubview:purpleCircle_big];
    
    purpleCircle_logo = [[UIImageView alloc] initWithFrame:CGRectMake(5, 14, 33, 15)];
    purpleCircle_logo.image = [UIImage imageNamed:@"splashScreen_purpleCircle_logo"];
    purpleCircle_logo.alpha = 0;
    [purpleCircle_big addSubview:purpleCircle_logo];
    
    [UIView animateWithDuration:0.3 animations:^{
        blueCircle_logo.alpha = 1;
        purpleCircle_big.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            purpleCircle_big.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 1, 1);
        }];
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(setPurpleCircleSmallShowKeyAnimation) userInfo:nil repeats:NO];
}

- (void)setPurpleCircleSmallShowKeyAnimation {
    purpleCircle_small = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+22*baseWidthMultiple, purpleCircle_big.frame.origin.y-5*baseWidthMultiple, 19, 19)];
    purpleCircle_small.image = [UIImage imageNamed:@"splashScreen_purpleCircle_small"];
    purpleCircle_small.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 0.1, 0.1);
    [self.view addSubview:purpleCircle_small];
    
    [UIView animateWithDuration:0.3 animations:^{
        purpleCircle_logo.alpha = 1;
        purpleCircle_small.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            purpleCircle_small.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 1, 1);
        }];
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(setYellowCircleSmallShowKeyAnimation) userInfo:nil repeats:NO];
}

- (void)setYellowCircleSmallShowKeyAnimation {
    yellowCircle_small = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-6*baseWidthMultiple, (purpleCircle_small.frame.origin.y-8)-5*baseWidthMultiple, 8, 8)];
    yellowCircle_small.image = [UIImage imageNamed:@"splashScreen_yellowCircle_small"];
    yellowCircle_small.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 0.1, 0.1);
    [self.view addSubview:yellowCircle_small];
    
    [UIView animateWithDuration:0.3 animations:^{
        yellowCircle_small.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 1.3, 1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            yellowCircle_small.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 1, 1);
        } completion:^(BOOL finished) {
            //            [self setFallSquareShowKeyAnimation];
        }];
    }];
}

// 执行3个方块掉下来的动画
- (void)setFallSquareShowKeyAnimation {
    [self setFallSquare_1ShowKeyAnimation];
}

- (void)setFallSquare_1ShowKeyAnimation {
    fallSquare_1 = [self creatFallSquareWithFrame:CGRectMake(self.view.frame.size.width*4.2/5, -80, 50, 50)];
    fallSquare_1.backgroundColor = [UIColor clearColor];
    fallSquare_1.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 0.8, 0.8);
    [self.view addSubview:fallSquare_1];
    
    // 放大和调整角度
    [UIView animateWithDuration:w_move_durtaion+0.3 animations:^{
        fallSquare_1.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.65), 0.7, 0.7);
    } completion:^(BOOL finished) {
    }];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width*4.2/5, -80)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width*4.2/5, (self.view.frame.size.height/2+60)*baseWidthMultiple)];
    NSValue *value3=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width*4.2/5, (self.view.frame.size.height/2+10)*baseWidthMultiple)];
    keyAnima.values=@[value1, value2, value3];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion+0.3;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [fallSquare_1.layer addAnimation:keyAnima forKey:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(setFallSquare_2ShowKeyAnimation) userInfo:nil repeats:NO];
}

- (void)setFallSquare_2ShowKeyAnimation {
    fallSquare_2 = [self creatFallSquareWithFrame:CGRectMake(70, -80, 50, 50)];
    fallSquare_2.backgroundColor = [UIColor clearColor];
    [self.view addSubview:fallSquare_2];
    
    // 放大和调整角度
    [UIView animateWithDuration:w_move_durtaion+0.3 animations:^{
        fallSquare_2.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.75), 1, 1);
    } completion:^(BOOL finished) {
    }];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(70, -80)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(70, (self.view.frame.size.height/2-30)*baseWidthMultiple)];
    NSValue *value3=[NSValue valueWithCGPoint:CGPointMake(70, (self.view.frame.size.height/2-80)*baseWidthMultiple)];
    keyAnima.values=@[value1, value2, value3];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion+0.3;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [fallSquare_2.layer addAnimation:keyAnima forKey:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(setFallSquare_3ShowKeyAnimation) userInfo:nil repeats:NO];
}

- (void)setFallSquare_3ShowKeyAnimation {
    fallSquare_3 = [self creatFallSquareWithFrame:CGRectMake(self.view.frame.size.width*4/5, -80, 50, 50)];
    fallSquare_3.backgroundColor = [UIColor clearColor];
    [self.view addSubview:fallSquare_3];
    
    // 放大和调整角度
    [UIView animateWithDuration:w_move_durtaion+0.3 animations:^{
        fallSquare_3.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.75), 1.2, 1.2);
    } completion:^(BOOL finished) {
    }];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width*4/5, -80)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width*4/5, (self.view.frame.size.height/2-160)*baseWidthMultiple)];
    NSValue *value3=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width*4/5, (self.view.frame.size.height/2-210)*baseWidthMultiple)];
    keyAnima.values=@[value1, value2, value3];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion+0.3;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [fallSquare_3.layer addAnimation:keyAnima forKey:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:w_move_durtaion+0.3 target:self selector:@selector(canAnimationForTwo) userInfo:nil repeats:NO];
}

- (void)canAnimationForTwo {
    canAnimation = YES;
    NSLog(@"scroll yes 2");
}


- (UIView *)creatFallSquareWithFrame:(CGRect)frame {
    UIView *resultView = [[UIView alloc] initWithFrame:frame];
    
    CGFloat w = 50;
    CGFloat h = 20;
    GeoView *squareBorder_1 = [[GeoView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    squareBorder_1.backgroundColor = [UIColor clearColor];
    squareBorder_1.delegate = self;
    squareBorder_1.tag = 11;
    CGAffineTransform transformL =CGAffineTransformMakeRotation(PI*0);
    squareBorder_1.transform = transformL;
    [resultView addSubview:squareBorder_1];
    
    GeoView *squareBorder_2 = [[GeoView alloc] initWithFrame:CGRectMake(20, 20, w, h)];
    squareBorder_2.backgroundColor = [UIColor clearColor];
    squareBorder_2.delegate = self;
    squareBorder_2.tag = 12;
    transformL =CGAffineTransformMakeRotation(PI*0.5);
    squareBorder_2.transform = transformL;
    [resultView addSubview:squareBorder_2];
    
    GeoView *squareBorder_3 = [[GeoView alloc] initWithFrame:CGRectMake(0, 40, w, h)];
    squareBorder_3.backgroundColor = [UIColor clearColor];
    squareBorder_3.delegate = self;
    squareBorder_3.tag = 13;
    transformL =CGAffineTransformMakeRotation(PI*0);
    squareBorder_3.transform = transformL;
    [resultView addSubview:squareBorder_3];
    
    GeoView *squareBorder_4 = [[GeoView alloc] initWithFrame:CGRectMake(-20, 20, w, h)];
    squareBorder_4.backgroundColor = [UIColor clearColor];
    squareBorder_4.delegate = self;
    squareBorder_4.tag = 14;
    transformL =CGAffineTransformMakeRotation(PI*0.5);
    squareBorder_4.transform = transformL;
    [resultView addSubview:squareBorder_4];
    
    return resultView;
}

// 执行3个方块收回去的动画
- (void)removeFallSquares {
    [self setFallSquare_3MoveKeyAnimation];
    [self removeCircleLogo];
}

- (void)setFallSquare_1MoveKeyAnimation {
    // 放大和调整角度
    [UIView animateWithDuration:w_move_durtaion+0.3 animations:^{
        fallSquare_1.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 0.7, 0.7);
    } completion:^(BOOL finished) {
    }];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value3=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width*4.2/5, -80)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width*4.2/5, (self.view.frame.size.height/2+60)*baseWidthMultiple)];
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width*4.2/5, (self.view.frame.size.height/2+10)*baseWidthMultiple)];
    keyAnima.values=@[value1, value2, value3];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion+0.3;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [fallSquare_1.layer addAnimation:keyAnima forKey:nil];
}

- (void)setFallSquare_2MoveKeyAnimation {
    // 放大和调整角度
    [UIView animateWithDuration:w_move_durtaion+0.3 animations:^{
        fallSquare_2.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 1, 1);
    } completion:^(BOOL finished) {
    }];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value3=[NSValue valueWithCGPoint:CGPointMake(70, -80)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(70, (self.view.frame.size.height/2-30)*baseWidthMultiple)];
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(70, (self.view.frame.size.height/2-80)*baseWidthMultiple)];
    keyAnima.values=@[value1, value2, value3];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion+0.3;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [fallSquare_2.layer addAnimation:keyAnima forKey:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(setFallSquare_1MoveKeyAnimation) userInfo:nil repeats:NO];
    //    [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(removeCircleLogo) userInfo:nil repeats:NO];
}

- (void)setFallSquare_3MoveKeyAnimation {
    // 放大和调整角度
    [UIView animateWithDuration:w_move_durtaion+0.3 animations:^{
        fallSquare_3.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0), 1.2, 1.2);
    } completion:^(BOOL finished) {
    }];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value3=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width*4/5, -80)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width*4/5, (self.view.frame.size.height/2-160)*baseWidthMultiple)];
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width*4/5, (self.view.frame.size.height/2-210)*baseWidthMultiple)];
    keyAnima.values=@[value1, value2, value3];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion+0.3;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [fallSquare_3.layer addAnimation:keyAnima forKey:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(setFallSquare_2MoveKeyAnimation) userInfo:nil repeats:NO];
}

// 移除 彩色圆圈里的logo
- (void)removeCircleLogo {
    CGFloat durationTime = 0.2;
    [UIView animateWithDuration:durationTime animations:^{
        purpleCircle_logo.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:durationTime animations:^{
            blueCircle_logo.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:durationTime animations:^{
                redCircle_logo.alpha = 0;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:durationTime animations:^{
                    greenCircle_logo.alpha = 0;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:durationTime animations:^{
                        yellowCircle_logo.alpha = 0;
                        pigImageView.alpha = 0;
                        useWithPointsImageView.alpha = 0;
                        [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(startMoveCircles) userInfo:nil repeats:NO];
                    }];
                }];
            }];
        }];
    }];
}

//
- (void)startMoveCircles {
    [self setView_5MoveToFinalPosition];
}

- (void)setView_5MoveToFinalPosition {
    view_5FinalImage = [[UIImageView alloc] initWithFrame:CGRectMake(-1, -1, 22, 22)];
    view_5FinalImage.image = [UIImage imageNamed:@"splashScreen_finalLogo"];
    view_5FinalImage.alpha = 0;
    [self.view_5 addSubview:view_5FinalImage];
    
    // 对 红心圆进行移动
    // 缩小
    [UIView animateWithDuration:w_move_durtaion*3 animations:^{
        self.view_5.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0), 75/20, 75/20);
        purpleCircle_big.alpha = 0;
    } completion:^(BOOL finished) {
        view_5FinalImage.alpha = 1;
    }];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    //1.1告诉系统要执行什么动画
    NSValue *value1=[NSValue valueWithCGPoint:CGPointMake((self.view.frame.size.width/2+80)*baseWidthMultiple, (self.view.frame.size.height/2+30)*baseWidthMultiple+100-10)];
    NSValue *value2=[NSValue valueWithCGPoint:CGPointMake((self.view.frame.size.width-20)/2+10, 200*baseWidthMultiple-10)];
    keyAnima.values=@[value1, value2];
    //1.2设置动画执行完毕后，不删除动画
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion*3;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [self.view_5.layer addAnimation:keyAnima forKey:nil];
    
    UIImage *startWLT4Image = [UIImage imageNamed:@"splashScreen_notice_forth"];
    startWLT4ImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-startWLT4Image.size.width)/2, self.view.frame.size.height-180, startWLT4Image.size.width, startWLT4Image.size.height)];
    startWLT4ImageView.image = startWLT4Image;
    startWLT4ImageView.alpha = 0;
    [self.view addSubview:startWLT4ImageView];
    
    startWLT4Button = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width-240)/2, self.view.frame.size.height-100, 240, 35)];
    startWLT4Button.backgroundColor = [UIColor clearColor];
    [startWLT4Button setTitle:@"开启4.0" forState:UIControlStateNormal];
    [startWLT4Button setTitleColor:[UIColor colorWithRed:234/255.0f green:46/255.0f blue:71/255.0f alpha:1.0] forState:UIControlStateNormal];
    startWLT4Button.titleLabel.textAlignment = NSTextAlignmentCenter;
    startWLT4Button.titleLabel.font = [UIFont systemFontOfSize:17];
    startWLT4Button.layer.masksToBounds = YES;
    startWLT4Button.layer.cornerRadius = 18;
    startWLT4Button.layer.borderColor = [[UIColor colorWithRed:234/255.0f green:46/255.0f blue:71/255.0f alpha:1.0] CGColor];
    startWLT4Button.layer.borderWidth = 1.0;
    startWLT4Button.alpha = 0;
    startWLT4Button.enabled = NO;
    [startWLT4Button addTarget:self action:@selector(startLanuchWLT4:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startWLT4Button];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(setYellowCircleMoveToFinalPosition) userInfo:nil repeats:NO];
}

- (void)setYellowCircleMoveToFinalPosition {
    [UIView animateWithDuration:w_move_durtaion*3 animations:^{
        yellowCircle_big.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0), 0.73, 0.73);
    }];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    CGMutablePathRef path = CGPathCreateMutable();
    int xOffset = 120-30*addOffset;
    int yOffset = -50+60*addOffset;
    int waveHeight = -50;
    CGPoint p1 = CGPointMake(yellowCircle_big.frame.origin.x+20, yellowCircle_big.frame.origin.y+40);
    CGPoint p2 = CGPointMake(yellowCircle_big.frame.origin.x + xOffset, (self.view.frame.size.height/2+5*baseWidthMultiple) + yOffset);
    
    CGPathMoveToPoint(path, NULL, p1.x,p1.y);
    
    //生成贝塞尔曲线路径
    CGPathAddQuadCurveToPoint(path, NULL, p1.x+xOffset/2, p1.y - waveHeight, p2.x, p2.y);
    
    keyAnima.path = path;
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion*3;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [yellowCircle_big.layer addAnimation:keyAnima forKey:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(setGreenCircleMoveToFinalPosition) userInfo:nil repeats:NO];
}

- (void)setGreenCircleMoveToFinalPosition {
    [UIView animateWithDuration:w_move_durtaion*3 animations:^{
        greenCircle_logo.image = [UIImage imageNamed:@"splashScreen_greenCircle_new"];
        greenCircle_logo.alpha = 1;
        greenCircle.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0), 0.73, 0.73);
    }];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    CGMutablePathRef path = CGPathCreateMutable();
    int xOffset = 95-10*addOffset;
    int yOffset = -85+40*addOffset;
    int waveHeight = -30;
    CGPoint p1 = CGPointMake(greenCircle.frame.origin.x+20, greenCircle.frame.origin.y-10);
    CGPoint p2 = CGPointMake(greenCircle.frame.origin.x + xOffset, (self.view.frame.size.height/2-50*baseWidthMultiple) + yOffset);
    
    CGPathMoveToPoint(path, NULL, p1.x,p1.y);
    
    //生成贝塞尔曲线路径
    CGPathAddQuadCurveToPoint(path, NULL, p1.x+xOffset/2, p1.y - waveHeight, p2.x, p2.y);
    
    keyAnima.path = path;
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion*3;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [greenCircle.layer addAnimation:keyAnima forKey:nil];
    
    [self setRedCircleMoveToFinalPosition];
}

- (void)setRedCircleMoveToFinalPosition {
    // 画蓝色椭圆线
    [self creatBlueEllipse];
    
    [UIView animateWithDuration:w_move_durtaion*3 animations:^{
        redCircle_logo.frame = CGRectMake(9, 16, 40, 30);
        redCircle_logo.image = [UIImage imageNamed:@"splashScreen_redCircle_new"];
        redCircle_logo.alpha = 1;
        redCircle.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0), 0.75, 0.75);
    }];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    CGMutablePathRef path = CGPathCreateMutable();
    int xOffset = -55+10*addOffset;
    int yOffset = -15+50*addOffset;
    int waveHeight = -30;
    CGPoint p1 = CGPointMake(redCircle.frame.origin.x+20, redCircle.frame.origin.y-10);
    CGPoint p2 = CGPointMake((redCircle.frame.origin.x + xOffset)*baseWidthMultiple, (self.view.frame.size.height/2-75*baseWidthMultiple) + yOffset);
    
    CGPathMoveToPoint(path, NULL, p1.x,p1.y);
    
    //生成贝塞尔曲线路径
    CGPathAddQuadCurveToPoint(path, NULL, p1.x+xOffset/2, p1.y - waveHeight, p2.x, p2.y);
    
    keyAnima.path = path;
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion*3;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [redCircle.layer addAnimation:keyAnima forKey:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(setBlueCircleMoveToFinalPosition) userInfo:nil repeats:NO];
    
    [UIView animateWithDuration:w_move_durtaion*3 animations:^{
        startWLT4ImageView.alpha = 1;
        startWLT4Button.alpha = 1;
    }];
}

- (void)setBlueCircleMoveToFinalPosition {
    [UIView animateWithDuration:w_move_durtaion*3 animations:^{
        blueCircle_logo.frame = CGRectMake(10, 10, 35, 35);
        blueCircle_logo.image = [UIImage imageNamed:@"splashScreen_blueCircle_new"];
        blueCircle_logo.alpha = 1;
        blueCircle.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(0), 0.73, 0.73);
    }];
    
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    CGMutablePathRef path = CGPathCreateMutable();
    int xOffset = -70-12*addOffset;
    int yOffset = 20+35*addOffset;
    int waveHeight = -30;
    CGPoint p1 = CGPointMake(blueCircle.frame.origin.x+10, blueCircle.frame.origin.y+10);
    CGPoint p2 = CGPointMake(blueCircle.frame.origin.x + xOffset, (self.view.frame.size.height/2-125*baseWidthMultiple) + yOffset);
    
    CGPathMoveToPoint(path, NULL, p1.x,p1.y);
    
    //生成贝塞尔曲线路径
    CGPathAddQuadCurveToPoint(path, NULL, p1.x+xOffset/2, p1.y - waveHeight, p2.x, p2.y);
    
    keyAnima.path = path;
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion*3;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [blueCircle.layer addAnimation:keyAnima forKey:nil];
    
    [self setPurpleCircleSmallMoveToFinalPosition];
}

- (void)setPurpleCircleSmallMoveToFinalPosition {
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    CGMutablePathRef path = CGPathCreateMutable();
    int xOffset = -40-10*addOffset;
    int yOffset = 110+40*addOffset;
    int waveHeight = -100;
    CGPoint p1 = CGPointMake(purpleCircle_small.frame.origin.x+10, purpleCircle_small.frame.origin.y+10);
    CGPoint p2 = CGPointMake( purpleCircle_small.frame.origin.x + xOffset, (self.view.frame.size.height/2-173*baseWidthMultiple) + yOffset);
    
    CGPathMoveToPoint(path, NULL, p1.x,p1.y);
    
    //生成贝塞尔曲线路径
    CGPathAddQuadCurveToPoint(path, NULL, p1.x-waveHeight, p1.y +yOffset/2, p2.x, p2.y);
    
    keyAnima.path = path;
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion*3;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [purpleCircle_small.layer addAnimation:keyAnima forKey:nil];
    
    [self.view bringSubviewToFront:purpleCircle_small];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setYellowCircleSmallMoveToFinalPosition) userInfo:nil repeats:NO];
}

- (void)setYellowCircleSmallMoveToFinalPosition {
    //1.创建核心动画
    CAKeyframeAnimation *keyAnima=[CAKeyframeAnimation animation];
    //平移
    keyAnima.keyPath=@"position";
    
    CGMutablePathRef path = CGPathCreateMutable();
    int xOffset = -60*baseWidthMultiple-10*addOffset;
    int yOffset = 10+50*addOffset;
    int waveHeight = 0;
    CGPoint p1 = CGPointMake(yellowCircle_small.frame.origin.x+10, yellowCircle_small.frame.origin.y+10);
    CGPoint p4 = CGPointMake( yellowCircle_small.frame.origin.x + xOffset, (self.view.frame.size.height/2-197*baseWidthMultiple) + yOffset);
    
    CGPathMoveToPoint(path, NULL, p1.x,p1.y);
    
    //生成贝塞尔曲线路径
    CGPathAddQuadCurveToPoint(path, NULL, p1.x+waveHeight, p1.y + 10, p4.x, p4.y);
    
    keyAnima.path = path;
    keyAnima.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyAnima.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyAnima.duration=w_move_durtaion*3;
    //1.5设置动画的节奏
    keyAnima.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //设置代理，开始—结束
    keyAnima.delegate=self;
    //2.添加核心动画
    [yellowCircle_small.layer addAnimation:keyAnima forKey:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:w_move_durtaion*3 target:self selector:@selector(canAnimationForThree) userInfo:nil repeats:NO];
}

- (void)canAnimationForThree {
    startWLT4Button.enabled = YES;
    canAnimation = YES;
    NSLog(@"scroll yes 3");
}

// 画蓝色椭圆线
- (void)creatBlueEllipse {
    CGFloat kRadiusX = 160;
    CGFloat kRadiusY = 80;
    
    blueEllipse = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-20)/2-kRadiusX/2+10, 200*baseWidthMultiple-kRadiusY/2, kRadiusX, kRadiusY)];
    blueEllipse.backgroundColor = [UIColor clearColor];
    blueEllipse.image = [UIImage imageNamed:@"splashScreen_blueEllipse"];
    blueEllipse.alpha = 0;
    blueEllipse.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.95), 0.1, 0.1);
    [self.view addSubview:blueEllipse];
    
    [UIView animateWithDuration:w_move_durtaion animations:^{
        blueEllipse.alpha = 1;
        blueEllipse.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.95), 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            blueEllipse.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.95), 1, 1);
        }];
    }];
    
    [self.view bringSubviewToFront:self.view_5];
    [self.view bringSubviewToFront:blueCircle];
    
    // 画紫色椭圆线
    [NSTimer scheduledTimerWithTimeInterval:w_move_durtaion target:self selector:@selector(creatPurpleEllipse) userInfo:nil repeats:NO];
}

// 画紫色椭圆线
- (void)creatPurpleEllipse {
    CGFloat kRadiusX = 240;
    CGFloat kRadiusY = 120;
    
    purpleEllipse = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-20)/2-kRadiusX/2+10, 200*baseWidthMultiple-kRadiusY/2+10, kRadiusX, kRadiusY)];
    purpleEllipse.backgroundColor = [UIColor clearColor];
    purpleEllipse.image = [UIImage imageNamed:@"splashScreen_purpleEllipse"];
    purpleEllipse.alpha = 0;
    purpleEllipse.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.95), 0.1, 0.1);
    [self.view addSubview:purpleEllipse];
    
    [UIView animateWithDuration:w_move_durtaion animations:^{
        purpleEllipse.alpha = 1;
        purpleEllipse.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.95), 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            purpleEllipse.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.95), 1, 1);
        }];
    }];
    
    [self.view bringSubviewToFront:greenCircle];
    [self.view bringSubviewToFront:redCircle];
    [self.view bringSubviewToFront:purpleCircle_small];
    
    // 画黄色椭圆线
    [NSTimer scheduledTimerWithTimeInterval:w_move_durtaion target:self selector:@selector(creatYellowEllipse) userInfo:nil repeats:NO];
}

// 画黄色椭圆线
- (void)creatYellowEllipse {
    CGFloat kRadiusX = 350*baseWidthMultiple;
    CGFloat kRadiusY = 175*baseWidthMultiple;
    
    yellowEllipse = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-20)/2-kRadiusX/2+10, 200*baseWidthMultiple-kRadiusY/2+20, kRadiusX, kRadiusY)];
    yellowEllipse.backgroundColor = [UIColor clearColor];
    yellowEllipse.image = [UIImage imageNamed:@"splashScreen_yellowEllipse"];
    yellowEllipse.alpha = 0;
    yellowEllipse.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.95), 0.1, 0.1);
    [self.view addSubview:yellowEllipse];
    
    [UIView animateWithDuration:w_move_durtaion animations:^{
        yellowEllipse.alpha = 1;
        yellowEllipse.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.95), 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            yellowEllipse.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(PI*0.95), 1, 1);
        }];
    }];
    
    [self.view bringSubviewToFront:greenCircle];
    [self.view bringSubviewToFront:yellowCircle_big];
    [self.view bringSubviewToFront:yellowCircle_small];
}

#pragma mark - Actions

- (void)startLanuchWLT4:(id)sender {
    _pageControl.alpha = 0;
    [self removeAllCirclesAndEllipses];
}

#pragma mark - UISwipeGestureRecognizerDelegate Methods

// 滑动
- (void)gestureRecognizerHandle:(id)sender {
    if (currentPage == 0 && canAnimation) {
        [self setView_1MoveKeyAnimation];
        [self setView_9MoveKeyAnimation];
        currentPage += 1;
        _pageControl.currentPage = currentPage;
        canAnimation = NO;
        NSLog(@"scroll no 1");
    }
    if (currentPage == 1 && canAnimation) {
        [self startToRemoveFirstViews];
        currentPage += 1;
        _pageControl.currentPage = currentPage;
        canAnimation = NO;
        NSLog(@"scroll no 2");
    }
    if (currentPage == 2 && canAnimation) {
        [self removeFallSquares];
        currentPage += 1;
        _pageControl.currentPage = currentPage;
        canAnimation = NO;
        NSLog(@"scroll no 3");
    }
}


@end
