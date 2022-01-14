//
//  SettingViewController.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 12.01.2022.
//

import UIKit

protocol SettingViewControllerDelegate: AnyObject {
    func updateInterface(color: UIColor?, big: Bool?, medium: Bool?, small: Bool?)
}

class SettingViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    @IBOutlet weak var bigSizeCellButton: UIButton!
    @IBOutlet weak var mediumSizeCellButton: UIButton!
    @IBOutlet weak var smallSizeCellButton: UIButton!
    
    weak var delegate: SettingViewControllerDelegate?
    var small = false
    var medium = false
    var big = false
    var color = UIColor.white
    
    
    @IBAction func chooseBigSizeButton(_ sender: UIButton) {
        big = true
        small = false
        medium = false
        self.delegate?.updateInterface(color: color, big: big, medium: medium, small: small)
    }
    
    @IBAction func chooseMediumSizeButton(_ sender: UIButton) {
        small = false
        medium = true
        big = false
        self.delegate?.updateInterface(color: color, big: big, medium: medium, small: small)
    }
    
    @IBAction func chooseSmallSizeButton(_ sender: UIButton) {
        small = true
        medium = false
        big = false
        self.delegate?.updateInterface(color: color, big: big, medium: medium, small: small)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func selectColorButton(_ sender: Any) {
        
        let picker = UIColorPickerViewController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    
//    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
//        let color = viewController.selectedColor
//    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.color = viewController.selectedColor
        view.backgroundColor = color
        self.delegate?.updateInterface(color: color, big: big, medium: medium, small: small)
    }
    
}
