import UIKit

class GoalTableController : UITableViewController, SwipeControllerDelegate, DetailViewControllerDelegate {
    private let cellId = "cell"
    
    var swipeIndexPathRow: Int?
    var goals: [Goal] = [Goal]()
    weak var goalTableControllerDelegate: GoalTableControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        tableView.allowsSelection = true
        tableView.register(CustomTableCell.self, forCellReuseIdentifier: cellId)
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(
            self,
            action: #selector(refresh),
            for: UIControlEvents.valueChanged
        )
        
        tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomTableCell
        let goal = goals[indexPath.row]
        

        cell.textLabel?.text = "\(goal.name) \(goal.current) / \(goal.target) steps"
        cell.backgroundColor = goal.tracked ? UIColor(red: 165 / 255, green: 236 / 255, blue: 215 / 255, alpha: 1) : .white

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.goal = goals[indexPath.row]
        detailViewController.tableIndex = indexPath.row
        
        // Get notified when detail view saves / deletes
        detailViewController.delegate = self
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let navigationController = appDelegate.window!.rootViewController as! UINavigationController

        navigationController.pushViewController(detailViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func refresh() {
        goals = Persistence.getGoals()!
        self.tableView.reloadData()
        
        if (refreshControl!.isRefreshing) {
            refreshControl?.endRefreshing()
        }
    }

    func didScrollTo(indexPath: IndexPath) {
        if (indexPath.row == swipeIndexPathRow) {
            refresh()
        }
    }
    
    func detailDidSave(goal: Goal, index: Int) {
        goals[index] = goal
        self.tableView.reloadData()
    }
    
    func detailDidDelete(index: Int) {
        goals.remove(at: index)
        self.tableView.reloadData()
    }
    
    func detailDidToggleTrack(index: Int) {
        // Only one can be tracked at a time
        goals = goals.enumerated().map { (i, goal) in
            if (i == index) {
                goalTableControllerDelegate?.didToggleTrackGoal(goal: goal, isTracking: goal.tracked)
            } else {
                goal.tracked = false
            }
            
            return goal
        }
        
        Persistence.saveContext()
        tableView.reloadData()
    }
}

class CustomTableCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol GoalTableControllerDelegate: class {
    func didToggleTrackGoal(goal: Goal, isTracking: Bool)
}
