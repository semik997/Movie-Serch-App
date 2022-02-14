//
//  SettingViewController.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 12.01.2022.
//

import UIKit

protocol SettingViewControllerDelegate: AnyObject {
    func updateInterface(color: UIColor?,
                         size: SettingViewController.ChooseSize?,
                         type: UserDefaultManager.SettingType)
}

class SettingViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    enum ChooseSize: Codable {
        case big
        case medium
        case small
        case noChoose
    }
    
    @IBOutlet weak var selectColorButton: UIButton!
    @IBOutlet weak var bigSizeCellButton: UIButton! {
        didSet {
            bigSizeCellButton.setImage(UIImage(named: "big"),
                                       for: .normal)
            bigSizeCellButton.setImage(UIImage(named: "complete"),
                                       for: .selected)
        }
    }
    @IBOutlet weak var mediumSizeCellButton: UIButton! {
        didSet {
            mediumSizeCellButton.setImage(UIImage(named: "medium"),
                                          for: .normal)
            mediumSizeCellButton.setImage(UIImage(named: "complete"),
                                          for: .selected)
        }
    }
    @IBOutlet weak var smallSizeCellButton: UIButton! {
        didSet {
            smallSizeCellButton.setImage(UIImage(named: "small"),
                                         for: .normal)
            smallSizeCellButton.setImage(UIImage(named: "complete"),
                                         for: .selected)
        }
    }
    
    private var small = false
    private var medium = false
    private var big = false
    private var color = UIColor.white
    private var defaultColor: UIColor?
    private var buttonColor: UIColor?
    private lazy var defaultSize = UserDefaultManager.shared.getDefaultSettings(type: settingType)?.sizeCell
    var settingType: UserDefaultManager.SettingType = .mainScreen
    var size = ChooseSize.noChoose
    weak var delegate: SettingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let getDefault = UserDefaultManager.shared.getDefaultSettings(type: settingType)
        
        bigSizeCellButton.isSelected = defaultSize == .big
        mediumSizeCellButton.isSelected = defaultSize == .medium
        smallSizeCellButton.isSelected = defaultSize == .small
        buttonColor = UIColor.hexStringToUIColor(hex: getDefault?.color ?? white)
        selectColorButton.backgroundColor = buttonColor
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
                                  size: size, type: settingType)
    }
    
    // MARK: - Select and apply color after selection
    @IBAction func selectColorButton(_ sender: Any) {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction private func exit(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // apply color
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
            if viewController.selectedColor == color {
                self.delegate?.updateInterface(color: color, size: size, type: settingType)
            } else {
                self.color = viewController.selectedColor
                self.delegate?.updateInterface(color: color, size: size, type: settingType)
            }
            selectColorButton.backgroundColor = color
    }
}


