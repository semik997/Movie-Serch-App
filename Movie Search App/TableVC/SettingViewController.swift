//
//  SettingViewController.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 12.01.2022.
//

import UIKit

protocol SettingViewControllerDelegate: AnyObject {
    func updateInterface(color: UIColor?, size: SettingViewController.ChooseSize?, view: SettingViewController.ViewWhitchCame?)
}

class SettingViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    enum ViewWhitchCame {
        case main
        case favorite
    }
    
    enum ChooseSize: Codable {
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
    private var defaultMainSize = UserDefaultManager.shared.mainViewSettings.sizeCell
    private var defaultFavoriteSize = UserDefaultManager.shared.favoriteViewSettings.sizeCell
    // Special for you Pasha :)
    var viewCum: ViewWhitchCame?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bigSizeCellButton.setImage(UIImage(named: "big"), for: .normal)
        bigSizeCellButton.setImage(UIImage(named: "complete"), for: .selected)
        
        mediumSizeCellButton.setImage(UIImage(named: "medium"), for: .normal)
        mediumSizeCellButton.setImage(UIImage(named: "complete"), for: .selected)
        
        smallSizeCellButton.setImage(UIImage(named: "small"), for: .normal)
        smallSizeCellButton.setImage(UIImage(named: "complete"), for: .selected)
        
        switch viewCum {
        case .main:
            if defaultMainSize == ChooseSize.big {
                bigSizeCellButton.isSelected = true
            } else if defaultMainSize == ChooseSize.medium {
                mediumSizeCellButton.isSelected = true
            } else {
                smallSizeCellButton.isSelected = true
            }
        case .favorite:
            if defaultFavoriteSize == ChooseSize.big {
                bigSizeCellButton.isSelected = true
            } else if defaultFavoriteSize == ChooseSize.medium {
                mediumSizeCellButton.isSelected = true
            } else {
                smallSizeCellButton.isSelected = true
            }
        case .none:
            break
        }
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
                                  size: size, view: viewCum)
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
            self.delegate?.updateInterface(color: color, size: size, view: viewCum)
        } else {
            self.color = viewController.selectedColor
            self.delegate?.updateInterface(color: color, size: size, view: viewCum)
        }
    }
}


