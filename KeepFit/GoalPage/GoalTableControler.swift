import UIKit

class GoalTableController : UITableViewController, SwipeControllerDelegate {
    private let cellId = "cell"
    
    var swipeIndexPathRow: Int?
    var goals: [Goal] = [Goal]()

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
        
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditing))
        navigationItem.rightBarButtonItem = editButton
//        navigationItem.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomTableCell
        
        let goal = goals[indexPath.row]
//        cell.progress = CGFloat(goal.current) / CGFloat(goal.target)
        
        cell.textLabel?.text = "\(goal.name!), current: \(goal.current), target: \(goal.target) steps"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            Persistence.context.delete(goals[indexPath.row])
            Persistence.saveContext()
            
            goals.remove(at: indexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.goal = goals[indexPath.row]
        
        let appDelegate  = UIApplication.shared.delegate as! AppDelegate
        let navigationController = appDelegate.window!.rootViewController as! UINavigationController

        navigationController.pushViewController(detailViewController, animated: true)
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
    
    @objc func toggleEditing() {
        tableView.setEditing(!tableView.isEditing, animated: true)

        if (tableView.isEditing == true) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(toggleEditing))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(toggleEditing))
        }
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

