//
//  SettingViewController.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 12.01.2022.
//

import UIKit

class SettingViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    var mainCollectionVC = MainCollectionVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func selectColorButton(_ sender: Any) {
        
        let picker = UIColorPickerViewController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        view.backgroundColor = color
        self.mainCollectionVC.changeColor(colorCompletion: color)
    }
    
}
