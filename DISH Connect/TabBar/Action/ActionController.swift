//
//  Action.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/5/21.
//

import UIKit
import Firebase
import MBProgressHUD
import JJFloatingActionButton

class ActionController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Constants
    
    let pickerView = UIPickerView()
    
    let categories = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"]
    
    // MARK: - Variables
    
    var features = [String]()
    
    var selectedRewardsItem : MenuItem?
    
    var items = [MenuItem]()
    
    var control : UISegmentedControl?
    
    var fab : JJFloatingActionButton?
    
    var eventsList = [EventObject]()
    
    var promosList = [Promotion]()
    
    var saveBBI : UIBarButtonItem?
    
    var scans = [Scan]()
    
    // MARK: - View Objects
    
    let eventView : UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(named: "backgroundColor")!
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let promoView : UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(named: "backgroundColor")!
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rewardsView : UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let eventsTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        tableView.register(EventsCell.self, forCellReuseIdentifier: EventsCell.identifier)
        return tableView
    }()
    
    let promosTableView : UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        tableView.register(PromosCell.self, forCellReuseIdentifier: PromosCell.identifier)
        return tableView
    }()
    
    let eventNilView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let promoNilView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let eventNilImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyLocation")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    let eventNilTitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "mainTextColor")!
        label.text = "No Events Yet...\nAdd some now!"
        label.numberOfLines = 3
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let promoNilImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyLocation")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()
    
    let promoNilTitleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "mainTextColor")!
        label.text = "No Promos Yet...\nAdd some now!"
        label.numberOfLines = 3
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let rewardsImageView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#DAEBFF")
        view.layer.cornerRadius = 50
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let rewardsImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.clear
        imageView.tintColor = UIColor.mainBlue
        imageView.image = UIImage(systemName: "crown")
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        return imageView
    }()
    
    let rewardItemNameTF : MainTextField = {
        let textField = MainTextField(placeholderString: "Reward Item Name")
        return textField
    }()
    
    let allowOnlyScanOrder : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.label
        label.text = "Allow 'Rewards Points' when checking out"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let orderScanSwitch : UISwitch = {
        let switcher = UISwitch()
        switcher.translatesAutoresizingMaskIntoConstraints = false
        switcher.onTintColor = UIColor.mainBlue
        return switcher
    }()
    
    let historuLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.label
        label.text = "Scan History"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(ScanHistoryCell.self, forCellReuseIdentifier: ScanHistoryCell.identifier)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Overriden Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor(named: "backgroundColor")!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        backend()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor.mainBlue
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.always
        
        navigationItem.backButtonTitle = "Back"
        navigationItem.title = "Action"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        control?.removeFromSuperview()
        fab?.removeFromSuperview()
    }
    
    // MARK: - Private Functions
    
    private func backend() {
        MBProgressHUD.showAdded(to: view, animated: true)
        checkFeatures()
    }
    
    private func checkFeatures() {
        // check for events
        features.removeAll()
        events()
    }
    
    private func events() {
        Database.database().reference().child("Apps").child(globalAppId).child("features").child("newsEvents").observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? Bool {
                if value {
                    self.features.append("Events")
                    self.checkEvents()
                    // check for promos
                    self.promos()
                } else {
                    // check for promos
                    self.promos()
                }
            }
        }
    }
    
    private func promos() {
        Database.database().reference().child("Apps").child(globalAppId).child("features").child("sendPromos").observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? Bool {
                if value {
                    self.features.append("Promos")
                    self.checkPromos()
                    // check for rewards
                    self.rewards()
                } else {
                    // check for rewards
                    self.rewards()
                }
            }
        }
    }
    
    private func rewards() {
        Database.database().reference().child("Apps").child(globalAppId).child("features").child("rewardProgram").observeSingleEvent(of: DataEventType.value) { (snapshot) in
            if let value = snapshot.value as? Bool {
                if value {
                    self.features.append("Rewards")
                    self.checkItems()
                    self.checkRewardHistory()
                    self.rewardsBackend()
                    // create segmented control
                    self.createSegmentedControl(withItems: self.features)
                } else {
                    // create segmented control
                    self.createSegmentedControl(withItems: self.features)
                }
            }
        }
    }
    
    private func createSegmentedControl(withItems items: [String]) {
        control = UISegmentedControl(items: items)
        control!.translatesAutoresizingMaskIntoConstraints = false
        control!.backgroundColor = UIColor(named: "secondaryBackground")!
        control!.selectedSegmentIndex = 0
        control!
        control!.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: UIControl.State.selected)
        control!.selectedSegmentTintColor = UIColor.mainBlue
        control!.addTarget(self, action: #selector(segmentControlTapped(_:)), for: .valueChanged)
        
        // constraints
        view.addSubview(control!)
        control!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        control!.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        control!.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        control!.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        setupEventView()
        setupPromoView()
        setupRewardsView()
        
        showView(withName: features[0])
        floatingActionButton()
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    private func showView(withName name: String) {
        switch name {
        case "Events":
            prioritizeView(view: eventView, hideView1: rewardsView, hideView2: promoView)
        case "Promos":
            prioritizeView(view: promoView, hideView1: rewardsView, hideView2: eventView)
        case "Rewards":
            prioritizeView(view: rewardsView, hideView1: promoView, hideView2: eventView)
        default:
            print("undecided view")
        }
    }
    
    private func setupEventView() {
        view.addSubview(eventView)
        eventView.topAnchor.constraint(equalTo: control!.bottomAnchor, constant: 15).isActive = true
        eventView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        eventView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        eventView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        
        eventView.addSubview(eventNilView)
        eventNilView.widthAnchor.constraint(equalToConstant: 249).isActive = true
        eventNilView.heightAnchor.constraint(equalToConstant: 232).isActive = true
        eventNilView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        eventNilView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        eventNilView.addSubview(eventNilImageView)
        eventNilImageView.topAnchor.constraint(equalTo: eventNilView.topAnchor).isActive = true
        eventNilImageView.leftAnchor.constraint(equalTo: eventNilView.leftAnchor).isActive = true
        eventNilImageView.rightAnchor.constraint(equalTo: eventNilView.rightAnchor).isActive = true
        eventNilImageView.heightAnchor.constraint(equalToConstant: 161).isActive = true
        
        eventNilView.addSubview(eventNilTitleLabel)
        eventNilTitleLabel.topAnchor.constraint(equalTo: eventNilImageView.bottomAnchor).isActive = true
        eventNilTitleLabel.leftAnchor.constraint(equalTo: eventNilImageView.leftAnchor).isActive = true
        eventNilTitleLabel.rightAnchor.constraint(equalTo: eventNilImageView.rightAnchor).isActive = true
        eventNilTitleLabel.bottomAnchor.constraint(equalTo: eventNilView.bottomAnchor).isActive = true
        
        eventView.addSubview(eventsTableView)
        eventsTableView.delegate = self
        eventsTableView.backgroundColor = UIColor(named: "backgroundColor")!
        eventsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        eventsTableView.dataSource = self
        eventsTableView.topAnchor.constraint(equalTo: eventView.topAnchor).isActive = true
        eventsTableView.bottomAnchor.constraint(equalTo: eventView.bottomAnchor).isActive = true
        eventsTableView.leftAnchor.constraint(equalTo: eventView.leftAnchor).isActive = true
        eventsTableView.rightAnchor.constraint(equalTo: eventView.rightAnchor).isActive = true
        
        fab?.removeFromSuperview()
        floatingActionButton()
    }
    
    private func setupPromoView() {
        view.addSubview(promoView)
        promoView.topAnchor.constraint(equalTo: control!.bottomAnchor, constant: 15).isActive = true
        promoView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        promoView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        promoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        
        promoView.addSubview(promoNilView)
        promoNilView.widthAnchor.constraint(equalToConstant: 249).isActive = true
        promoNilView.heightAnchor.constraint(equalToConstant: 232).isActive = true
        promoNilView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        promoNilView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        promoNilView.addSubview(promoNilImageView)
        promoNilImageView.topAnchor.constraint(equalTo: promoNilView.topAnchor).isActive = true
        promoNilImageView.leftAnchor.constraint(equalTo: promoNilView.leftAnchor).isActive = true
        promoNilImageView.rightAnchor.constraint(equalTo: promoNilView.rightAnchor).isActive = true
        promoNilImageView.heightAnchor.constraint(equalToConstant: 161).isActive = true
        
        promoNilView.addSubview(promoNilTitleLabel)
        promoNilTitleLabel.topAnchor.constraint(equalTo: promoNilImageView.bottomAnchor).isActive = true
        promoNilTitleLabel.leftAnchor.constraint(equalTo: promoNilImageView.leftAnchor).isActive = true
        promoNilTitleLabel.rightAnchor.constraint(equalTo: promoNilImageView.rightAnchor).isActive = true
        promoNilTitleLabel.bottomAnchor.constraint(equalTo: promoNilView.bottomAnchor).isActive = true
        
        promoView.addSubview(promosTableView)
        promosTableView.delegate = self
        promosTableView.backgroundColor = UIColor(named: "backgroundColor")!
        promosTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        promosTableView.dataSource = self
        promosTableView.topAnchor.constraint(equalTo: promoView.topAnchor).isActive = true
        promosTableView.bottomAnchor.constraint(equalTo: promoView.bottomAnchor).isActive = true
        promosTableView.leftAnchor.constraint(equalTo: promoView.leftAnchor).isActive = true
        promosTableView.rightAnchor.constraint(equalTo: promoView.rightAnchor).isActive = true
        
        fab?.removeFromSuperview()
        floatingActionButton()
    }
    
    private func setupRewardsView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        view.addSubview(rewardsView)
        rewardsView.topAnchor.constraint(equalTo: control!.bottomAnchor, constant: 15).isActive = true
        rewardsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        rewardsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        rewardsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        
        rewardsView.addSubview(rewardsImageView)
        rewardsImageView.topAnchor.constraint(equalTo: rewardsView.topAnchor).isActive = true
        rewardsImageView.leftAnchor.constraint(equalTo: rewardsView.leftAnchor).isActive = true
        rewardsImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        rewardsImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        rewardsView.addSubview(rewardsImage)
        rewardsImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        rewardsImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        rewardsImage.centerYAnchor.constraint(equalTo: rewardsImageView.centerYAnchor).isActive = true
        rewardsImage.centerXAnchor.constraint(equalTo: rewardsImageView.centerXAnchor).isActive = true
        
        rewardsView.addSubview(rewardItemNameTF)
        rewardItemNameTF.delegate = self
        rewardItemNameTF.inputView = pickerView
        rewardItemNameTF.topAnchor.constraint(equalTo: rewardsImageView.topAnchor).isActive = true
        rewardItemNameTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        rewardItemNameTF.leftAnchor.constraint(equalTo: rewardsImageView.rightAnchor, constant: 16).isActive = true
        rewardItemNameTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        
        rewardsView.addSubview(rewardItemNameTF)
        rewardItemNameTF.delegate = self
        rewardItemNameTF.topAnchor.constraint(equalTo: rewardsImageView.topAnchor).isActive = true
        rewardItemNameTF.heightAnchor.constraint(equalToConstant: 44).isActive = true
        rewardItemNameTF.leftAnchor.constraint(equalTo: rewardsImageView.rightAnchor, constant: 16).isActive = true
        rewardItemNameTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        
        rewardsView.addSubview(orderScanSwitch)
        orderScanSwitch.topAnchor.constraint(equalTo: rewardItemNameTF.bottomAnchor, constant: 60).isActive = true
        orderScanSwitch.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        orderScanSwitch.widthAnchor.constraint(equalToConstant: 51).isActive = true
        orderScanSwitch.heightAnchor.constraint(equalToConstant: 31).isActive = true
        
        rewardsView.addSubview(allowOnlyScanOrder)
        allowOnlyScanOrder.centerYAnchor.constraint(equalTo: orderScanSwitch.centerYAnchor).isActive = true
        allowOnlyScanOrder.heightAnchor.constraint(equalToConstant: 44).isActive = true
        allowOnlyScanOrder.rightAnchor.constraint(equalTo: orderScanSwitch.leftAnchor, constant: -10).isActive = true
        allowOnlyScanOrder.leftAnchor.constraint(equalTo: rewardsImageView.leftAnchor).isActive = true
        
        rewardsView.addSubview(historuLabel)
        historuLabel.topAnchor.constraint(equalTo: allowOnlyScanOrder.bottomAnchor, constant: 16).isActive = true
        historuLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        historuLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        historuLabel.leftAnchor.constraint(equalTo: rewardsImageView.leftAnchor).isActive = true
        
        rewardsView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.topAnchor.constraint(equalTo: historuLabel.bottomAnchor, constant: 6).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -6).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        tableView.leftAnchor.constraint(equalTo: rewardsImageView.leftAnchor).isActive = true
        
        fab?.removeFromSuperview()
        floatingActionButton()
    }
    
    private func prioritizeView(view: UIView, hideView1: UIView, hideView2: UIView) {
        view.alpha = 1
        self.view.bringSubviewToFront(view)
        
        hideView1.alpha = 0
        self.view.sendSubviewToBack(hideView1)
        
        hideView2.alpha = 0
        self.view.sendSubviewToBack(hideView2)
        
        fab?.removeFromSuperview()
        floatingActionButton()
    }
    
    private func floatingActionButton() {
        fab = JJFloatingActionButton()
        
        if features.contains("Rewards") {
            var newFeatures = features
            newFeatures.removeLast()
            for feature in newFeatures {
                var title = feature
                title.removeLast()
                fab!.addItem(title: title, image: UIImage(named: title)) { (item) in
                    if title == "Promo" {
                        self.presentPromotionControllerDetailed(withAction: "POST", withPostId: "none")
                    } else {
                        self.presentEventControllerDetailed(withAction: "POST", withPostId: "none")
                    }
                }
            }
        } else {
            for feature in features {
                var title = feature
                title.removeLast()
                fab!.addItem(title: title, image: UIImage(named: title)) { (item) in
                    if title == "Promo" {
                        self.presentPromotionControllerDetailed(withAction: "POST", withPostId: "none")
                    } else {
                        self.presentEventControllerDetailed(withAction: "POST", withPostId: "none")
                    }
                }
            }
        }
        
        fab!.buttonColor = UIColor.mainBlue
        fab!.buttonImageColor = UIColor.white
        fab!.shadowColor = UIColor.clear
        view.addSubview(fab!)
        fab!.translatesAutoresizingMaskIntoConstraints = false
        fab!.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        fab!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        
        view.bringSubviewToFront(fab!)
    }
    
    private func checkEvents() {
        eventsList.removeAll()
        let production = Database.database().reference().child("Apps").child(globalAppId).child("events")
//        let testing = Database.database().reference().child("Apps").child(globalAppId).child("events2")
        production.observe(DataEventType.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let event = EventObject()
                event.name = value["name"] as? String
                event.desc = value["desc"] as? String
                event.date = value["date"] as? Int
                event.location = value["location"] as? String
                event.imageString = value["imageString"] as? String
                event.key = value["key"] as? String ?? snapshot.key
                self.eventsList.append(event)
            }
            let newArr = self.eventsList.sorted(by: { $1.date! < $0.date! } )
            self.eventsList.removeAll()
            self.eventsList = newArr
            self.eventsTableView.reloadData()
        }
    }
    
    private func checkPromos() {
        promosList.removeAll()
        let production = Database.database().reference().child("Apps").child(globalAppId).child("promotions")
//        let testing = Database.database().reference().child("Apps").child(globalAppId).child("promotions2")
        production.observe(DataEventType.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let promo = Promotion()
                promo.name = value["name"] as? String
                promo.desc = value["desc"] as? String
                promo.date = value["date"] as? Int
                promo.code = value["code"] as? String ?? "NONE"
                promo.validUntil = value["validUntil"] as? Int
                promo.key = value["key"] as? String ?? snapshot.key
                self.promosList.append(promo)
            }
            let newArr = self.promosList.sorted(by: { $1.validUntil! < $0.validUntil! } )
            self.promosList.removeAll()
            self.promosList = newArr
            self.promosTableView.reloadData()
        }
    }
    
    private func checkRewardHistory() {
        scans.removeAll()
        let production = Database.database().reference().child("Analytics").child("rewardsCardsScans")
        production.observe(DataEventType.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let scan = Scan()
                scan.time = value["time"] as? Int
                scan.restaurantId = value["restaurantId"] as? String
                scan.userId = value["userId"] as? String
                if scan.restaurantId == globalAppId {
                    self.scans.append(scan)
                }
            }
            print("done backend")
            self.scans = self.scans.sorted(by: { $1.time! < $0.time! } )
            self.tableView.reloadData()
        }
    }
    
    private func rewardsBackend() {
        Database.database().reference().child("Apps").child(globalAppId).child("rewards").child("rewardId").observe(DataEventType.value) { snapshot in
            if let value = snapshot.value as? String {
                for item in self.items {
                    if item.key == value {
                        self.rewardItemNameTF.text = item.title!
                    }
                }
            } else {
                self.rewardItemNameTF.text = "Choose Reward Here!"
            }
        }
        
        Database.database().reference().child("Apps").child(globalAppId).child("rewards").child("allowCheckoutWithScanOnly").observe(DataEventType.value) { snapshot in
            if let value = snapshot.value as? Bool {
                self.orderScanSwitch.isOn = value
            } else {
                self.orderScanSwitch.isOn = false
            }
        }
    }
    
    private func hideNilEvent() {
        print("hiding nil view for events")
        UIView.animate(withDuration: 0.5) {
            self.eventsTableView.alpha = 1
        }
    }
    
    private func showNilEvent() {
        print("show nil view for events")
        UIView.animate(withDuration: 0.5) {
            self.eventsTableView.alpha = 0
        }
    }
    
    private func hideNilPromo() {
        print("hiding nil view for promos")
        UIView.animate(withDuration: 0.5) {
            self.promosTableView.alpha = 1
        }
    }
    
    private func showNilPromo() {
        print("showing nil view for promos")
        UIView.animate(withDuration: 0.5) {
            self.promosTableView.alpha = 0
        }
    }
    
    private func checkItems() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        items.removeAll()
        Database.database().reference().child("Apps").child(globalAppId).child("menu").child("items").observe(DataEventType.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let item = MenuItem()
                item.title = value["title"] as? String
                item.desc = value["description"] as? String
                item.price = value["price"] as? Double
                item.category = value["category"] as? String
                item.image = value["image"] as? String
                item.timeStamp = value["time"] as? Int
                item.key = value["key"] as? String ?? snapshot.key
                self.items.append(item)
            }
            DispatchQueue.main.async {
                let sortedList = self.items.sorted(by: { $1.timeStamp! < $0.timeStamp! } )
                self.items.removeAll()
                self.items = sortedList
                self.pickerView.reloadInputViews()
                self.pickerView.reloadAllComponents()
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    // MARK: - Objective-C Functions
    
    @objc func segmentControlTapped(_ segmentedControl: UISegmentedControl) {
        if features[segmentedControl.selectedSegmentIndex] == "Rewards" {
            navigationItem.rightBarButtonItem = nil
            saveBBI = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.saveInformmation))
            navigationItem.rightBarButtonItem = saveBBI
        } else {
            navigationItem.rightBarButtonItem = nil
        }
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            showView(withName: features[0])
            print("selected 0: \(features[segmentedControl.selectedSegmentIndex])")
        case 1:
            showView(withName: features[1])
            print("selected 1: \(features[segmentedControl.selectedSegmentIndex])")
        case 2:
            showView(withName: features[2])
            print("selected 2: \(features[segmentedControl.selectedSegmentIndex])")
        default:
            print("selected default")
        }
    }
    
    @objc func saveInformmation() {
        Database.database().reference().child("Apps").child(globalAppId).child("rewards").child("rewardId").setValue(selectedRewardsItem!.key!)
        
        Database.database().reference().child("Apps").child(globalAppId).child("rewards").child("allowCheckoutWithScanOnly").setValue(Bool(self.orderScanSwitch.isOn))
        
        simpleAlert(title: "Success", message: "Information successfully saved!")
    }
    
    // MARK: - UITableView Delegation
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case eventsTableView:
            if eventsList.count == 0 {
                showNilEvent()
            } else {
                hideNilEvent()
            }
            return eventsList.count
        case promosTableView:
            if promosList.count == 0 {
                showNilPromo()
            } else {
                hideNilPromo()
            }
            return promosList.count
        default:
            return self.scans.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case eventsTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: EventsCell.identifier, for: indexPath) as! EventsCell
            
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.backgroundColor = UIColor(named: "backgroundColor")!
            
            if let imageString = self.eventsList[indexPath.row].imageString {
                cell.itemImageView.loadImageUsingUrlString(urlString: imageString)
            }
            
            if let title = self.eventsList[indexPath.row].name {
                cell.itemTitleLabel.text = title
            }
            
            if let desc = self.eventsList[indexPath.row].desc {
                cell.itemDescLabel.text = desc
            }
            
            if let date = self.eventsList[indexPath.row].date {
                let formatter = DateFormatter()
                formatter.dateFormat = "E, d MMMM yyyy"
                cell.itemCatLabel.text = "\(formatter.string(from: Date(timeIntervalSince1970: TimeInterval(date))))"
            }
            
            return cell
        case promosTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: PromosCell.identifier, for: indexPath) as! PromosCell
            
            if let title = self.promosList[indexPath.row].name {
                cell.itemTitleLabel.text = title
            }
            
            if let validUntil = self.promosList[indexPath.row].validUntil, let code = self.promosList[indexPath.row].code {
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM d, yyyy"
                let expirationDate = Date(timeIntervalSince1970: TimeInterval(validUntil))
                if code == "NONE" || code == "" {
                    cell.itemDescLabel.text = "VALID UNTIL: \(formatter.string(from: expirationDate))"
                } else {
                    cell.itemDescLabel.text = "VALID UNTIL: \(formatter.string(from: expirationDate)) - Use Code: \(code)."
                }
            }
            
            return cell
        case self.tableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: ScanHistoryCell.identifier, for: indexPath) as! ScanHistoryCell
            cell.scan = self.scans[indexPath.row]
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: ScanHistoryCell.identifier, for: indexPath) as! ScanHistoryCell
            cell.scan = self.scans[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableView {
        case eventsTableView:
            return 110
        case promosTableView:
            return 85
        default:
            return 85
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case eventsTableView:
            presentEventControllerDetailed(withAction: "GET", withPostId: eventsList[indexPath.row].key!)
        case promosTableView:
            presentPromotionControllerDetailed(withAction: "GET", withPostId: promosList[indexPath.row].key!)
        default:
            print("extra item selected")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - UIPickerView Delegation
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row].title!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRewardsItem = items[row]
        rewardItemNameTF.text = items[row].title!
    }
    
}
