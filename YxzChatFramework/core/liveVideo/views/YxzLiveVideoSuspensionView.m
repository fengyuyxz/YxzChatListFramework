//
//  YxzLiveVideoSuspensionView.m
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/7/27.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "YxzLiveVideoSuspensionView.h"
#import "LivePlayerController.h"
#import "YxzGetBundleResouceTool.h"
#import <Masonry/Masonry.h>
#define supsensWidt 150
#define supsensHight 120
@interface YxzLiveVideoSuspensionView()
@property(nonatomic,strong)UIPanGestureRecognizer* panGestureRecognizer;
@property(nonatomic,strong)UIButton *fullButton;
@property(nonatomic,strong)UIButton *zoomRotatBut;//最大会 旋转

@property(nonatomic,strong)UIButton *minBut;
@end
@implementation YxzLiveVideoSuspensionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)dealloc{
    [[LivePlayerController sharedInstance] removeObserver:self forKeyPath:@"isSuspend"];
}
static const NSString * playIsSuspendConext;
-(void)setupView{
    [self addSubview:self.fullButton];
    [self addSubview:self.zoomRotatBut];
    [self addSubview:self.minBut];
    [self.zoomRotatBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(40));
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    [self.fullButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    [self.minBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.mas_top).offset(40);
        make.width.height.equalTo(@(30));
    }];
    [[LivePlayerController sharedInstance] setPlayerViewToContainerView:self];
    [[LivePlayerController sharedInstance] addObserver:self forKeyPath:@"isSuspend" options:NSKeyValueObservingOptionNew context:&playIsSuspendConext];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (context==&playIsSuspendConext) {
        if ([LivePlayerController sharedInstance].isSuspend) {
            self.minBut.hidden=YES;
            self.zoomRotatBut.hidden=YES;
            self.fullButton.hidden=NO;
        }else{
            self.minBut.hidden=NO;
            self.zoomRotatBut.hidden=NO;
            self.fullButton.hidden=YES;
        }
    }
}
-(void)handlePanGestures:(UIPanGestureRecognizer *)paramSender{
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    CGPoint point = [paramSender translationInView:window];
    
    CGPoint center=CGPointMake(paramSender.view.center.x + point.x, paramSender.view.center.y + point.y);
    CGFloat leftP=center.x-supsensWidt/2.0f;
    CGFloat rightP=center.x+supsensWidt/2.0f;
    CGFloat topP=center.y-supsensHight/2;
    CGFloat bottomP=center.y+supsensHight/2;
    CGRect rect=[UIScreen mainScreen].bounds;
    
    

    CGFloat absX = fabs(point.x);
        CGFloat absY = fabs(point.y);

        // 设置滑动有效距离
        if (MAX(absX, absY) < 10)
            return;


        if (absX > absY ) {

            if (point.x<0) {
                NSLog(@"左");
                if(leftP<=5){
                    return;
                }
                
                if (bottomP>=(CGRectGetHeight(rect)-60)) {
                    return;
                }
                if (topP<=90) {
                    return;
                }
                //向左滑动
            }else{

                //向右滑动
                NSLog(@"右");
                if (rightP>=(CGRectGetWidth(rect)-5)) {
                    return;
                }
                
                if (topP<=90) {
                    return;
                }
                if (bottomP>=(CGRectGetHeight(rect)-60)) {
                    return;
                    
                }
            }

        } else if (absY > absX) {
            if (point.y<0) {

                //向上滑动
                NSLog(@"上");
                if (topP<=90) {
                    return;
                }
                if(leftP<=5){
                   return;
                }
                               
                if (bottomP>=(CGRectGetHeight(rect)-60)) {
                    return;
                    
                }
                
            }else{

                //向下滑动
                NSLog(@"下");
                if (bottomP>=(CGRectGetHeight(rect)-60)) {
                    return;
                }
                if(leftP<=5){
                   return;
                }
                if (rightP>=(CGRectGetWidth(rect)-5)) {
                                   return;
                               }
            }
        }
   
    
    
    
  
    paramSender.view.center = center;
    [paramSender setTranslation:CGPointMake(0, 0) inView:[[UIApplication sharedApplication] keyWindow]];
}
-(void)minButtonPressed:(UIButton *)but{
    [LivePlayerController sharedInstance].isSuspend=YES;
    
}
-(void)fullButtonPressed:(UIButton *)but{
    [LivePlayerController sharedInstance].isSuspend=NO;
   
}
-(void)zoomRotatButPressed:(UIButton *)but{
    self.fullButton.hidden=YES;
    YxzLiveVideoScreenStyle sytle=YxzLiveVideoScreenStyle_portarait;
    if (!but.selected) {
        sytle=YxzLiveVideoScreenStyle_landscape;
    }
    if ([self.delegate respondsToSelector:@selector(zoomRotatStyle:)]) {
        [self.delegate zoomRotatStyle:sytle];
    }
    but.selected=!but.selected;
}
-(void)adPanGuest{
    if (_panGestureRecognizer) {
        [self removeGestureRecognizer:_panGestureRecognizer];
    }
    [self addGestureRecognizer:self.panGestureRecognizer];
}
-(void)showSuspension{
    [self adPanGuest];
    self.fullButton.hidden=NO;
    CGRect rect=[UIScreen mainScreen].bounds;
    self.frame=CGRectMake(CGRectGetWidth(rect)-(supsensHight+10), CGRectGetHeight(rect)-supsensWidt-60, supsensWidt, supsensHight);
    
    UIWindow *window=[[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
}
-(UIPanGestureRecognizer *)panGestureRecognizer{
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(handlePanGestures:)];
        //无论最大还是最小都只允许一个手指
        _panGestureRecognizer.minimumNumberOfTouches = 1;
        _panGestureRecognizer.maximumNumberOfTouches = 1;
    }
    return _panGestureRecognizer;
}

-(UIButton *)zoomRotatBut{
    if (!_zoomRotatBut) {
        _zoomRotatBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [_zoomRotatBut setTitle:@"放大" forState:UIControlStateNormal];
        [_zoomRotatBut setTitle:@"缩小" forState:UIControlStateSelected];
        [_zoomRotatBut setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [_zoomRotatBut setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        [_zoomRotatBut addTarget:self action:@selector(zoomRotatButPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zoomRotatBut;
}
-(UIButton *)fullButton{
    if (!_fullButton) {
        _fullButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _fullButton.hidden=YES;
        [_fullButton addTarget:self action:@selector(fullButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullButton;
}
-(UIButton *)minBut{
    if (!_minBut) {
        _minBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [_minBut setImage:[[YxzGetBundleResouceTool shareInstance]getImageWithImageName:@"icon_del"] forState:UIControlStateNormal];
        [_minBut addTarget:self action:@selector(minButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _minBut;
}
@end
