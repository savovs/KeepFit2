import UIKit
import SwipeCellKit

class GoalController : UITableViewController, SwipeTableViewCellDelegate {
    var goals: [Goal] = [Goal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = NSStringFromClass(GoalTableCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! GoalTableCell
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        
        return options
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            //            self.goals.remove(at: indexPath.row)
        }
        
        // customize the action appearance
        deleteAction.title = "Delete"
        
        return [deleteAction]
    }
}

class GoalTableCell : SwipeTableViewCell {
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Goal Name"
        
        return label
    }()
    
    let currentStepsLabel: UILabel = {
        let label = UILabel()
        label.text = "300"
        label.textColor = UIColor.gray
        
        return label
    }()
    
    let targetStepsLabel: UILabel = {
        let label = UILabel()
        label.text = "1000"
        label.textColor = UIColor.lightGray
        
        return label
    }()
    
    func setupViews() {
        let containerView = UIView()
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nameLabel)
        
        currentStepsLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(currentStepsLabel)
        
        targetStepsLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(targetStepsLabel)
    }
}

