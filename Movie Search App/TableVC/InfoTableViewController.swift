//
//  TableViewController.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 12.01.2022.
//

import UIKit

class InfoTableViewController: UITableViewController, SettingViewControllerDelegate {
    
    @IBOutlet weak var settingViewButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    weak var delegate: MainCollectionVC!
    weak var delegateFav: FavoritesCollectionVC!
    weak var delegateSetting: SettingViewControllerDelegate?
    
    // setup size view
    override var preferredContentSize : CGSize {
        get {
            return CGSize(width: 170 , height: tableView.contentSize.height) }
        set {
            super.preferredContentSize = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews();
        preferredContentSize = CGSize(width: 170, height: tableView.contentSize.height)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    //MARK: - Setting view
    
    // delegate size and color
    func updateInterface(color: UIColor?, big: Bool?, medium: Bool?, small: Bool?) {
        delegateSetting?.updateInterface(color: color, big: big, medium: medium, small: small)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingView" {
            if let tvc = segue.destination as? SettingViewController {
                tvc.delegate = self
            }
        }
    }
    
    // exit
    @IBAction private func exit(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
