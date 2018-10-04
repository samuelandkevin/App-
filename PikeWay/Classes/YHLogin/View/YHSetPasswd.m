//
//  YHSetPasswd.m
//  PikeWay
//
//  Created by YHIOS002 on 16/8/23.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "YHSetPasswd.h"
#import "YHNetManager.h"
#import "Masonry.h"
#import "YHUtils.h"

#define kContentH 250
@interface YHSetPasswd ()<UITextFieldDelegate>
//背景view
@property (nonatomic,strong) UIView       *bgView;
//内容view
@property (nonatomic,strong) UIScrollView *contenView;
@property (nonatomic,strong) UILabel      *labelTitle;
@property (nonatomic,strong) UIView       *inputView;
@property (nonatomic,strong) UIView       *separatorView;
@property (nonatomic,strong) UITextField  *tfPasswd;
@property (nonatomic,strong) UITextField  *tfConfirmPasswd;
@property (nonatomic,strong) UIButton     *btnSure;


@property (nonatomic,copy) OnSureBlock block;
@end

@implementation YHSetPasswd

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}

- (void)setup{
    self.frame       = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    //背景view
    _bgView  = [[UIView alloc] init];
    _bgView.backgroundColor = [RGBCOLOR(0, 0, 0) colorWithAlphaComponent:0.5];
    [self addSubview:_bgView];
    
    //内容view
    _contenView = [[UIScrollView alloc] init];
    _contenView.backgroundColor = kTbvBGColor;
    _contenView.layer.masksToBounds = YES;
    _contenView.layer.cornerRadius  = 5;
    [self addSubview:_contenView];
    
    //标题
    _labelTitle = [[UILabel alloc] init];
    _labelTitle.font = [UIFont systemFontOfSize:18.0f];
    _labelTitle.textColor = [UIColor blackColor];
    _labelTitle.textAlignment = NSTextAlignmentCenter;
    _labelTitle.text = @"设置手机号登陆密码";
    [_contenView addSubview:_labelTitle];
    
    //输入框容器(密码+中间分隔线+确认密码)
    _inputView = [[UIView alloc] init];
    _inputView.layer.borderColor   = RGBCOLOR(200, 200, 200).CGColor;
    _inputView.layer.borderWidth   = 0.5;
    _inputView.layer.masksToBounds = YES;
    [_contenView addSubview:_inputView];
    
    
    //密码
    _tfPasswd = [[UITextField alloc] init];
    _tfPasswd.placeholder        = @"密码(6-20数字或字符)";
    UIView *leftViewPasswd = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    _tfPasswd.leftView     = leftViewPasswd;
    _tfPasswd.leftViewMode = UITextFieldViewModeAlways;
    _tfPasswd.clearButtonMode = UITextFieldViewModeWhileEditing;
    _tfPasswd.delegate = self;
    _tfPasswd.secureTextEntry = YES;
    [_inputView addSubview:_tfPasswd];
   
    //中间分隔线
    _separatorView = [[UIView alloc] init];
    _separatorView.backgroundColor = RGBCOLOR(200, 200, 200);
    [_inputView addSubview:_separatorView];
    
    //确认密码
    _tfConfirmPasswd = [[UITextField alloc] init];
    _tfConfirmPasswd.placeholder = @"确认密码(6-20数字或字符)";
    UIView *leftViewCPasswd = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    _tfConfirmPasswd.leftView     = leftViewCPasswd;
    _tfConfirmPasswd.leftViewMode = UITextFieldViewModeAlways;
    _tfConfirmPasswd.clearButtonMode = UITextFieldViewModeWhileEditing;
    _tfConfirmPasswd.delegate = self;
    _tfConfirmPasswd.secureTextEntry = YES;
    [_inputView addSubview:_tfConfirmPasswd];
    
    //确定
     _btnSure = [[UIButton alloc] init];
    [_btnSure addTarget:self action:@selector(onSure:) forControlEvents:UIControlEventTouchUpInside];
    [_btnSure setTitle:@"设置" forState:UIControlStateNormal];
    _btnSure.backgroundColor = kBlueColor;
    _btnSure.layer.cornerRadius  = 3;
    _btnSure.layer.masksToBounds = YES;
    [_contenView addSubview:_btnSure];
    
    [self masorny];
}

