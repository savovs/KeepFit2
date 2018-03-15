import UIKit

class GoalPageCell : UICollectionViewCell {
    let goalTableView: GoalTableController = {
        let table = GoalTableController()
        
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(goalTableView.view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
