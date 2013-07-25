//
//  HelloGraphViewController.h
//  HelloGraph
//
//  Created by Jorge Carpio on 7/24/13.
//  Copyright (c) 2013 Jorge Carpio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelloGraphViewController : UIViewController <CPTBarPlotDataSource, CPTBarPlotDelegate>

@property (strong, nonatomic) IBOutlet CPTGraphHostingView *hostView;

@property (nonatomic, strong) CPTBarPlot *myPlot;

-(void)initPlot;
-(void)configureGraph;
-(void)configurePlots;
-(void)configureAxes;
-(void)hideAnnotation:(CPTGraph *)graph;

@end
