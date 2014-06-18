# Demo介绍
MDCurveLabelDemo是针对[MDCurveKit](https://github.com/yangchenlarkin/MDCurveKit/tree/master)里的MDCurveLabel模块写的一个demo，把本repo clone下来之后，需要在其工程目录下装载submodule,先后执行：

- git submodule init
- git submodule update

# MDCurveLabel

MDCurveLabel 基于MDCurve实现按曲线排版文字,有两种赋值方式

- {text, font, textColor}方式
- attributedString方式

本Demo只展示了NSAttributedString的使用方式

## 1.属性text、font、textColor
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

分别用于传入文本、字体和文字颜色;

## 2.属性attributedString

@property (nonatomic, copy) NSAttributedString *attributedString;

用于传入一个NSAttributedString变量，当设置了这个值的时候，text、font、textColor将失效;
attributedString的值目前只支持使用UIKit传入，即使用UIFont,UIColor。example：

[attriString addAttribute:(NSString *)kCTForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 10)];
                      
[attriString addAttribute:(NSString *)kCTFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 10)];

## 3.属性startOffset

@property (nonatomic, assign) double startOffset;

用于传入文本开始绘制的位置在曲线上的坐标，取值范围为[0, 1],具体定义可以参见MDCurve:

https://github.com/yangchenlarkin/MDCurve

# 效果图
##使用NSAttributedString
![](http://imageforgithub.qiniudn.com/IMG_1321.PNG)
![](http://imageforgithub.qiniudn.com/IMG_1318.PNG)
![](http://imageforgithub.qiniudn.com/IMG_1315.PNG)
##不使用NSAttributedString
![](http://imageforgithub.qiniudn.com/IMG_1320.PNG)
![](http://imageforgithub.qiniudn.com/IMG_1319.PNG)
![](http://imageforgithub.qiniudn.com/IMG_1317.PNG)