//
//  AnalyticsBoard.swift
//  DISH Connect
//
//  Created by JJ Zapata on 7/26/21.
//

import UIKit
import Firebase
import Charts
import MBProgressHUD

class AnalyticsBoard: UIViewController {
    
    // MARK: - Constants

    // MARK: - Variables
    
    var appSessionCount = 0 {
        didSet {
            answer1.text = "\(appSessionCount)"
        }
    }
    
    var reservationsBooked = 0 {
        didSet {
            answer2.text = "\(reservationsBooked)"
        }
    }
    
    var onlineOrders = 0 {
        didSet {
            answer3.text = "\(onlineOrders)"
        }
    }
    
    var calledViaApp = 0 {
        didSet {
            answer4.text = "\(calledViaApp)"
        }
    }
    
    var openedMenus = 0 {
        didSet {
            answer5.text = "\(openedMenus)"
        }
    }
    
    var genderMaleData = PieChartDataEntry(value: 0)
    
    var genderFemaleData = PieChartDataEntry(value: 0)
    
    var numberOfGenderDataEntries = [PieChartDataEntry]()
    
    var zeroToTenData = PieChartDataEntry(value: 0)
    
    var elevenToTwentyData = PieChartDataEntry(value: 0)
    
    var twentyToThirtyData = PieChartDataEntry(value: 0)
    
    var thirtyToFourtyData = PieChartDataEntry(value: 0)
    
    var fourtyToFiftyData = PieChartDataEntry(value: 0)
    
    var fiftyAndAboveData = PieChartDataEntry(value: 0)
    
    var numerOfAgeRanges = [PieChartDataEntry]()

    // MARK: - View Objects
    
