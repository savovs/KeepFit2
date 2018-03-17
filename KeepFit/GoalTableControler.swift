import UIKit

class GoalTableController : UITableViewController, SwipeControllerDelegate, DetailViewControllerDelegate {
    private let cellId = "cell"
    var goals: [Goal] = [Goal]()
    weak var goalTableControllerDelegate: GoalTableControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        tableView.allowsSelection = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let goal = goals[indexPath.row]

        cell.textLabel?.text = "\(goal.name) \(goal.current) / \(goal.target) steps"
        cell.backgroundColor = goal.tracked ? .niceYellow : .white

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
        goals = Persistence.getGoals()
        self.tableView.reloadData()
        
        if (refreshControl!.isRefreshing) {
            refreshControl?.endRefreshing()
        }
    }

    func didScrollTo() {
        refresh()
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

protocol GoalTableControllerDelegate: class {
    func didToggleTrackGoal(goal: Goal, isTracking: Bool)
}
