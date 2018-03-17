import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate {
    var tableIndex: Int!

    var goal: Goal! {
        didSet {
            title = "Goal: \(goal.name)"
            
            nameTextView.text = goal.name
            currentStepsTextView.text = String(describing: goal.current)
            targetStepsTextView.text = String(describing: goal.target)
            trackButton.tintColor = goal.tracked ? .black : .green
            trackButton.setTitle(goal.tracked ? "Untrack" : "Track", for: .normal)
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
    
    let trackButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
        button.setTitle("Track", for: .normal)
        button.addTarget(self, action: #selector(trackButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.tintColor = .red
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 60)
        button.setTitle("Delete", for: .normal)
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    let bottomMargin: CGFloat = 40
    
    weak var delegate: DetailViewControllerDelegate?

    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        let subviews = [nameTextView, currentStepsTextView, targetStepsTextView, trackButton, saveButton, deleteButton]
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
                textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
            }
        }

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 360),
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
            
            bottomConstraint?.constant = isShowing ? -(keyboardFrame.height + bottomMargin - 60) : -bottomMargin
            
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
    
    @objc func trackButtonPressed() {
        goal.tracked = !goal.tracked
        trackButton.tintColor = goal.tracked ? .black : .green
        trackButton.setTitle(goal.tracked ? "Untrack" : "Track", for: .normal)
        delegate?.detailDidToggleTrack(index: tableIndex)
    }

    @objc func saveButtonPressed() {
        self.view.endEditing(true)
        
        let newCurrentSteps = Int16(currentStepsTextView.text!) ?? 0
        let newTargetSteps = Int16(targetStepsTextView.text!) ?? 0

        // Save if changed
        if (
            goal.name != nameTextView.text ||
            goal.current != newCurrentSteps ||
            goal.target != newTargetSteps
        ) {
            goal.name = nameTextView.text!
            
            // Current steps can't be more than Target
            goal.current = newCurrentSteps <= newTargetSteps ? newCurrentSteps : newTargetSteps
            goal.target = newTargetSteps
            
            delegate?.detailDidSave(goal: goal, index: tableIndex)
            Persistence.saveContext()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteButtonPressed() {
        self.view.endEditing(true)
        delegate?.detailDidDelete(index: tableIndex)
        Persistence.delete(object: goal)
        navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length

        return textField.keyboardType == .numberPad ? newLength < 5 : newLength < 25
    }
}

protocol DetailViewControllerDelegate: class {
    func detailDidSave(goal: Goal, index: Int)
    func detailDidDelete(index: Int)
    func detailDidToggleTrack(index: Int)
}