#pragma mark - Life
- (void)layoutSubviews{
    
    
}

#pragma mark - Private
- (void)masorny{
    __weak typeof(self)weakSelf = self;
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [_contenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(20);
        make.right.equalTo(weakSelf).offset(-20);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_centerY).offset(SCREEN_HEIGHT/2+kContentH);
        make.height.mas_equalTo(kContentH);
    }];
    
    [_labelTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contenView).offset(25);
        make.centerX.equalTo(weakSelf.contenView.mas_centerX);
    }];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.labelTitle.mas_bottom).offset(20);
        make.centerX.equalTo(weakSelf.contenView.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH-60);
        make.height.mas_equalTo(88);
    }];
    
    [_tfPasswd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.inputView);
        make.left.equalTo(weakSelf.inputView);
        make.right.equalTo(weakSelf.inputView);
        make.height.mas_equalTo(weakSelf.inputView).dividedBy(2);
    }];
    
    [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.equalTo(weakSelf.inputView);
        make.right.equalTo(weakSelf.inputView);
        make.top.equalTo(weakSelf.tfPasswd.mas_bottom);
    }];
    
    [_tfConfirmPasswd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.tfPasswd);
        make.top.equalTo(weakSelf.tfPasswd.mas_bottom).offset(0);
        make.width.equalTo(weakSelf.tfPasswd);
        make.height.mas_equalTo(weakSelf.inputView).dividedBy(2);
    }];
    
    [_btnSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.inputView);
        make.width.equalTo(weakSelf.inputView);
        make.top.equalTo(weakSelf.inputView.mas_bottom).offset(20);
        make.height.mas_equalTo(44);
    }];
}

- (void)show{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self showViewAnimation];
}

- (void)showViewAnimation {
    //整体上移
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.contenView.center = weakSelf.center;
            weakSelf.contenView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            weakSelf.contenView.transform = CGAffineTransformIdentity;
        }];
    });
   
}

- (void)dismissViewAnimation {
    //整体下移
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
         weakSelf.contenView.center = CGPointMake(weakSelf.center.x, weakSelf.center.y+SCREEN_HEIGHT/2+kContentH);
        weakSelf.contenView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        weakSelf.contenView.transform = CGAffineTransformIdentity;
        [weakSelf removeFromSuperview];
    }];
}

- (void)remove{
    [self dismissViewAnimation];
}


#pragma mark - Action
- (void)onSure:(id)sender{
    
    
    if (!isValidePassword(self.tfPasswd.text))
    {
        postTips(@"登录密码请输入6-20位数字或字符", nil);
        return;
    }
    
    if (!isValidePassword(self.tfConfirmPasswd.text))
    {
        postTips(@"确入密码请输入6-20位数字或字符", nil);
        return;
    }
    
    if (![self.tfPasswd.text isEqualToString:self.tfConfirmPasswd.text]) {
        postTips(@"两次输入的密码不一致,请重新输入", nil);
        return;
    }
    
    if ([YHNetManager sharedInstance].currentNetWorkStatus == YHNetworkStatus_NotReachable)
    {
        postTips(kNetWorkFailTips, nil);
        return;
    }
    
    [self endEditing:YES];
    
    __weak typeof(self)weakSelf = self;
    if (weakSelf.block) {
        weakSelf.block(weakSelf.tfConfirmPasswd.text);
    }
    
    [self remove];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{

}

#pragma mark - Public
- (void)onSureBlock:(OnSureBlock)sureBlock{
    _block = sureBlock;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
