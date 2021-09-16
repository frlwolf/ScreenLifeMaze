//
// Created by Felipe Lobo on 16/09/21.
//

#import "UIImage+FrequentColors.h"

@implementation UIImage (FrequentColors)

// Code referenced from: https://stackoverflow.com/questions/13694618/objective-c-getting-least-used-and-most-used-color-in-a-image/29266983#29266983

- (NSArray<UIColor *> *)mainColors
{
    size_t dimension = 10;
    int flexibility = 2;
    int range = 60;

    /*
     * Variations on color details
     * --
     *
     * low detail
     * dimension = 4;
     * flexibility = 1;
     * range = 100;
     *
     * high detail (patience!)
     * dimension = 100;
     * flexibility = 10;
     * range = 20;
     *
     */

    // 2. Determine the colors in the image

    NSMutableArray *colors = [NSMutableArray new];

    CGImageRef imageRef = [self CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    unsigned char *rawData = calloc(dimension * dimension * 4, sizeof(unsigned char));

    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * dimension;
    NSUInteger bitsPerComponent = 8;

    CGContextRef context = CGBitmapContextCreate(rawData, dimension, dimension, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    CGColorSpaceRelease(colorSpace);

    CGContextDrawImage(context, CGRectMake(0, 0, dimension, dimension), imageRef);

    CGContextRelease(context);

    for (int x = 0; x < dimension; x++) {
        for (int y = 0; y < dimension; y++) {
            NSUInteger index = (bytesPerRow * y) + x * bytesPerPixel;

            int red = rawData[index];
            int green = rawData[index + 1];
            int blue = rawData[index + 2];
            int alpha = rawData[index + 3];

            NSArray *some = @[
				[NSString stringWithFormat:@"%i", red],
				[NSString stringWithFormat:@"%i", green],
				[NSString stringWithFormat:@"%i", blue],
				[NSString stringWithFormat:@"%i", alpha]
            ];

            [colors addObject:some];
        }
    }

    free(rawData);

    // 3. add some color flexibility (adds more colors either side of the colors in the image)

    NSArray *colorsCopy = [NSArray arrayWithArray:colors];
    NSMutableArray *flexibleColors = [NSMutableArray new];

    float flexFactor = flexibility * 2 + 1;
    float factor = flexFactor * flexFactor * 3; //(r,g,b) == *3

    for (unsigned int n = 0; n < (dimension * dimension); n++) {
        NSArray *pixelColors = colorsCopy[n];
        NSMutableArray *reds = [NSMutableArray new];
        NSMutableArray *greens = [NSMutableArray new];
        NSMutableArray *blues = [NSMutableArray new];

        for (unsigned int p = 0; p < 3; p++) {
            NSString *rgbStr = pixelColors[p];

            int rgb = [rgbStr intValue];

            for (int f = -flexibility; f < flexibility + 1; f++) {
                int newRGB = MAX(0, rgb + f);

                if (p == 0)
                    [reds addObject:[NSString stringWithFormat:@"%i", newRGB]];
                else if (p == 1)
                    [greens addObject:[NSString stringWithFormat:@"%i", newRGB]];
                else if (p == 2)
                    [blues addObject:[NSString stringWithFormat:@"%i", newRGB]];
            }
        }

        unsigned int r = 0;
        unsigned int g = 0;
        unsigned int b = 0;

        for (int k = 0; k < factor; k++) {
            int red = [reds[r] intValue];
            int green = [greens[g] intValue];
            int blue = [blues[b] intValue];

            NSString *rgbString = [NSString stringWithFormat:@"%i,%i,%i", red, green, blue];
            [flexibleColors addObject:rgbString];

            b++;

            if (b == flexFactor) {
                b = 0;
                g++;
            }

            if (g == flexFactor) {
                g = 0;
                r++;
            }
        }
    }

    // 4. Distinguish the colors
    //    orders the flexible colors by their occurrence
    //    then keeps them if they are sufficiently different

    NSMutableDictionary *colorCounter = [NSMutableDictionary new];

    NSCountedSet *countedSet = [[NSCountedSet alloc] initWithArray:flexibleColors];
    for (NSString *item in countedSet) {
        NSUInteger count = [countedSet countForObject:item];
        [colorCounter setValue:@(count) forKey:item];
    }

    // Sort keys: highest occurrence to lowest

    NSArray *sortedKeys = [colorCounter keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj2 compare:obj1];
    }];

    // Checks if the color is similar to another one already included

    NSMutableArray *ranges = [NSMutableArray new];

    for (NSString *key in sortedKeys) {
        NSArray *rgb = [key componentsSeparatedByString:@","];

        int r = [rgb[0] intValue];
        int g = [rgb[1] intValue];
        int b = [rgb[2] intValue];

        BOOL exclude = NO;

        for (NSString *ranged_key in ranges) {
            NSArray *ranged_rgb = [ranged_key componentsSeparatedByString:@","];

            int ranged_r = [ranged_rgb[0] intValue];
            int ranged_g = [ranged_rgb[1] intValue];
            int ranged_b = [ranged_rgb[2] intValue];

            BOOL redOutsideRange = r >= ranged_r - range && r <= ranged_r + range;
            BOOL greenOutsideRange = g >= ranged_g - range && g <= ranged_g + range;
            BOOL blueOutsideRange = b >= ranged_b - range && b <= ranged_b + range;

            if (redOutsideRange && greenOutsideRange && blueOutsideRange)
                exclude = YES;
        }

        if (!exclude) [ranges addObject:key];
    }

    NSMutableArray<UIColor *> *colorArray = [NSMutableArray new];

    for (NSString *key in ranges) {
        NSArray *rgb = [key componentsSeparatedByString:@","];
        float r = [rgb[0] floatValue];
        float g = [rgb[1] floatValue];
        float b = [rgb[2] floatValue];

        UIColor *color = [UIColor colorWithRed:(r / 255.0f) green:(g / 255.0f) blue:(b / 255.0f) alpha:1.0f];

        [colorArray addObject:color];
    }

    return [[colorArray reverseObjectEnumerator] allObjects];

    /*
     * if you want percentages to colors continue below
     *
        NSMutableDictionary *temp = [NSMutableDictionary new];

        float totalCount = 0.0f;

        for (NSString *rangeKey in ranges){
            NSNumber *count = colorCounter[rangeKey];
            totalCount += [count intValue];
            temp[rangeKey] = count;
        }
     *
     * set percentages
     *
        NSMutableDictionary * colorDictionary = [NSMutableDictionary new];

        for (NSString *key in temp) {
            float count = [temp[key] floatValue];
            float percentage = count/totalCount;

            NSArray *rgb = [key componentsSeparatedByString:@","];
            float r = [rgb[0] floatValue];
            float g = [rgb[1] floatValue];
            float b = [rgb[2] floatValue];

            UIColor *color = [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f];

            colorDictionary[@(percentage)] = color;
        }

        return colorDictionary;
     *
     */
}

@end
