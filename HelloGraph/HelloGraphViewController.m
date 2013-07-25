//
//  HelloGraphViewController.m
//  HelloGraph
//
//  Created by Jorge Carpio on 7/24/13.
//  Copyright (c) 2013 Jorge Carpio. All rights reserved.
//

#import "HelloGraphViewController.h"

@interface HelloGraphViewController ()

@end

@implementation HelloGraphViewController

CGFloat const CPDBarWidth = 0.25f;
CGFloat const CPDBarInitialX = 0.25f;

@synthesize myPlot, hostView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initPlot];
}

/* Core Plot specific methods */
#pragma mark - Chart behavior
-(void)initPlot {
    self.hostView.allowPinchScaling = NO;
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

/* Where graph magic happens */
-(void)configureGraph
{
    // Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:[[self hostView] bounds]];
    graph.plotAreaFrame.masksToBorder = NO;
    self.hostView.hostedGraph = graph;
    
    // Configure the graph
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    graph.paddingBottom = 30.0f;
    graph.paddingLeft  = 30.0f;
    graph.paddingTop    = -1.0f;
    graph.paddingRight  = -5.0f;
    
    // Styling
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    [titleStyle setColor:[CPTColor grayColor]];
    [titleStyle setFontName:@"Helvetica-Bold"];
    [titleStyle setFontSize:16.0f];
    
    // Set up title
    NSString *title = @"a bar graph";
    [graph setTitle:title];
    [graph setTitleTextStyle:titleStyle];
    [graph setTitlePlotAreaFrameAnchor:CPTRectAnchorTop];
    [graph setTitleDisplacement:CGPointMake(0.0f, -16.0f)];
    
    
    // Set up plot space
    CGFloat xMin = 0.0f;
    CGFloat xMax = [[[CPDStockPriceStore sharedInstance] datesInWeek] count];
    CGFloat yMin = 0.0f;
    CGFloat yMax = 800.0f;  // should determine dynamically based on max price
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax)];
}

/* Add a plot to my graph */
-(void)configurePlots
{
    [self setMyPlot:[CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:NO]];
    [[self myPlot] setIdentifier:@"id"];
    
    // Set up line style
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    [barLineStyle setLineColor:[CPTColor lightGrayColor]];
    [barLineStyle setLineWidth:0.5];
    
    // Add plot to graph
    CPTGraph *graph = [[self hostView] hostedGraph];
    CGFloat barX = CPDBarInitialX;
    NSArray *plots = [NSArray arrayWithObject:[self myPlot]];
    for (CPTBarPlot *plot in plots) {
        plot.dataSource = self;
        plot.delegate = self;
        plot.barWidth = CPTDecimalFromDouble(CPDBarWidth);
        plot.barOffset = CPTDecimalFromDouble(barX);
        plot.lineStyle = barLineStyle;
        [graph addPlot:plot toPlotSpace:graph.defaultPlotSpace];
        barX += CPDBarWidth;
    }
}

-(void)configureAxes {
}

-(void)hideAnnotation:(CPTGraph *)graph {
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Required Core Plot methods per protocol */
#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [[[CPDStockPriceStore sharedInstance] datesInWeek] count];}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    if ((fieldEnum == CPTBarPlotFieldBarTip) && (index < [[[CPDStockPriceStore sharedInstance] datesInWeek] count])) {
        if ([plot.identifier isEqual:@"id"]) {
            return [[[CPDStockPriceStore sharedInstance] weeklyPrices:CPDTickerSymbolAAPL] objectAtIndex:index];
        } 
    }
    return [NSDecimalNumber numberWithUnsignedInteger:index];
}

#pragma mark - CPTBarPlotDelegate methods
-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
}

@end
