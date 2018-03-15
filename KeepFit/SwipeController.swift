import UIKit

// Snapchat-like horizontal swipe navigation
class SwipeController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var onceOnly = false
    
    let goalPageId = "goal"
    let mainPageId = "main"
    let historyPageId = "history"
    let otherPageId = "other"
    let navTitles = ["History", "Track", "Goals"]
    
    weak var swipeControllerDelegate: SwipeControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(GoalPageCell.self, forCellWithReuseIdentifier: goalPageId)
        collectionView?.register(MainPageCell.self, forCellWithReuseIdentifier: mainPageId)
        collectionView?.register(HistoryPageCell.self, forCellWithReuseIdentifier: historyPageId)
        collectionView?.register(OtherPageCell.self, forCellWithReuseIdentifier: otherPageId)
        collectionView?.isPagingEnabled = true
    }
    
    // 3 pages in total
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    // Set a view for each page
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: goalPageId, for: indexPath) as! GoalPageCell
            
            // Let goal table know when it's scrolled to
            swipeControllerDelegate = cell.goalTableView
            
            return cell
            
        case 1:
            return collectionView.dequeueReusableCell(withReuseIdentifier: mainPageId, for: indexPath)
            
        case 0:
            return collectionView.dequeueReusableCell(withReuseIdentifier: historyPageId, for: indexPath)
            
        default:
            return collectionView.dequeueReusableCell(withReuseIdentifier: otherPageId, for: indexPath)
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
        
        swipeControllerDelegate?.didScrollTo(indexPath: indexPath)
        
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let indexPath = collectionView!.indexPathsForVisibleItems.first {
            navigationItem.title = navTitles[indexPath.row]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

protocol SwipeControllerDelegate: class {
    func didScrollTo(indexPath: IndexPath)
}

