//
//  YHWelcomeViewController.m
//  PikeWay
//
//  Created by YHIOS002 on 16/4/19.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "YHWelcomeViewController.h"
#import "YHRegisterByPhoneNumViewController.h"
#import "YHLoginInputViewController.h"
#import "YHProtocol.h"

@interface YHWelcomeViewController ()<UIScrollViewDelegate>{

}

/***UI控件****/
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *btnExperience;

@property (strong, nonatomic) UIScrollView  *guideView;

@end

@implementation YHWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HasReadWelcomePage];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self initUI];
    [self initGuideView];
    
    
    //预加载首页
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//    webView.hidden = YES;
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[YHProtocol share].pathTaxHome]];
//    [webView loadRequest:request];
//    [self.view addSubview:webView];

    
}

- (void)initUI{
    
    self.btnExperience.layer.cornerRadius = 3;
    self.btnExperience.layer.masksToBounds = YES;
    
}

- (void)initGuideView{

    _guideView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _guideView.delegate = self;
    _guideView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    _guideView.pagingEnabled = YES;
    [_guideView setShowsHorizontalScrollIndicator:NO];
    _guideView.bounces = NO;
    
    for (NSInteger i = 0; i < 3; i ++)
    {
        
        UIImageView *guideImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        guideImage.backgroundColor = [UIColor whiteColor];
        guideImage.contentMode = UIViewContentModeScaleToFill;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%ld.jpg",(long)i + 1]];
        //图片压缩
        guideImage.image = [self compressImage:image];
        [_guideView addSubview:guideImage];
        
    }
    
    [self.view insertSubview:_guideView belowSubview:_pageControl];
}

#pragma mark - Private
//图片压缩
- (UIImage *)compressImage:(UIImage*)image
{
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}


#pragma mark - Action
//登录
- (IBAction)onLogin:(id)sender {
    
    YHLoginInputViewController *vc = [[YHLoginInputViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//注册
- (IBAction)onRegister:(id)sender {
    
    YHRegisterByPhoneNumViewController *vc = [[YHRegisterByPhoneNumViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//立即体验
- (IBAction)onExperience:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:Event_EnterRootVC object:nil];
}

#pragma mark - UIScrollViewDelgate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
    
    if (_pageControl.currentPage == 2) {
        self.btnExperience.hidden = NO;
    }else{
        self.btnExperience.hidden = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - Life
- (void)viewWillAppear:(BOOL)animated{
    //状态栏隐藏
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLog(@"%s vc dealloc",__FUNCTION__);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
