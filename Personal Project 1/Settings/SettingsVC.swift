//
//  SettingsVC.swift
//  Personal Project 1
//
//  Created by Daniel Marco S. Rafanan on Dec/19/20.
//  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension SettingsVC:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.rightDetailCell, for: indexPath)
        if indexPath.row == 0{
            cell.textLabel?.text = "Dark Mode"
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            var detailText = ""
            switch UIApplication.shared.windows[0].overrideUserInterfaceStyle {
            case .dark:
                detailText = "Dark"
            case .light:
                detailText = "Light"
            case .unspecified:
                detailText = "System"
            default:
                break
            }
            cell.detailTextLabel?.text = detailText
        }
        return cell
    }
}

extension SettingsVC:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Identifier.settingsToDarkModeChoicesSegue, sender: indexPath.row)
    }
}