    let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor(named: "backgroundColor")!
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let totalsView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "secondaryBackground")!
        view.layer.cornerRadius = 12
        return view
    }()
    
    let title1 : UILabel = {
        let label = UILabel()
        label.text = "App Sessions:"
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let title2 : UILabel = {
        let label = UILabel()
        label.text = "Reservations Booked:"
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let title3 : UILabel = {
        let label = UILabel()
        label.text = "Online Orders:"
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let title4 : UILabel = {
        let label = UILabel()
        label.text = "Call Via App Tapped:"
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let title5 : UILabel = {
        let label = UILabel()
        label.text = "Opened Menus:"
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let answer1 : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = NSTextAlignment.right
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let answer2 : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = NSTextAlignment.right
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let answer3 : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = NSTextAlignment.right
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let answer4 : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = NSTextAlignment.right
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let answer5 : UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = NSTextAlignment.right
        label.textColor = UIColor(named: "mainTextColor")!
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let genderPieChart : PieChartView = {
        let chart = PieChartView()
        chart.chartDescription?.text = "User Gender Demographic"
        chart.holeColor = UIColor(named: "backgroundColor")!
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    let ageRangeChart : PieChartView = {
        let chart = PieChartView()
        chart.chartDescription?.text = "Age Ranges"
        chart.holeColor = UIColor(named: "backgroundColor")!
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()

    // MARK: - Overriden Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.backgroundColor = UIColor(named: "backgroundColor")!

        navigationItem.title = "Analytics"

        updateViewConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor.mainBlue
        navigationController?.navigationBar.prefersLargeTitles = true

        backend()
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()

        constraints()
    }

    // MARK: - Private Functions

    private func constraints() {
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.size.width - 50, height: 900)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(totalsView)
        totalsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        totalsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25).isActive = true
        totalsView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        totalsView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        totalsView.addSubview(title1)
        title1.topAnchor.constraint(equalTo: totalsView.topAnchor, constant: 8).isActive = true
        title1.leftAnchor.constraint(equalTo: totalsView.leftAnchor, constant: 12).isActive = true
        title1.rightAnchor.constraint(equalTo: totalsView.rightAnchor, constant: -12).isActive = true
        title1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        totalsView.addSubview(title2)
        title2.topAnchor.constraint(equalTo: title1.bottomAnchor, constant: 8).isActive = true
        title2.leftAnchor.constraint(equalTo: totalsView.leftAnchor, constant: 12).isActive = true
        title2.rightAnchor.constraint(equalTo: totalsView.rightAnchor, constant: -12).isActive = true
        title2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        totalsView.addSubview(title3)
        title3.topAnchor.constraint(equalTo: title2.bottomAnchor, constant: 8).isActive = true
        title3.leftAnchor.constraint(equalTo: totalsView.leftAnchor, constant: 12).isActive = true
        title3.rightAnchor.constraint(equalTo: totalsView.rightAnchor, constant: -12).isActive = true
        title3.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        totalsView.addSubview(title4)
        title4.topAnchor.constraint(equalTo: title3.bottomAnchor, constant: 8).isActive = true
        title4.leftAnchor.constraint(equalTo: totalsView.leftAnchor, constant: 12).isActive = true
        title4.rightAnchor.constraint(equalTo: totalsView.rightAnchor, constant: -12).isActive = true
        title4.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        totalsView.addSubview(title5)
        title5.topAnchor.constraint(equalTo: title4.bottomAnchor, constant: 8).isActive = true
        title5.leftAnchor.constraint(equalTo: totalsView.leftAnchor, constant: 12).isActive = true
        title5.rightAnchor.constraint(equalTo: totalsView.rightAnchor, constant: -12).isActive = true
        title5.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        totalsView.addSubview(answer1)
        answer1.topAnchor.constraint(equalTo: totalsView.topAnchor, constant: 8).isActive = true
        answer1.leftAnchor.constraint(equalTo: totalsView.leftAnchor, constant: 12).isActive = true
        answer1.rightAnchor.constraint(equalTo: totalsView.rightAnchor, constant: -12).isActive = true
        answer1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        totalsView.addSubview(answer2)
        answer2.topAnchor.constraint(equalTo: title1.bottomAnchor, constant: 8).isActive = true
        answer2.leftAnchor.constraint(equalTo: totalsView.leftAnchor, constant: 12).isActive = true
        answer2.rightAnchor.constraint(equalTo: totalsView.rightAnchor, constant: -12).isActive = true
        answer2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        totalsView.addSubview(answer3)
        answer3.topAnchor.constraint(equalTo: title2.bottomAnchor, constant: 8).isActive = true
        answer3.leftAnchor.constraint(equalTo: totalsView.leftAnchor, constant: 12).isActive = true
        answer3.rightAnchor.constraint(equalTo: totalsView.rightAnchor, constant: -12).isActive = true
        answer3.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        totalsView.addSubview(answer4)
        answer4.topAnchor.constraint(equalTo: title3.bottomAnchor, constant: 8).isActive = true
        answer4.leftAnchor.constraint(equalTo: totalsView.leftAnchor, constant: 12).isActive = true
        answer4.rightAnchor.constraint(equalTo: totalsView.rightAnchor, constant: -12).isActive = true
        answer4.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        totalsView.addSubview(answer5)
        answer5.topAnchor.constraint(equalTo: title4.bottomAnchor, constant: 8).isActive = true
        answer5.leftAnchor.constraint(equalTo: totalsView.leftAnchor, constant: 12).isActive = true
        answer5.rightAnchor.constraint(equalTo: totalsView.rightAnchor, constant: -12).isActive = true
        answer5.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        scrollView.addSubview(genderPieChart)
        genderPieChart.topAnchor.constraint(equalTo: totalsView.bottomAnchor, constant: 16).isActive = true
        genderPieChart.leftAnchor.constraint(equalTo: totalsView.leftAnchor).isActive = true
        genderPieChart.rightAnchor.constraint(equalTo: totalsView.rightAnchor).isActive = true
        genderPieChart.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        scrollView.addSubview(ageRangeChart)
        ageRangeChart.topAnchor.constraint(equalTo: genderPieChart.bottomAnchor, constant: 16).isActive = true
        ageRangeChart.leftAnchor.constraint(equalTo: totalsView.leftAnchor).isActive = true
        ageRangeChart.rightAnchor.constraint(equalTo: totalsView.rightAnchor).isActive = true
        ageRangeChart.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func backend() {
        totalValues()
        genderPieChartValues()
        ageRangePieChartValues()
    }
    
    private func totalValues() {
        Database.database().reference().child("Analytics").child("appSessions").observe(DataEventType.childAdded) { snapshot in
            if let value = snapshot.value as? [String : Any] {
                let analytic = Analytic()
                analytic.restaurauntId = value["restaurantId"] as? String
                analytic.time = value["time"] as? Int
                analytic.userId = value["userId"] as? String
                if analytic.restaurauntId == globalAppId {
                    self.appSessionCount += 1
                }
            }
        }
        Database.database().reference().child("Analytics").child("reservationsBooked").observe(DataEventType.childAdded) { snapshot in
            if let value = snapshot.value as? [String : Any] {
                let analytic = Analytic()
                analytic.restaurauntId = value["restaurantId"] as? String
                analytic.time = value["time"] as? Int
                analytic.userId = value["userId"] as? String
                if analytic.restaurauntId == globalAppId {
                    self.reservationsBooked += 1
                }
            }
        }
        Database.database().reference().child("Analytics").child("onlineOrderButtonPressed").observe(DataEventType.childAdded) { snapshot in
            if let value = snapshot.value as? [String : Any] {
                let analytic = Analytic()
                analytic.restaurauntId = value["restaurantId"] as? String
                analytic.time = value["time"] as? Int
                analytic.userId = value["userId"] as? String
                if analytic.restaurauntId == globalAppId {
                    self.onlineOrders += 1
                }
            }
        }
        Database.database().reference().child("Analytics").child("callFromHome").observe(DataEventType.childAdded) { snapshot in
            if let value = snapshot.value as? [String : Any] {
                let analytic = Analytic()
                analytic.restaurauntId = value["restaurantId"] as? String
                analytic.time = value["time"] as? Int
                analytic.userId = value["userId"] as? String
                if analytic.restaurauntId == globalAppId {
                    self.calledViaApp += 1
                }
            }
        }
        Database.database().reference().child("Analytics").child("openedMenus").observe(DataEventType.childAdded) { snapshot in
            if let value = snapshot.value as? [String : Any] {
                let analytic = Analytic()
                analytic.restaurauntId = value["restaurantId"] as? String
                analytic.time = value["time"] as? Int
                analytic.userId = value["userId"] as? String
                if analytic.restaurauntId == globalAppId {
                    self.openedMenus += 1
                }
            }
        }
    }
    
    private func genderPieChartValues() {
        genderMaleData.value = 0
        genderMaleData.label = "Male"
        
        genderFemaleData.value = 0
        genderFemaleData.label = "Female"
        
        Database.database().reference().child("Apps").child(globalAppId).child("Users").observe(.childAdded) { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let user = Customer()
                user.email = value["email"] as? String
                user.gender = value["gender"] as? String ?? "other"
                switch user.gender {
                case "Male":
                    self.genderMaleData.value += 1
                case "Female":
                    self.genderFemaleData.value += 1
                default:
                    print("other")
                }
            }
            self.numberOfGenderDataEntries = [self.genderMaleData, self.genderFemaleData]
            self.updateChartData()
        }
    }
    
    private func ageRangePieChartValues() {
        zeroToTenData.value = 0
        zeroToTenData.label = "12 - 17"
        
        elevenToTwentyData.value = 0
        elevenToTwentyData.label = "18 - 24"
        
        twentyToThirtyData.value = 0
        twentyToThirtyData.label = "25 - 34"
        
        thirtyToFourtyData.value = 0
        thirtyToFourtyData.label = "35 - 44"
        
        fourtyToFiftyData.value = 0
        fourtyToFiftyData.label = "45 - 54"
        
        fiftyAndAboveData.value = 0
        fiftyAndAboveData.label = "55+"
        
        Database.database().reference().child("Apps").child(globalAppId).child("Users").observe(.childAdded) { [self] (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                let user = Customer()
                user.email = value["email"] as? String
                user.gender = value["gender"] as? String ?? "other"
                user.birthday = value["birthday"] as? String ?? "2005-12-15T17:22:03Z"
                let userAge = self.calculateAge(birthday: user.birthday!)
                if userAge > 0 && userAge < 18 {
                    self.zeroToTenData.value += 1
                } else if userAge > 17 && userAge < 25 {
                    self.elevenToTwentyData.value += 1
                } else if userAge > 24 && userAge < 35 {
                    self.twentyToThirtyData.value += 1
                } else if userAge > 34 && userAge < 45 {
                    self.thirtyToFourtyData.value += 1
                } else if userAge > 44 && userAge < 55 {
                    self.fourtyToFiftyData.value += 1
                } else {
                    self.fiftyAndAboveData.value += 1
                }
            }
            self.numerOfAgeRanges = [self.zeroToTenData, self.elevenToTwentyData, self.twentyToThirtyData, self.thirtyToFourtyData, self.fourtyToFiftyData, self.fiftyAndAboveData]
            self.updateChartData()
        }
    }
    
    func calculateAge (birthday: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let updatedAtStr = birthday
        let birthday = dateFormatter.date(from: updatedAtStr)!
        let today = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: birthday, to: today)
        return components.year!
    }
    
    private func updateChartData() {
        let genderChartDataSet = PieChartDataSet(entries: numberOfGenderDataEntries, label: nil)
        let genderData = PieChartData(dataSet: genderChartDataSet)
        let genderColors = [UIColor.systemRed, UIColor.systemBlue]
        genderChartDataSet.colors = genderColors
        genderPieChart.data = genderData
        
        let ageRangeChartDataSet = PieChartDataSet(entries: numerOfAgeRanges, label: nil)
        let ageData = PieChartData(dataSet: ageRangeChartDataSet)
        let ageColors = [UIColor.systemRed, UIColor.systemOrange, UIColor.systemYellow, UIColor.systemGreen, UIColor.systemBlue, UIColor.systemPurple]
        ageRangeChartDataSet.colors = ageColors
        ageRangeChart.data = ageData
    }

    // MARK: - Objective-C Functions

}
