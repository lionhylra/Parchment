import UIKit
import Parchment

// First thing we need to do is create our own
// PagingItem that will hold our date. We also
// need to make sure it conforms to Equatable, 
// since that is required by PagingViewController
struct CalendarItem: PagingItem, Equatable {
  let date: NSDate
}

func ==(lhs: CalendarItem, rhs: CalendarItem) -> Bool {
  return lhs.date == rhs.date
}

// Create our own custom purple theme
struct CalendarPagingTheme: PagingTheme {
  let textColor = UIColor(red: 95/255, green: 102/255, blue: 108/255, alpha: 1)
  let selectedTextColor = UIColor(red: 117/255, green: 111/255, blue: 216/255, alpha: 1)
  let indicatorColor = UIColor(red: 117/255, green: 111/255, blue: 216/255, alpha: 1)
}

// We need create our own options struct so that
// we can customize it to our needs. Since we want
// to display both the current date and the weekday
// label in our menu items, we set the menuItemClass
// to be our CalendarPagingCell, which is a subclass
// of PagingCell
struct CalendarPagingOptions: PagingOptions {
  let menuItemClass: PagingCell.Type = CalendarPagingCell.self
  let menuItemSize: PagingMenuItemSize = .Fixed(width: 48, height: 58)
  let theme: PagingTheme = CalendarPagingTheme()
}

class ViewController: UIViewController {
  
  // Initialize our PagingViewController with our
  // custom options. Note that we also need to specify
  // the generic type as our CalendarItem
  lazy var pagingViewController: PagingViewController<CalendarItem> = {
    return PagingViewController(options: CalendarPagingOptions())
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    pagingViewController.dataSource = self
    
    addChildViewController(pagingViewController)
    view.addSubview(pagingViewController.view)
    view.constrainToEdges(pagingViewController.view)
    pagingViewController.didMoveToParentViewController(self)
  }
  
}

// We need to conform to PagingViewControllerDataSource
// in order to implement our custom data source. We set the
// initial item to be the current date, and every time
// pagingItemBeforePagingItem: or pagingItemAfterPagingItem:
// is called, we either subtract or append the time
// interval equal to one day. This means our paging view
// controller will show one menu item for each day.

extension ViewController: PagingViewControllerDataSource {
  
  func initialPagingItem() -> PagingItem? {
    return CalendarItem(date: NSDate())
  }
  
  func viewControllerForPagingItem(pagingItem: PagingItem) -> UIViewController {
    let calendarItem = pagingItem as! CalendarItem
    return CalendarViewController(date: calendarItem.date)
  }
  
  func pagingItemBeforePagingItem(pagingItem: PagingItem) -> PagingItem? {
    let calendarItem = pagingItem as! CalendarItem
    return CalendarItem(date: calendarItem.date.dateByAddingTimeInterval(-86400))
  }
  
  func pagingItemAfterPagingItem(pagingItem: PagingItem) -> PagingItem? {
    let calendarItem = pagingItem as! CalendarItem
    return CalendarItem(date: calendarItem.date.dateByAddingTimeInterval(86400))
  }
  
}
