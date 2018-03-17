import UIKit

let numbers: [Int16] = [50, 100, 500, 1000, 2000, 3000, 4000, 5000]

class TrackController : UIViewController, SwipeControllerDelegate, GoalTableControllerDelegate {
    var trackedGoal: Goal!
    var isTrackingGoal: Bool = false

    let mainImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "squirrel"))
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        
        return imageView
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isHidden = true
        textView.backgroundColor = UIColor(white: 1, alpha: 0.0)
        textView.textColor = .white
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.textAlignment = .center
        
        return textView
    }()
    
    let goalPickerView: PickerController = {
        let pickerView = PickerController()

        pickerView.goals = numbers.map { "\($0) Steps" }
        
        return pickerView
    }()
    
    lazy var addGoalButton: UIButton = {
        let button = UIButton()
        button.setTitle("Set Goal", for: .normal)
        button.setTitle("Set", for: .highlighted)
        button.setTitleColor(.green, for: .highlighted)
        button.tintColor = .white

        button.addTarget(self, action: #selector(addGoal), for: .touchUpInside)
        
        return button
    }()
    
    lazy var stepButtonStack: UIStackView = {
        let addButton = UIButton()
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(.green, for: .highlighted)
        addButton.tintColor = .white
        
        let subtractButton = UIButton()
        subtractButton.setTitle("Subtract", for: .normal)
        subtractButton.setTitleColor(.green, for: .highlighted)
        subtractButton.tintColor = .red
        
        addButton.addTarget(self, action: #selector(addCurrentSteps), for: .touchDown)
        subtractButton.addTarget(self, action: #selector(subtractCurrentSteps), for: .touchDown)
        
        let stackView = UIStackView(arrangedSubviews: [addButton, subtractButton])
        
        return stackView
    }()
    
    @objc func addGoal(button: UIButton) {
        let index = goalPickerView.selectedRow(inComponent: 0)
        
        descriptionTextView.text = "Goal added: \(numbers[index]) steps"
        descriptionTextView.isHidden = false
        mainImageView.isHidden = false
        
        trackedGoal = Persistence.addGoal(name: "", target: numbers[index])
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            self.descriptionTextView.text = "Goal: \(self.trackedGoal.current) / \(self.trackedGoal.target)"
            self.descriptionTextView.isHidden = false
            self.stepButtonStack.isHidden = false
            self.mainImageView.isHidden = true
            self.addGoalButton.isHidden = true
        }
        
        Persistence.addHistoryAction(type: .set, goal: trackedGoal)
    }
    
    @objc func addCurrentSteps() {
        let steps: Int16 = numbers[goalPickerView.selectedRow(inComponent: 0)]
        let newCurrentSteps = trackedGoal.current + steps
        trackedGoal.current = newCurrentSteps <= trackedGoal.target ? newCurrentSteps : trackedGoal.target

        
        
        Persistence.saveContext()
        
        if (newCurrentSteps < trackedGoal.target) {
            descriptionTextView.text = "Goal: \(trackedGoal.current) / \(trackedGoal.target)"
            Persistence.addHistoryAction(type: .add, goal: trackedGoal, amount: steps)
            
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        } else {
            descriptionTextView.text = "Goal complete: \(trackedGoal.target) steps!"
            stepButtonStack.isHidden = true
            addGoalButton.isHidden = false
            Persistence.addHistoryAction(type: .complete, goal: trackedGoal)
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
    
    
    @objc func subtractCurrentSteps() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        let steps: Int16 = numbers[goalPickerView.selectedRow(inComponent: 0)]
        let newCurrentSteps = trackedGoal.current - steps
        trackedGoal.current = newCurrentSteps > 0 ? newCurrentSteps : 0
        
        descriptionTextView.text = "Goal: \(trackedGoal.current) / \(trackedGoal.target)"
        
        Persistence.saveContext()
        Persistence.addHistoryAction(type: .subtract, goal: trackedGoal, amount: steps)
    }

    override func viewDidLoad() {
        setupLayout()
        refresh()
    }
    
    private func setupLayout() {
        let subviews = [mainImageView, descriptionTextView, goalPickerView, addGoalButton, stepButtonStack]
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
            
            if let button = $0 as? UIButton {
                button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            }
        }

        NSLayoutConstraint.activate([
            mainImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            mainImageView.widthAnchor.constraint(equalToConstant: 200),
            mainImageView.heightAnchor.constraint(equalToConstant: 100),
            
            goalPickerView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 50),
            goalPickerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            goalPickerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            addGoalButton.topAnchor.constraint(equalTo: goalPickerView.bottomAnchor, constant: 20),
            addGoalButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addGoalButton.widthAnchor.constraint(equalToConstant: 150),
            addGoalButton.heightAnchor.constraint(equalToConstant: 150),
            
            stepButtonStack.topAnchor.constraint(equalTo: goalPickerView.bottomAnchor, constant: 20),
            stepButtonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stepButtonStack.widthAnchor.constraint(equalToConstant: 150),
            stepButtonStack.heightAnchor.constraint(equalToConstant: 150),
            
            descriptionTextView.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 20),
            descriptionTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func didToggleTrackGoal(goal: Goal, isTracking: Bool) {
        trackedGoal = goal
        addGoalButton.isHidden = isTracking
        stepButtonStack.isHidden = !isTracking
        
        descriptionTextView.isHidden = !isTracking
        mainImageView.isHidden = !isTracking
        
        if (isTracking) {
            descriptionTextView.text = "Goal: \(goal.current) / \(goal.target)"
            Persistence.addHistoryAction(type: .track, goal: goal)
        }
    }
    
    func didScrollTo() {
        refresh()
    }
    
    func refresh() {
        if let goal = Persistence.getTrackedGoal() {
            if (goal.current < goal.target) {
                trackedGoal = goal
                descriptionTextView.text = "Goal: \(trackedGoal.current) / \(trackedGoal.target)"
                descriptionTextView.isHidden = false
                addGoalButton.isHidden = true
            } else {
                showAddGoalUI()
            }
        } else {
            showAddGoalUI()
        }
    }
    
    func showAddGoalUI() {
        descriptionTextView.isHidden = true
        stepButtonStack.isHidden = true
        addGoalButton.isHidden = false
    }
}
