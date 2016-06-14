//
//  THSwiftChartsVC.swift
//  TryHard
//
//  Created by Sergey on 3/31/16.
//  Copyright © 2016 Sergey Polishchuk. All rights reserved.
//

import UIKit
//import SwiftCharts

class THSwiftChartsVC: UIViewController {

    @IBOutlet weak var chartContainer: UIView!
    
//    private var chart: Chart?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        settingUpChart()
    }

//    static var settings: ChartSettings {
//        let chartSettings = ChartSettings()
//        chartSettings.leading = 10
//        chartSettings.top = 10
//        chartSettings.trailing = 10
//        chartSettings.bottom = 10
//        chartSettings.labelsToAxisSpacingX = 5
//        chartSettings.labelsToAxisSpacingY = 5
//        chartSettings.axisTitleLabelsToLabelsSpacing = 4
//        chartSettings.axisStrokeWidth = 0.2
//        chartSettings.spacingBetweenAxesX = 8
//        chartSettings.spacingBetweenAxesY = 8
//        return chartSettings
//    }
    
    func settingUpChart() {
        
//        let labelSettings = ChartLabelSettings(font: UIFont(name: "AvenirNext-Regular", size: 14.0)!)
//    
//        var chartPoints0:[(Int, Int)] = [(Int, Int)]()
//        
//        for (var i = 0; i < 1000; i++) {
//            
//            let rand1 = i
//            let rand2 = Int(arc4random_uniform(8) + 1)
//            
//            chartPoints0.append((rand1,rand2))
//        }
//        
//        let chartPoints: [ChartPoint] = chartPoints0.map{ChartPoint(x: ChartAxisValueInt($0.0, labelSettings: labelSettings), y: ChartAxisValueInt($0.1))}
//        
//        let xValues = chartPoints.map{$0.x}
//        let yValues = ChartAxisValuesGenerator.generateYAxisValuesWithChartPoints(chartPoints, minSegmentCount: 10, maxSegmentCount: 30, multiple: 2, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: false)
//        
//        let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor.redColor(), animDuration: 1, animDelay: 0)
//
//        let notificationGenerator = {[weak self] (chartPointModel: ChartPointLayerModel, layer: ChartPointsLayer, chart: Chart) -> UIView? in
//            let (chartPoint, screenLoc) = (chartPointModel.chartPoint, chartPointModel.screenLoc)
//            
//            if chartPoint.y.scalar <= 2 {
//                let w: CGFloat = 20
//                let h: CGFloat = 20
//                let chartPointView = HandlingView(frame: CGRectMake(screenLoc.x + 5, screenLoc.y - h - 5, w, h))
//                let label = UILabel(frame: chartPointView.bounds)
//                label.layer.cornerRadius = 10
//                label.clipsToBounds = true
//                label.backgroundColor = UIColor.redColor()
//                label.textColor = UIColor.whiteColor()
//                label.textAlignment = NSTextAlignment.Center
//                label.font = UIFont(name: "AvenirNext-Regular", size: 14.0)!
//                label.text = "!"
//                chartPointView.addSubview(label)
//                label.transform = CGAffineTransformMakeScale(0, 0)
//                
//                chartPointView.movedToSuperViewHandler = {
//                    UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {() -> Void in
//                        label.transform = CGAffineTransformMakeScale(1, 1)
//                    }, completion: {(Bool) -> Void in})
//                }
//                
//                chartPointView.touchHandler = {
//                    
//                    let title = "Lorem"
//                    let message = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua."
//                    let ok = "Ok"
//                    
//                    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
//                    alert.addAction(UIAlertAction(title: ok, style: UIAlertActionStyle.Default, handler: nil))
//                    self!.presentViewController(alert, animated: true, completion: nil)
//                }
//                
//                return chartPointView
//            }
//            return nil
//        }
//        
//        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings))
//        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings.defaultVertical()))
//        
//        let screenSize = UIScreen.mainScreen().bounds
//        let chartFrame = CGRectMake(0, 0, 8192, self.chartContainer.frame.height)
//        
//        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: THSwiftChartsVC.settings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
//        
//        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
//        
//        let chartPointsNotificationsLayer = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints, viewGenerator: notificationGenerator, displayDelay: 1)
//        
//        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel])
//        
//        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.blackColor(), linesWidth: 0.2)
//        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
//        
//        let scrollView = UIScrollView(frame: CGRectMake(0, 0, screenSize.width, self.chartContainer.frame.height))
//        scrollView.contentSize = chartFrame.size
//        
//        let chart = Chart(
//            frame: chartFrame,
//            layers: [
//                xAxis,
//                yAxis,
//                guidelinesLayer,
//                chartPointsLineLayer,
//                chartPointsNotificationsLayer
//            ]
//        )
//        
//        scrollView.addSubview(chart.view)
//        self.chartContainer.addSubview(scrollView)
//        self.chart = chart
        
    }
}
