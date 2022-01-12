//
//  SettingViewController.swift
//  Movie Search App
//
//  Created by Семен Колесников on 12.01.2022.
//

import UIKit

class SettingViewController: UIViewController, UIColorPickerViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectColorButton(_ sender: Any) {
        
        let picker = UIColorPickerViewController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        let color = picker.selectedColor
        view.backgroundColor = color
    }
    
    
}
