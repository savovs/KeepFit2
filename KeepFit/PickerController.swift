//
//  PickerView.swift
//  AutoLayout
//
//  Created by Vlady Veselinov on 2/6/18.
//  Copyright © 2018 Vlady Veselinov. All rights reserved.
//

import UIKit

class PickerController : UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        delegate = self
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var goals: [String] = []
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return goals.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return goals[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: goals[row], attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        return attributedString
    }
}
