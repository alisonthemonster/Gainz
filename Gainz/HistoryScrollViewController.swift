//
//  HistoryScrollView.swift
//  Gainz
//
//  Created by Siena McFetridge on 4/8/16.
//  Copyright © 2016 cs378. All rights reserved.
//

import UIKit
import Parse


class HistoryScrollViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, ReloadViewDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var badgesLabel: UILabel!
    
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
                    self.emptyStateLabel.hidden = true
                }
                if self.pastWorkouts.count == 0 {
                    self.emptyStateLabel.hidden = false
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
        
        self.emptyStateLabel.backgroundColor = UIColor(white: 1.0, alpha: 0.35)
        self.emptyStateLabel.frame = self.view.frame
        self.dateLabel.backgroundColor = UIColor(white: 1.0, alpha: 0.35)
        self.badgesLabel.backgroundColor = UIColor(white: 1.0, alpha: 0.35)
        
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
            self.dateLabel.hidden = false
            self.dateLabel.text = dateFormatter.stringFromDate(date! as NSDate)
        } else {
            self.dateLabel.hidden = true
            
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
                cell.backgroundColor = UIColor(white: 1.0, alpha: 0.25)
                
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
