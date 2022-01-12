//
//  TableViewController.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 12.01.2022.
//

import UIKit

class InfoTableViewController: UITableViewController {
    
    weak var delegate: MainCollectionVC!
    weak var delegateFav: FavoritesCollectionVC!
    
    override var preferredContentSize : CGSize
    {
        get
        {
            return CGSize(width: 170 , height: tableView.contentSize.height)
        }
        set
        {
            super.preferredContentSize = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = false
    }
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: 170, height: tableView.contentSize.height)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    @IBAction func exit(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
