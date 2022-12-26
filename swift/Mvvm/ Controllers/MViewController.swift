//
//  MViewController.swift
//  swift
//
//  Created by Denny Wongso on 26/12/22.
//

import Foundation
import UIKit

public class MViewController: UIViewController {
    @IBOutlet weak var pickerViewList: UIPickerView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelFriendliness: UILabel!
    @IBOutlet weak var labelGender: UILabel!
    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet weak var labelType: UILabel!
    
    var pets: [Pet] = []
    override public func viewDidLoad() {
        super.viewDidLoad()
        initPet()
        refreshData(row: 0)
    }
    
    func initPet() {
        pets.append(Pet(name: "black", age: 1, gender: .Male, friendliness: 9.9, type: .Dog))
        pets.append(Pet(name: "spoon", age: 1, gender: .Female, friendliness: 7.0, type: .Cat))
        pets.append(Pet(name: "picky", age: 2, gender: .Male, friendliness: 9.0, type: .Bird))
    }
    
    func refreshData(row: Int) {
        labelName.text = pets[row].name
        labelAge.text = String(pets[row].age)
        labelGender.text = pets[row].gender.rawValue
        labelFriendliness.text = String(pets[row].friendliness)
        labelType.text = pets[row].type.rawValue
    }

}

extension MViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pets.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pets[row].name
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        refreshData(row: row)
    }
    
    
}
