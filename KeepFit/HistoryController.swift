import UIKit

class HistoryController : UIViewController {
    var swipeIndexPathRow: Int?
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.textAlignment = .center
        textView.text = "History"
        //        textView.textColor = .white
        
        return textView
    }()
    
    override func viewDidLoad() {
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(descriptionTextView)
        
        NSLayoutConstraint.activate([
            descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            descriptionTextView.leftAnchor.constraint(equalTo: view.leftAnchor),
            descriptionTextView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
}


