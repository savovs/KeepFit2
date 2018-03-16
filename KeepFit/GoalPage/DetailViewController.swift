import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
    var goal: Goal! {
        didSet {
            title = "Goal: \(goal.name!)"
            
            nameTextView.text = goal.name
            currentStepsTextView.text = String(describing: goal.current)
            targetStepsTextView.text = String(describing: goal.target)
        }
    }
    
    let nameTextView: UITextField = {
        let view = UITextField()

        view.placeholder = "Goal Name"
        view.returnKeyType = .done
        
        return view
    }()
    
    
    let currentStepsTextView: UITextField = {
        let view = UITextField()

        view.placeholder = "Current Steps"
        view.keyboardType = .numberPad
        
        return view
    }()
    
    
    let targetStepsTextView: UITextField = {
        let view = UITextField()
        
        view.placeholder = "Target Steps"
        view.keyboardType = .numberPad
        
        return view
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    let bottomMargin: CGFloat = 40

    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        let subviews = [nameTextView, currentStepsTextView, targetStepsTextView, saveButton]
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        view.addSubview(stackView)

        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            if let textField = $0 as? UITextField {
                textField.delegate = self
                textField.borderStyle = .roundedRect
                textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
            }
        }

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        // Hide keyboard on tap away
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tap)
        
        bottomConstraint = NSLayoutConstraint(
            item: stackView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: view,
            attribute: .bottom,
            multiplier: 1,
            constant: -bottomMargin
        )

        view.addConstraint(bottomConstraint!)
        
        setupKeyboardObservers()
    }
    
    func setupKeyboardObservers() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
//  Move text fields above keyboard
    @objc func handleKeyboardNotification(notification: Notification) {
        if let userInfo = notification.userInfo {
            let isShowing = notification.name == .UIKeyboardWillShow
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            
            bottomConstraint?.constant = isShowing ? -(keyboardFrame.height + bottomMargin) : -bottomMargin
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc func endEditing() {
        self.view.endEditing(true)
    }
    
    // Hide keyboard on return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    @objc func saveButtonPressed() {
        self.view.endEditing(true)
        // save context
        navigationController?.popViewController(animated: true)
    }
}
