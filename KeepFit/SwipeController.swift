import UIKit

// Snapchat-like horizontal swipe navigation
class SwipeController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var onceOnly = false
    
    let cellId = "cell"
    let navTitles = ["Goals", "Track", "History"]

    let goalTableController = GoalTableController()
    let trackController = TrackController()
    let historyController = HistoryController()

    var delegates: [SwipeControllerDelegate] = [SwipeControllerDelegate]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.contentInsetAdjustmentBehavior = .never
        
        delegates = [goalTableController, trackController, historyController]
    }
    
    // 3 pages in total
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    // Set a view for each page
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            cell.addSubview(goalTableController.view)
            
            goalTableController.goalTableControllerDelegate = trackController

            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            cell.addSubview(trackController.view)

            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            cell.addSubview(historyController.view)
            
            return cell
            
        default:
            return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        }
    }
    
    // Show the middle page by default
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (!onceOnly) {
            let indexToScrollTo = IndexPath(item: 1, section: 0)
            collectionView.scrollToItem(at: indexToScrollTo, at: .left, animated: false)
            navigationItem.title = navTitles[indexToScrollTo.row]
            onceOnly = true
        }
        
        // Let delegates know which page is scrolled to they can refresh
        delegates.forEach {
            $0.didScrollTo(indexPath: indexPath)
        }
        
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let indexPath = collectionView!.indexPathsForVisibleItems.first {
            navigationItem.title = navTitles[indexPath.row]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: floor(view.frame.height))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

protocol SwipeControllerDelegate: class {
    func didScrollTo(indexPath: IndexPath)
}

