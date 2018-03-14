import UIKit

class MainPageCell : UICollectionViewCell {
    let mainImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "squirrel"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        
        return imageView
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isHidden = true
        textView.backgroundColor = UIColor(white: 1, alpha: 0.0)
        textView.textColor = .white
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.textAlignment = .center
        textView.text = ""
        
        return textView
    }()
    
    let goalPickerView: PickerController = {
        let pickerView = PickerController()

        pickerView.goals = [50, 100, 500, 1000, 2000, 3000, 4000, 5000].map { "\($0) Steps" }
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        return pickerView
    }()
    
    lazy var addGoalButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Set Goal", for: .normal)
        button.setTitle("Set", for: .highlighted)
        button.setTitleColor(.green, for: .highlighted)
        button.tintColor = .white
        button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        button.addTarget(self, action: #selector(addGoal), for: .touchUpInside)
        
        return button
    }()
    
    @objc func addGoal(button: UIButton) {
        let targets: [Int16] = [50, 100, 500, 1000, 2000, 3000, 4000, 5000]
        let index = goalPickerView.selectedRow(inComponent: 0)
        
        descriptionTextView.text = "Goal added: \(targets[index]) steps"
        descriptionTextView.isHidden = false
        mainImageView.isHidden = false

        Persistence.addGoal(name: "Hello", target: targets[index])
    }

    override init(frame: CGRect) {
        super.init(frame: frame) 
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(mainImageView)
        addSubview(descriptionTextView)
        addSubview(goalPickerView)
        addSubview(addGoalButton)

        NSLayoutConstraint.activate([
            mainImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainImageView.topAnchor.constraint(equalTo: topAnchor, constant: 100),
            mainImageView.widthAnchor.constraint(equalToConstant: 200),
            mainImageView.heightAnchor.constraint(equalToConstant: 100),
            
            goalPickerView.topAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 50),
            goalPickerView.leftAnchor.constraint(equalTo: leftAnchor),
            goalPickerView.rightAnchor.constraint(equalTo: rightAnchor),
            
            addGoalButton.topAnchor.constraint(equalTo: goalPickerView.bottomAnchor, constant: 20),
            addGoalButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addGoalButton.widthAnchor.constraint(equalToConstant: 150),
            addGoalButton.heightAnchor.constraint(equalToConstant: 150),
            
            descriptionTextView.bottomAnchor.constraint(equalTo: mainImageView.bottomAnchor, constant: 20),
            descriptionTextView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
