
# MDCurve

MDCurve 用于解决曲线运算，并提供按线长比例定位的方法。

## 1.属性MDCurvePointFuction用于给出曲线方程：

- @property (nonatomic, copy) MDCurvePointFuction curveFuction;

该属性必须赋值，t的取值范围是0~1

      x = x(t);
      y = y(t);

## 2.MDCurve提供五个方法：

###-(double)length;

length 方法获取曲线总长度：

###-(CGPoint)pointWithUniformParameter:(double)v;

pointWithUniformParameter 方法是MDCurve的核心方法，作用是获取曲线上某点，该点到曲线起点的曲线上距离为v乘以曲线长度，也就是说v控制了该点在曲线上的位置，并且是等比控制：

###-(CGPoint)primePointWithUniformParameter:(double)v;

primePointWithUniformParameter 在v位置处求得(x, y)对t的导数 (dx/dt, dy/dt)

###-(void)drawInContext:(CGContextRef)context step:(int)step;


在上下文context中绘制曲线:

###-(void)drawInCurrentContextWithStep:(int)step;


在当前上下文中绘制曲线:

## 3.只读属性isBezierCurve：

- @property (nonatomic, readonly) BOOL isBezierCurve;

用于判断曲线是否是贝塞曲线

=======



# MDBezierCurve

MDCurve的子类，屏蔽了curveFuction属性，而是采用贝塞曲线的方式提供曲线函数

## 1.MDBezierCurve提供一个开关，用于控制贝塞曲线的阶:

- @property (nonatomic, assign) BOOL isCubic;

YES为三阶，NO为二阶。二阶贝塞曲线每一段曲线的三个控制点为每个MDPointPair以及下一个MDPointPair的startPoint，而三阶贝塞曲线的四个控制点为每个MDPointPair以及下一个MDPointPair的startPoint，再加上此MDPointPair的controlPoint相对其startPoint的镜像，这样设计的目的是和photoshop中贝塞曲线的绘制方法保持一致。

## 2.MDBezierCurve提供一个init方法：

- -(id)initWithStartPointPair0:(MDPointPair *)pointPair0 pointPair1:(MDPointPair *)pointPair1;

一条贝塞曲线至少需要两对控制点来控制。

## 3.MDBezierCurve提供两个增加点的方法:

- -(void)addPointPair:(MDPointPair *)pointPair;

- -(void)addPointPairs:(NSArray *)pointPairs;

用于增加控制点对MDPointPair，此方法取代了父类MDCurve的curveFuction属性

## 4.只读属性CGPath:

@property (nonatomic, readonly) CGPathRef CGPath;

获取该贝塞曲线对应的CGPath

# 效果图
## MDCurve
![](http://imageforgithub.qiniudn.com/IMG_0291.PNG)
![](http://imageforgithub.qiniudn.com/IMG_0292.PNG)
![](http://imageforgithub.qiniudn.com/IMG_0293.PNG)
![](http://imageforgithub.qiniudn.com/IMG_0294.PNG)
![](http://imageforgithub.qiniudn.com/IMG_0295.PNG)
![](http://imageforgithub.qiniudn.com/IMG_0296.PNG)
![](http://imageforgithub.qiniudn.com/IMG_0297.PNG)
![](http://imageforgithub.qiniudn.com/IMG_0298.PNG)
![](http://imageforgithub.qiniudn.com/IMG_0299.PNG)

## MDBezierCurve
![](http://imageforgithub.qiniudn.com/IMG_0304.PNG)
![](http://imageforgithub.qiniudn.com/IMG_0305.PNG)
