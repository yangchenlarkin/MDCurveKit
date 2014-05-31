//
//  MDCurveLabel.m
//  MDCurveLabelDemo
//
//  Created by 杨晨 on 4/25/14.
//  Copyright (c) 2014 杨晨. All rights reserved.
//

#import "MDCurveLabel.h"
#import <CoreText/CoreText.h>

@implementation MDCurveLabel

- (void)setAttributedString:(NSAttributedString *)attributedString {
  _attributedString = attributedString;
  [self setNeedsDisplay];
}

- (void)setCurve:(MDCurve *)curve {
  _curve = curve;
  [self setNeedsDisplay];
}

- (void)setStartOffset:(double)startOffset {
  _startOffset = startOffset;
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
  [self.curve drawInCurrentContextWithStep:100];
  if (self.attributedString) {
    [self drawTextWithAttributedString];
  } else {
    [self drawText];
  }
}

#pragma mark - drawWithText

- (void)drawText {
  if (self.text.length == 0) {
    return;
  }
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetTextMatrix(context, CGAffineTransformIdentity);
  double offset = self.startOffset;
  CGContextSetFillColorWithColor(context, self.textColor.CGColor);
  for (int location = 0; location < self.text.length; location++) {
    CGContextSaveGState(context);
    
    NSString *word = [self.text substringWithRange:NSMakeRange(location, 1)];
    
    CGPoint postion = [self.curve pointWithUniformT:offset];
    CGPoint prime = [self.curve primePointWithUniformT:offset];
    double angle = atan2(prime.y, prime.x);
    CGContextTranslateCTM(context, postion.x, postion.y);
    CGContextRotateCTM(context, angle);
    CGContextTranslateCTM(context, 0, -[word sizeWithFont:self.font].height);
    
    [word drawAtPoint:CGPointZero withFont:self.font];
    
    offset += [word sizeWithFont:self.font].width / self.curve.length;
    CGContextRestoreGState(context);
  }
}

#pragma mark - drawTextWithAttributedString

- (void)drawTextWithAttributedString {
  if ([self.attributedString length] == 0) {
    return;
  }
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetTextMatrix(context, CGAffineTransformIdentity);
  
  CTLineRef line = CTLineCreateWithAttributedString((__bridge CFTypeRef)self.attributedString);
  CFArrayRef runs = CTLineGetGlyphRuns(line);
  CFIndex runCount = CFArrayGetCount(runs);
  double offset = self.startOffset;
  for (CFIndex runIndex = 0; runIndex < runCount; ++runIndex) {
    CTRunRef run = CFArrayGetValueAtIndex(runs, runIndex);
    
    CTFontRef fontRef = [self prepareContext:context forRun:run];
    
    NSMutableData *glyphsData = [self glyphDataForRun:run];
    CGGlyph *glyphs = [glyphsData mutableBytes];
    
    NSMutableData *advancesData = [self advanceDataForRun:run];
    CGSize *advances = [advancesData mutableBytes];
    
    CFIndex glyphCount = CTRunGetGlyphCount(run);
    for (CFIndex glyphIndex = 0; glyphIndex < glyphCount && offset < 1.0; ++glyphIndex) {
      CGContextSaveGState(context);
      
      CGPoint glyphPoint = [self.curve pointWithUniformT:offset];
      CGPoint prime = [self.curve primePointWithUniformT:offset];
      double angle = atan2(prime.y, prime.x);
      CGContextRotateCTM(context, angle);
      CGPoint translatedPoint = CGPointApplyAffineTransform(glyphPoint, CGAffineTransformMakeRotation(-angle));
      CGContextTranslateCTM(context, translatedPoint.x, translatedPoint.y);
      CGContextScaleCTM(context, 1, -1);

      CGPoint point = CGPointMake(0, 0);
      CTFontDrawGlyphs(fontRef, &glyphs[glyphIndex], &point, 1, context);
      
      offset += advances[glyphIndex].width / self.curve.length;
      CGContextRestoreGState(context);
    }
  }
}

- (CTFontRef)prepareContext:(CGContextRef)context forRun:(CTRunRef)run {
  CFDictionaryRef attributes = CTRunGetAttributes(run);
  id font = CFDictionaryGetValue(attributes, kCTFontAttributeName);
  CTFontRef runFont = CFDictionaryGetValue(attributes, kCTFontAttributeName);
  if ([font isKindOfClass:[UIFont class]]) {
    runFont = CTFontCreateWithName((CFStringRef)((UIFont *)font).fontName, 14, NULL);
  }
  
  size_t size = CFDictionaryGetCount(attributes);
  CFTypeRef *keysTypeRef = (CFTypeRef *) malloc( size * sizeof(CFTypeRef) );
  CFDictionaryGetKeysAndValues(attributes, (const void **) keysTypeRef, NULL);
  const void **keys = (const void **) keysTypeRef;
  for (CFIndex index = 0; index < size; ++index) {
    NSString *string = (__bridge NSString *)keys[index];
    NSString *fontString = (__bridge NSString *)kCTFontAttributeName;
    NSString *colorString = (__bridge NSString *)kCTForegroundColorAttributeName;
    if ([string isEqualToString:fontString]) {
      
      CGFontRef cgFont = CTFontCopyGraphicsFont(runFont, NULL);
      CGContextSetFont(context, cgFont);
      CGContextSetFontSize(context, CTFontGetSize(runFont));
      CFRelease(cgFont);
    }
    
    if ([string isEqualToString:colorString]) {
      id color = CFDictionaryGetValue(attributes, kCTForegroundColorAttributeName);
      CGColorRef colorRef;
      if ([color isKindOfClass:[UIColor class]]) {
        colorRef = [color CGColor];
      } else {
        colorRef = (CGColorRef)CFDictionaryGetValue(attributes, kCTForegroundColorAttributeName);
      }
      CGContextSetFillColorWithColor(context, colorRef);
    } else {
      CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    }
  }
  return runFont;
}

- (NSMutableData *)glyphDataForRun:(CTRunRef)run {
  NSMutableData *data;
  CFIndex glyphsCount = CTRunGetGlyphCount(run);
  const CGGlyph *glyphs = CTRunGetGlyphsPtr(run);
  size_t dataLength = glyphsCount * sizeof(*glyphs);
  if (glyphs) {
    data = [NSMutableData dataWithBytesNoCopy:(void*)glyphs
                                       length:dataLength freeWhenDone:NO];
  } else {
    data = [NSMutableData dataWithLength:dataLength];
    CTRunGetGlyphs(run, CFRangeMake(0, 0), data.mutableBytes);
  }
  return data;
}

- (NSMutableData *)advanceDataForRun:(CTRunRef)run {
  NSMutableData *data;
  CFIndex glyphsCount = CTRunGetGlyphCount(run);
  const CGSize *advances = CTRunGetAdvancesPtr(run);
  size_t dataLength = glyphsCount * sizeof(*advances);
  if (advances) {
    data = [NSMutableData dataWithBytesNoCopy:(void*)advances
                                       length:dataLength
                                 freeWhenDone:NO];
  } else {
    data = [NSMutableData dataWithLength:dataLength];
    CTRunGetAdvances(run, CFRangeMake(0, 0), data.mutableBytes);
  }
  return data;
}

@end
