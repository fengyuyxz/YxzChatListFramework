//
//  YxzAnimationControl.m
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/8/1.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "YxzAnimationControl.h"
#import "NSString+Empty.h"
#import <CCKeyFrameAnimationView.h>
#define YxzAnimaitonFireworksBundel  @"animationfireworks.bundle"
@implementation YxzAnimationControl
+(NSString *)generateAnimationNums{
    
    int nums=arc4random()%6+1;//生成1 - 6中动画
    NSMutableArray *array=[[NSMutableArray alloc]init];
    for(int i=1;i<=nums;i++){
        NSString *anim=[NSString stringWithFormat:@"%d",(arc4random()%6+1)];
        if (![array containsObject:anim]) {
            [array addObject:anim];
        }
    }
   NSString *animationNums= [array componentsJoinedByString:@","];
    
    return animationNums;
}
+(void)beginAnimation:(NSString *)animationNum animationImageView:(UIImageView *)animaitnImageView{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          NSMutableArray<UIImage *> *allImageList=[[NSMutableArray alloc]init];
        float animationDuration =0.9;
        @autoreleasepool {
            NSArray<NSString *> *animationList;
               if ([animationNum containsString:@","]) {
                   animationList=[animationNum componentsSeparatedByString:@","];
               }else{
                   animationList=@[animationNum];
               }
               NSDictionary *animationfolder=@{@"01":@"16",@"02":@"20",@"03":@"38",@"04":@"34",@"05":@"25",@"06":@"29"};
              
               
               for (NSString *animtionType in animationList) {
                   animationDuration+=0.5;
                   NSString *key=[NSString stringWithFormat:@"0%@",animtionType];
                   NSString *folderName=[NSString stringWithFormat:@"0%@png",animtionType];
                   NSString *imageNums=animationfolder[key];
                   if (![NSString isEmpty:imageNums]) {
                      
                       NSString *imageFolder=[YxzAnimaitonFireworksBundel stringByAppendingPathComponent:folderName];
                       int nums=[imageNums intValue];
                       for (int i=1; i<=nums; i++) {
                           NSString *imageFilePath=[imageFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%d",folderName,i]];
                           UIImage *image=[UIImage imageNamed:imageFilePath];
                           if (image) {
                               [allImageList addObject:image];
                           }
                       }
                   }
               }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            animaitnImageView.animationImages = allImageList;
            animaitnImageView.animationDuration = animationDuration;
            animaitnImageView.animationRepeatCount = 1;
            [animaitnImageView startAnimating];
        });
    });
    
   
}
@end
