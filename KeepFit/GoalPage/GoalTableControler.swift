import UIKit

class GoalTableController : UITableViewController, SwipeControllerDelegate {
    private let cellId = "cell"
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
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomTableCell
        
        let goal = goals[indexPath.row]
        cell.progress = Float(goal.target) / Float(goal.current)
        cell.textLabel?.text = "\(goal.name!), target: \(goal.target) steps"

        return cell
    }
    
    
    @objc func refresh() {
        goals = Persistence.getGoals()!
        self.tableView.reloadData()
        
        if (refreshControl!.isRefreshing) {
            refreshControl?.endRefreshing()
        }
    }
    
    func didScrollTo(indexPath: IndexPath) {
        if (indexPath.row == 2) {
            refresh()
        }
    }
}

class CustomTableCell: UITableViewCell {
    var progress: Float = 0

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progress = progress
        
        addSubview(progressView)

        NSLayoutConstraint.activate([
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            progressView.leftAnchor.constraint(equalTo: textLabel!.leftAnchor),
            progressView.rightAnchor.constraint(equalTo: textLabel!.rightAnchor),
        ])

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

