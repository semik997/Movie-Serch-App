//
//  TableViewController.swift
//  Movie Search App
//
//  Created by Sem Koliesnikov on 12.01.2022.
//

import UIKit

class InfoTableViewController: UITableViewController {
    
    weak var delegate: MainCollectionVC!
    let array = ["Row 1",
                 "Row 2",
                 "Row 3"]
    
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
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let textData = array[indexPath.row]
        cell.textLabel?.text = textData
        
        return cell
    }
    
    
    


}
