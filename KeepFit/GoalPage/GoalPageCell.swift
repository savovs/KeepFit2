import UIKit

class GoalPageCell : UICollectionViewCell {
    let goalTableView: GoalTableController = {
        let tableView = GoalTableController()
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(goalTableView.view)
    }
}
