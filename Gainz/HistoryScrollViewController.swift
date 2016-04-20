//
//  HistoryScrollView.swift
//  Gainz
//
//  Created by Siena McFetridge on 4/8/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Parse
import SwiftCharts


class HistoryScrollViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, ReloadViewDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var chartView: UIView!
    
    private var chart: Chart?
    
    let pageOffset = 20
    
    var pastWorkouts: [Workout?] = []
    var pageViews: [UITableView?] = []  // Holds instances of UITableView to display each image.
    
    override func viewWillAppear(animated: Bool) {
        queryPastWorkouts()
    }
    
    func queryPastWorkouts () {
        let workoutQuery = PFQuery(className: "Workout")
        workoutQuery.whereKey("saved", equalTo: true)
        workoutQuery.whereKey("user", equalTo: PFUser.currentUser()!)
        workoutQuery.includeKey("createdAt")
        workoutQuery.orderByAscending("createdAt")
        workoutQuery.skip = pastWorkouts.count
        workoutQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if (error != nil) {
                print (error)
                print("past workouts not found")
                //TODO Display Message
            } else {
                //this is today's workout
                print("we found the most recent workouts!")
                print(String(self.pastWorkouts))
                var index = 0
                for object in objects! {
                    print(String(object))
                    let workout = Workout(workout: object, delegate: self, index: index)
                    self.pastWorkouts.append(workout)
                    index += 1
                }
            }
            print("inside the block!")
        }
    }
    
    func dataDidChange(index: Int) {
        viewDidLoad()
        pageViews[index]?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage(named: "colorful_background.jpg")
        var imageView: UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = backgroundImage
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
        self.dateLabel.backgroundColor = UIColor(white: 1.0, alpha: 0.35)
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.scrollView.delegate = self
        self.scrollView.pagingEnabled = true
        
        let pageCount = pastWorkouts.count
        
        // Indicate which page we want to start on and how many pages we have.
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        // Prepopulate image view array with nil object pointers
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // Set the scroll view's content size.
        // Since we want horizontal scrolling it's a multiple of the scroll view width.
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: (pagesScrollViewSize.width) * CGFloat(pageCount),
            height: pagesScrollViewSize.height)
        self.scrollView.setContentOffset(CGPoint(x: (pagesScrollViewSize.width) * CGFloat(pageCount-1), y: 0.0), animated: false)
        
        // Show something initially.
        loadVisiblePages()
        
       
        //Building the chart
        
        let labelSettings = ChartLabelSettings(font: Defaults.labelFont)
        
        let chartPoints0 = [
            self.createChartPoint(2, 2, labelSettings),
            self.createChartPoint(4, -4, labelSettings),
            self.createChartPoint(7, 1, labelSettings),
            self.createChartPoint(8.3, 11.5, labelSettings),
            self.createChartPoint(9, 15.9, labelSettings),
            self.createChartPoint(10.8, 3, labelSettings),
            self.createChartPoint(13, 24, labelSettings),
            self.createChartPoint(15, 0, labelSettings),
            self.createChartPoint(17.2, 29, labelSettings),
            self.createChartPoint(20, 10, labelSettings),
            self.createChartPoint(22.3, 10, labelSettings),
            self.createChartPoint(27, 15, labelSettings),
            self.createChartPoint(30, 6, labelSettings),
            self.createChartPoint(40, 10, labelSettings),
            self.createChartPoint(50, 2, labelSettings),
        ]
        
        let chartPoints1 = [
            self.createChartPoint(2, 5, labelSettings),
            self.createChartPoint(3, 7, labelSettings),
            self.createChartPoint(5, 9, labelSettings),
            self.createChartPoint(8, 6, labelSettings),
            self.createChartPoint(9, 10, labelSettings),
            self.createChartPoint(10, 20, labelSettings),
            self.createChartPoint(12, 19, labelSettings),
            self.createChartPoint(13, 20, labelSettings),
            self.createChartPoint(14, 25, labelSettings),
            self.createChartPoint(16, 28, labelSettings),
            self.createChartPoint(17, 15, labelSettings),
            self.createChartPoint(19, 6, labelSettings),
            self.createChartPoint(25, 3, labelSettings),
            self.createChartPoint(30, 10, labelSettings),
            self.createChartPoint(45, 15, labelSettings),
            self.createChartPoint(50, 20, labelSettings),
        ]
        
        let xValues = 2.stride(through: 50, by: 1).map {ChartAxisValueDouble(Double($0), labelSettings: labelSettings)}
        let yValues = ChartAxisValuesGenerator.generateYAxisValuesWithChartPoints(chartPoints0, minSegmentCount: 10, maxSegmentCount: 20, multiple: 2, axisValueGenerator: {ChartAxisValueDouble($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: false)
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings.defaultVertical()))
        let scrollViewFrame = Defaults.chartFrame(self.chartView.bounds)
        let chartFrame = CGRectMake(0, 0, 1400, scrollViewFrame.size.height)
        
        // calculate coords space in the background to keep UI smooth
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: Defaults.chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
            
            dispatch_async(dispatch_get_main_queue()) {
                let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
                
                let lineModel0 = ChartLineModel(chartPoints: chartPoints0, lineColor: UIColor.redColor(), animDuration: 1, animDelay: 0)
                let lineModel1 = ChartLineModel(chartPoints: chartPoints1, lineColor: UIColor.blueColor(), animDuration: 1, animDelay: 0)
                let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel0, lineModel1])
                
                let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.blackColor(), linesWidth: Defaults.guidelinesWidth)
                let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
                
                let scrollView = UIScrollView(frame: scrollViewFrame)
                scrollView.contentSize = CGSizeMake(chartFrame.size.width, scrollViewFrame.size.height)
                //        self.automaticallyAdjustsScrollViewInsets = false // nested view controller - this is in parent
                
                let chart = Chart(
                    frame: chartFrame,
                    layers: [
                        xAxis,
                        yAxis,
                        guidelinesLayer,
                        chartPointsLineLayer
                    ]
                )
                
                scrollView.addSubview(chart.view)
                self.chartView.addSubview(scrollView)
                
            }
        }
        
    }
    
    private func createChartPoint(x: Double, _ y: Double, _ labelSettings: ChartLabelSettings) -> ChartPoint {
        return ChartPoint(x: ChartAxisValueDouble(x, labelSettings: labelSettings), y: ChartAxisValueDouble(y))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPage(page: Int) {
        if page >= 0 && page < pastWorkouts.count {
            // See if we've already loaded the view.
            if let _ = pageViews[page] {
                // Do nothing. The view is already loaded.
            } else {
                // Determine the origin to use; which will always be 0 for y, but for x it's
                // the page (index) of the image * the width to scroll to that image horizontally.
                var frame = scrollView.bounds
                frame.size.width = frame.size.width
                frame.origin.x = frame.size.width * CGFloat(page)
                frame.origin.y = 0.0
                
                // Create a new image view and add.
                let tableView = UITableView()
                tableView.translatesAutoresizingMaskIntoConstraints = false
                tableView.contentSize = CGSize(width: (frame.width - 40),
                    height: frame.height)
                tableView.dataSource = self
                tableView.delegate = self
                tableView.separatorColor = UIColor.clearColor()
                tableView.rowHeight = 50.0
                let nib = UINib(nibName: "ExerciseTableCell", bundle: nil)
                tableView.registerNib(nib, forCellReuseIdentifier: "exerciseCell")
                tableView.frame = frame
                tableView.tag = page
                scrollView.addSubview(tableView)
                tableView.backgroundColor = UIColor.clearColor()
                
                // Load it into the array.
                pageViews[page] = tableView
            }
        }
    }
    
    func purgePage(page: Int) {
        if page >= 0 && page < pastWorkouts.count {
            // Remove a page from the scroll view and reset the container array
            if let pageView = pageViews[page] {
                pageView.removeFromSuperview()
                pageViews[page] = nil
            }
        }
    }
    
    func loadVisiblePages() {
        // First, determine which page is currently visible.
        // Note: 'floor' rounds a decimal to the lowest integer.
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        if page <= pastWorkouts.count - 1 && pastWorkouts.count > 0 {
            let date = pastWorkouts[page]?.workout.createdAt
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
            dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
            self.dateLabel.text = dateFormatter.stringFromDate(date! as NSDate)
        }
        
        
        // Update the page control.
        pageControl.currentPage = page
        
        // Work out which pages you want to load.
        let firstPage = page - 1
        let lastPage = page + 1
        
        // These next few statements are to keep the amount of memory we're consuming for the
        // images to be relatively constant. A window of 3 images - the current one and one on
        // either side of it.
        
        // Purge anything before the first page.
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range.
        for index in firstPage...lastPage {
            loadPage(index)
        }
        
        // Purge anything after the last page.
        for var index = lastPage+1; index < pastWorkouts.count; ++index {
            purgePage(index)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pastWorkouts.count-1 >= tableView.tag {
            let workout = pastWorkouts[tableView.tag]
            if let exerciseList = workout!.exercises {
                return exerciseList.count
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("exerciseCell", forIndexPath: indexPath) as! ExerciseTableViewCell
        if pastWorkouts.count-1 >= tableView.tag {
            let workout = pastWorkouts[tableView.tag]
            if let exerciseList = workout!.exercises {
                let exercise = exerciseList[indexPath.row]
                cell.nameLabel.text = exercise.objectForKey("name") as? String
                setTextField(cell.sets, key: "sets", object: exercise)
                setTextField(cell.reps, key: "reps", object: exercise)
                setTextField(cell.weight, key: "weight", object: exercise)
                if let rating = (exercise.objectForKey("rating") as? Int) {
                    if (rating==0) {
                        cell.checkMark.image = UIImage(named: "green")
                    } else if (rating==1) {
                        cell.checkMark.image = UIImage(named: "orange")
                    } else if (rating==2) {
                        cell.checkMark.image = UIImage(named: "red")
                    }
                } else {
                    cell.checkMark.image = UIImage()
                }
                cell.contentView.backgroundColor = UIColor.clearColor()
                cell.backgroundColor = UIColor(white: 1.0, alpha: 0.35)
                
            }
        }
        print ("CellforRow")
        print (cell.nameLabel.text)
        return cell
    }
    
    func setTextField (textField: UILabel, key: String, object: PFObject?) {
        if let sets = (object?.objectForKey(key) as? Int) {
            textField.text = String(sets)
        } else {
            textField.text = ""
        }
    }
    
    
}
