//
//  YxzVideoLooksBasicInoView.m
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/7/26.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "YxzVideoLooksBasicInfoView.h"
#import "YXZConstant.h"
#import <Masonry/Masonry.h>
#import "YxzGetBundleResouceTool.h"
@interface YxzVideoLooksBasicInfoView()

@property(nonatomic,strong)UIImageView *playTimesImageView;//播放次数或在线人数imageView
@property(nonatomic,strong)UIImageView *likeImage;//收藏 或点赞数码
@property(nonatomic,strong)UIImageView *giveAGiftImageView;//收到礼物

@property(nonatomic,strong)UILabel *playTimesLabel;//播放次数或在线人数imageView
@property(nonatomic,strong)UILabel *likeLabel;//收藏 或点赞数码
@property(nonatomic,strong)UILabel *giveAGiftLabel;//收到礼物



@end
@implementation YxzVideoLooksBasicInfoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)setupView{
    
    
    UIView *topView=[[UIView alloc]init];
    UIView *bottomView=[[UIView alloc]init];
    [self addSubview:topView];
    [self addSubview:bottomView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.height.equalTo(topView.mas_height);
        make.left.bottom.right.equalTo(self);
    }];
    [bottomView addSubview:self.playTimesImageView];
    [bottomView addSubview:self.playTimesLabel];
    [bottomView addSubview:self.likeImage];
    [bottomView addSubview:self.likeLabel];
    [bottomView addSubview:self.giveAGiftImageView];
    [bottomView addSubview:self.giveAGiftLabel];
    
    [self.playTimesImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(bottomView.mas_left).offset(10);
        make.width.height.equalTo(@(15));
    }];
    [self.playTimesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(self.playTimesImageView.mas_right).offset(10);
    }];
    
    [self.likeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(self.playTimesLabel.mas_right).offset(10);
        make.width.height.equalTo(@(15));
    }];
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(bottomView.mas_centerY);
           make.left.equalTo(self.likeImage.mas_right).offset(10);
           
    }];
    
    [self.giveAGiftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(bottomView.mas_centerY);
        make.left.equalTo(self.likeLabel.mas_right).offset(10);
           make.width.height.equalTo(@(15));
       }];
    [self.giveAGiftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
              make.centerY.equalTo(bottomView.mas_centerY);
              make.left.equalTo(self.giveAGiftImageView.mas_right).offset(10);
              
       }];
    
}

-(UILabel *)generateLabel{
    UILabel *label=[[UILabel alloc]init];
    label.text=@"0";
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor whiteColor];
    return  label;
}
-(UILabel *)playTimesLabel{
    if (!_playTimesLabel) {
        _playTimesLabel=[self generateLabel];
    }
    return _playTimesLabel;
}
-(UILabel *)likeLabel{
    if (!_likeLabel) {
        _likeLabel=[self generateLabel];
    }
    return _likeLabel;
}
-(UILabel *)giveAGiftLabel{
    if (!_giveAGiftLabel) {
        _giveAGiftLabel=[self generateLabel];
    }
    return _giveAGiftLabel;
}
-(UIImageView *)playTimesImageView{
    if (!_playTimesImageView) {
        _playTimesImageView=[[UIImageView alloc]init];
        _playTimesImageView.image=[[YxzGetBundleResouceTool shareInstance]getImageWithImageName:@"icon_rank@3x.png"];
    }
    return _playTimesImageView;
}
-(UIImageView *)likeImage{
    if (!_likeImage) {
        _likeImage=[[UIImageView alloc]init];
        _likeImage.image=[[YxzGetBundleResouceTool shareInstance]getImageWithImageName:@"icon_rank@3x.png"];
    }
    return _likeImage;
}
-(UIImageView *)giveAGiftImageView{
    if (!_giveAGiftImageView) {
        _giveAGiftImageView=[[UIImageView alloc]init];
        _giveAGiftImageView.image=[[YxzGetBundleResouceTool shareInstance]getImageWithImageName:@"icon_rank@3x.png"];
    }
    return _giveAGiftImageView;
}
@end
