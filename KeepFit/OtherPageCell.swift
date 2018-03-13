import UIKit

// Placeholder view for development, nothing to see here
class OtherPageCell : UICollectionViewCell {
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.textAlignment = .center
        textView.text = "Other View"
//        textView.textColor = .white
        
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(descriptionTextView)
        
        NSLayoutConstraint.activate([
//            descriptionTextView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 50),
            descriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
            descriptionTextView.leftAnchor.constraint(equalTo: leftAnchor),
            descriptionTextView.rightAnchor.constraint(equalTo: rightAnchor),
//            descriptionTextView.bottomAnchor.constraint(equalTo:  bottomAnchor, constant: 120)
        ])
    }
}

