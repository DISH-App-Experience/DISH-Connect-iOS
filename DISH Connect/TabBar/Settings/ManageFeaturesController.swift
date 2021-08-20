//
//  RequestFeatureController.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/6/21.
//

import UIKit
import Firebase
import MBProgressHUD

class ManageFeaturesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Constants
    
    let cellId = "ManageFeatureControllerCellId"
    
    // MARK: - Variables
    
    var features = [Feature]()
    
    // MARK: - View Objects
    
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = UIColor.clear
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        return tableView
    }()
    
    // MARK: - Overriden Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(named: "backgroundColor")!
        
        updateViewConstraints()
        delegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.title = "Manage Features"
        
        backend()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        constraints()
    }
    
    // MARK: - Private Functions
    
    private func constraints() {
        view.addSubview(tableView)
        tableView.register(ManageFeatureCell.self, forCellReuseIdentifier: cellId)
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
    }
    
    private func delegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func backend() {
        MBProgressHUD.showAdded(to: view, animated: true)
        features.removeAll()
        Database.database().reference().child("Apps").child(globalAppId).child("features").child("aboutUs").observeSingleEvent(of: .value) { (AU) in
            if let aboutUsValue = AU.value as? Bool {
                let aboutUs = Feature(name: "About Us", isOn: aboutUsValue, imageName: "about")
                self.features.append(aboutUs)
                Database.database().reference().child("Apps").child(globalAppId).child("features").child("imageGallery").observeSingleEvent(of: .value) { (IG) in
                    if let imageGalleryValue = IG.value as? Bool {
                        let imageGallery = Feature(name: "Image Gallery", isOn: imageGalleryValue, imageName: "imageGallery")
                        self.features.append(imageGallery)
                        Database.database().reference().child("Apps").child(globalAppId).child("features").child("addLocations").observeSingleEvent(of: .value) { (RL) in
                            if let restaurantLocationsValue = RL.value as? Bool {
                                let restaurantLocations = Feature(name: "Restaurant Locations", isOn: restaurantLocationsValue, imageName: "locations")
                                self.features.append(restaurantLocations)
                                Database.database().reference().child("Apps").child(globalAppId).child("features").child("managableMenu").observeSingleEvent(of: .value) { (MM) in
                                    if let manageableMenuValue = MM.value as? Bool {
                                        let manageableMenu = Feature(name: "Manageable Menu", isOn: manageableMenuValue, imageName: "menu")
                                        self.features.append(manageableMenu)
                                        Database.database().reference().child("Apps").child(globalAppId).child("features").child("reservationRequests").observeSingleEvent(of: .value) { (RR) in
                                            if let reservationRequestsValue = RR.value as? Bool {
                                                let reservationRequests = Feature(name: "Reservation Requests", isOn: reservationRequestsValue, imageName: "reservations")
                                                self.features.append(reservationRequests)
                                                Database.database().reference().child("Apps").child(globalAppId).child("features").child("newsEvents").observeSingleEvent(of: .value) { (NE) in
                                                    if let newsEventsValue = NE.value as? Bool {
                                                        let newsEvents = Feature(name: "News & Events", isOn: newsEventsValue, imageName: "newsEvents")
                                                        self.features.append(newsEvents)
                                                        Database.database().reference().child("Apps").child(globalAppId).child("features").child("sendPromos").observeSingleEvent(of: .value) { (SP) in
                                                            if let sendPromosValue = SP.value as? Bool {
                                                                let sendPromos = Feature(name: "Send Promos", isOn: sendPromosValue, imageName: "promos")
                                                                self.features.append(sendPromos)
                                                                Database.database().reference().child("Apps").child(globalAppId).child("features").child("rewardProgram").observeSingleEvent(of: .value) { (RP) in
                                                                    if let rewardsProgramValue = RP.value as? Bool {
                                                                        let rewardsProgram = Feature(name: "Rewards Program", isOn: rewardsProgramValue, imageName: "rewards")
                                                                        self.features.append(rewardsProgram)
                                                                        self.tableView.reloadData()
                                                                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.saveInformmation))
                                                                        MBProgressHUD.hide(for: self.view, animated: true)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func goToTabBar() {
        let controller = TabBarController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - UITableView Delegate & Data Source Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ManageFeatureCell
        
        cell.title.text = features[indexPath.row].name
        
        cell.iconImageView.image = UIImage(named: features[indexPath.row].imageName)
        
        cell.switcher.isOn = features[indexPath.row].isOn
        cell.switcher.tag = indexPath.row
        cell.switcher.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        cell.switcher.onTintColor = UIColor.mainBlue
        
        if indexPath.row == 3 || indexPath.row == 2 {
            cell.switcher.isEnabled = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    // MARK: - Objective-C Functions
    
    @objc func saveInformmation() {
        Database.database().reference().child("Apps").child(globalAppId).child("features").child("aboutUs").setValue(features[0].isOn)
        Database.database().reference().child("Apps").child(globalAppId).child("features").child("imageGallery").setValue(features[1].isOn)
        Database.database().reference().child("Apps").child(globalAppId).child("features").child("addLocations").setValue(features[2].isOn)
        Database.database().reference().child("Apps").child(globalAppId).child("features").child("managableMenu").setValue(features[3].isOn)
        Database.database().reference().child("Apps").child(globalAppId).child("features").child("reservationRequests").setValue(features[4].isOn)
        Database.database().reference().child("Apps").child(globalAppId).child("features").child("newsEvents").setValue(features[5].isOn)
        Database.database().reference().child("Apps").child(globalAppId).child("features").child("sendPromos").setValue(features[6].isOn)
        Database.database().reference().child("Apps").child(globalAppId).child("features").child("rewardProgram").setValue(features[7].isOn)
        let alert = UIAlertController(title: "Success", message: "Please restart the app to see the changed features.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { (action) in
            UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
            exit(0)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
        print("switched at \(sender.isOn)")
        print("table row switch changed at \(sender.tag)")
        features[sender.tag].isOn.toggle()
    }

}
