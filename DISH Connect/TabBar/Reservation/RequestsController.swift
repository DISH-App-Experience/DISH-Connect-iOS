//
//  RequestsController.swift
//  DISH Connect
//
//  Created by JJ Zapata on 6/19/21.
//

import UIKit
import Firebase
import MBProgressHUD

class RequestsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Constants

    // MARK: - Variables
    
    var reservations = [Reservation]()

    // MARK: - View Objects
    
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ReservationsRequestsCell.self, forCellReuseIdentifier: ReservationsRequestsCell.identifier)
        return tableView
    }()
    
    let nilView : UIView = {
        let view = UIView()
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let nilTitle : UILabel = {
        let label = UILabel()
        label.text = "Nothing here...\nWe'll notify you when someone requests a reservation!"
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    let nilImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyMenu")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        return imageView
    }()

    // MARK: - Overriden Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = UIColor(named: "backgroundColor")!

        navigationItem.title = "Requests"

        updateViewConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor.mainBlue
        navigationController?.navigationBar.prefersLargeTitles = false

        backend()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()

        constraints()
    }

    // MARK: - Private Functions

    private func constraints() {
        addNilView()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    func backend() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        reservations.removeAll()
        Database.database().reference().child("Apps").child(globalAppId).child("reservations").observe(DataEventType.childAdded) { snapshot in
            if let value = snapshot.value as? [String : Any] {
                let reservation = Reservation()
                reservation.userId = value["userId"] as? String
                reservation.recipient = value["recipient"] as? String
                reservation.startTime = value["startTime"] as? String
                reservation.endTime = value["endTime"] as? String
                reservation.notes = value["notes"] as? String ?? "noNotes"
                reservation.key = snapshot.key
                reservation.numberOfSeats = value["numberOfSeats"] as? Int
                reservation.timeRequestSubmitted = value["timeRequestSubmitted"] as? Int
                reservation.status = value["status"] as? String
                if reservation.status == "pending" {
                    self.reservations.append(reservation)
                }
            }
            self.reservations.sort(by: {$1.timeRequestSubmitted! > $0.timeRequestSubmitted!})
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    private func addNilView() {
        view.addSubview(nilView)
        nilView.widthAnchor.constraint(equalToConstant: 249).isActive = true
        nilView.heightAnchor.constraint(equalToConstant: 232).isActive = true
        nilView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nilView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        nilView.addSubview(nilTitle)
        nilTitle.widthAnchor.constraint(equalTo: nilView.widthAnchor).isActive = true
        nilTitle.centerXAnchor.constraint(equalTo: nilView.centerXAnchor).isActive = true
        nilTitle.bottomAnchor.constraint(equalTo: nilView.bottomAnchor).isActive = true
        nilTitle.heightAnchor.constraint(equalToConstant: 43).isActive = true
        
        nilView.addSubview(nilImageView)
        nilImageView.topAnchor.constraint(equalTo: nilView.topAnchor).isActive = true
        nilImageView.leftAnchor.constraint(equalTo: nilView.leftAnchor).isActive = true
        nilImageView.rightAnchor.constraint(equalTo: nilView.rightAnchor).isActive = true
        nilImageView.bottomAnchor.constraint(equalTo: nilTitle.topAnchor, constant: -32).isActive = true
    }
    
    private func showNilView() {
        nilView.alpha = 1
        tableView.alpha = 0
    }
    
    private func hideNilView() {
        nilView.alpha = 0
        tableView.alpha = 1
    }
    
    // MARK: - UITableView Delegation
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.reservations.count == 0 {
            showNilView()
            return 0
        } else {
            hideNilView()
            return self.reservations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReservationsRequestsCell.identifier, for: indexPath) as! ReservationsRequestsCell
        cell.reservation = self.reservations[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = RequestController()
        controller.request = self.reservations[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: - Objective-C Functions

}
