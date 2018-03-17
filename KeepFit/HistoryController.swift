import UIKit

class HistoryController : UIViewController, SwipeControllerDelegate {
    override func viewDidLoad() {
        setupLayout()
        refresh()
    }
    
    private func setupLayout() {

    }
    
    func didScrollTo(indexPath: IndexPath) {
        if (indexPath.row == 2) {
            refresh()
        }
    }
    
    func refresh() {
        
    }
}


