//
//  SettingViewController.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 12.01.2022.
//

import UIKit

protocol SettingViewControllerDelegate: AnyObject {
    func updateInterface(color: UIColor?, size: SettingViewController.ChooseSize?)
}

class SettingViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    enum ChooseSize {
        case big
        case medium
        case small
        case noChoose
    }
    
    @IBOutlet weak var bigSizeCellButton: UIButton!
    @IBOutlet weak var mediumSizeCellButton: UIButton!
    @IBOutlet weak var smallSizeCellButton: UIButton!
    
    weak var delegate: SettingViewControllerDelegate?
    private var small = false
    private var medium = false
    private var big = false
    private var color = UIColor.white
    private var defaultColor: UIColor?
    var size = ChooseSize.noChoose
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bigSizeCellButton.setImage(UIImage(named: "big"), for: .normal)
        bigSizeCellButton.setImage(UIImage(named: "complete"), for: .selected)
        
        mediumSizeCellButton.setImage(UIImage(named: "medium"), for: .normal)
        mediumSizeCellButton.setImage(UIImage(named: "complete"), for: .selected)
        
        smallSizeCellButton.setImage(UIImage(named: "small"), for: .normal)
        smallSizeCellButton.setImage(UIImage(named: "complete"), for: .selected)
        
        mediumSizeCellButton.isSelected = true
    }
    
    @IBAction func chooseSizeButton(_ sender: UIButton) {
        switch sender {
        case bigSizeCellButton:
            size = ChooseSize.big
        case mediumSizeCellButton:
            size = ChooseSize.medium
        case smallSizeCellButton:
            size = ChooseSize.small
        default:
            size = ChooseSize.medium
        }
        
        bigSizeCellButton.isSelected = size == .big
        mediumSizeCellButton.isSelected = size == .medium
        smallSizeCellButton.isSelected = size == .small
        
        delegate?.updateInterface(color: color,
                                  size: size)
    }
    
    // MARK: - Select and apply color after selection
    @IBAction func selectColorButton(_ sender: Any) {
        
        let picker = UIColorPickerViewController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    // apply color
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        
        if viewController.selectedColor == color {
            self.delegate?.updateInterface(color: color, size: size)
        } else {
            self.color = viewController.selectedColor
            self.delegate?.updateInterface(color: color, size: size)
        }
    }
}


