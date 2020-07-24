//
//  YxzCalculateTextSizeTool.m
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/7/24.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "YxzCalculateTextSizeTool.h"
#import <YYText/YYTextLayout.h>
@implementation YxzCalculateTextSizeTool
+ (CGSize)YYTextLayoutSize:(NSMutableAttributedString *)attribText width:(CGFloat)width minThresholdValueV:(CGFloat)minThresholdValue{
    // 距离左边8  距离右边也为8
    CGFloat maxWidth = width;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(maxWidth, MAXFLOAT) text:attribText];
    CGSize size = layout.textBoundingSize;
    
    if (size.height && size.height < minThresholdValue) {
        size.height = minThresholdValue;
    } else {
        // 再加上6=文字距离上下的间距
        size.height = size.height + 6;
    }
    
//    self.msgHeight = size.height;
//    self.msgWidth = size.width;
    return size;
}
@end
