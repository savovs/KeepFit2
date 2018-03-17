import UIKit

class HistoryController : UITableViewController, SwipeControllerDelegate {
    private let cellId = "cell"
    var actions: [HistoryAction] = [HistoryAction]()

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let action = actions[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm dd/MM"
        
        let types: [HistoryAction.type] = [.add, .subtract]
        let rawTypes = types.map { $0.rawValue }
        
        if (rawTypes.contains(action.typeString)) {
            // Shorter text for more frequent actions
            cell.textLabel?.text = (action.text)
        } else {
            cell.textLabel?.text = "\(action.text) at \(dateFormatter.string(from: action.date as Date))"
        }
        print(action.typeString)
        
        if (action.typeString == HistoryAction.type.complete.rawValue) {
            cell.backgroundColor = .mintGreen
        }
        
        return cell
    }

    override func viewDidLoad() {
        setupLayout()
        refresh()
    }
    
    private func setupLayout() {
        tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(
            self,
            action: #selector(refresh),
            for: UIControlEvents.valueChanged
        )
    }
    
    func didScrollTo() {
        refresh()
    }
    
    @objc func refresh() {
        actions = Persistence.getHistoryActions().reversed()
        tableView.reloadData()

        if (refreshControl!.isRefreshing) {
            refreshControl?.endRefreshing()
        }
    }
    
    @objc func clearButtonTapped() {
        print("Hello")
    }
}


