//
//  YxzLiveVideoContainerView.m
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/7/26.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "YxzLiveVideoContainerView.h"
#import "YxzVideoLooksBasicInfoView.h"
#import "YXZConstant.h"
#import <Masonry/Masonry.h>
#import "TXLiteAVSDK_Professional/TXLivePlayer.h"
@interface YxzLiveVideoContainerView()
@property(nonatomic,strong)YxzVideoLooksBasicInfoView *basicInfoView;
@property(nonatomic,strong)UIButton *zoomRotatBut;//最大会 旋转

@end
@implementation YxzLiveVideoContainerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)setupView{
    self.backgroundColor=baseBlackColor;
    [self addSubview:self.basicInfoView];
    [self addSubview:self.videoContainerView];
    
    [self.videoContainerView addSubview:self.zoomRotatBut];
    [self layoutSubViewConstraint];
}
-(void)layoutSubViewConstraint{
    [self.basicInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@(70));
    }];
    [self.videoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.basicInfoView.mas_top);
    }];
    [self.zoomRotatBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(40));
        make.right.equalTo(self.videoContainerView.mas_right).offset(-10);
        make.bottom.equalTo(self.videoContainerView.mas_bottom).offset(-10);
    }];
}

-(void)zoomRotatButPressed:(UIButton *)but{
    YxzLiveVideoScreenStyle sytle=YxzLiveVideoScreenStyle_portarait;
    if (!but.selected) {
        sytle=YxzLiveVideoScreenStyle_landscape;
    }
    if ([self.delegate respondsToSelector:@selector(zoomRotatStyle:)]) {
        [self.delegate zoomRotatStyle:sytle];
    }
    but.selected=!but.selected;
}
-(UIView *)videoContainerView{
    if (!_videoContainerView) {
        _videoContainerView=[[UIView alloc]init];
    }
    return _videoContainerView;
}
-(YxzVideoLooksBasicInfoView *)basicInfoView{
    if (!_basicInfoView) {
        _basicInfoView=[[YxzVideoLooksBasicInfoView alloc]init];
    }
    return _basicInfoView;
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
@end
