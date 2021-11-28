//
//  Reservation.swift
//  DISH Connect
//
//  Created by JJ Zapata on 4/5/21.
//

import UIKit
import Firebase
import EventKit
import KVKCalendar

class ReservationController: UIViewController, CalendarDelegate, CalendarDataSource {
    
    private var events = [Event]()
    
    private var selectDate: Date = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return Date()
    }()
    
    private lazy var reloadStyle: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(openRequests))
        button.tintColor = .mainBlue
        return button
    }()
    
    private lazy var calendarView: CalendarView = {
        let calendar = CalendarView(frame: view.frame, date: selectDate, style: style)
        calendar.delegate = self
        calendar.tintColor = UIColor.mainBlue
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.dataSource = self
        return calendar
    }()
    
    private var style: Style = {
        var style = Style()
        if UIDevice.current.userInterfaceIdiom == .phone {
            style.timeline.widthTime = 40
            style.timeline.currentLineHourWidth = 45
            style.timeline.offsetTimeX = 2
            style.timeline.offsetLineLeft = 2
            style.headerScroll.titleDateAlignment = .center
            style.headerScroll.isAnimateTitleDate = true
            style.headerScroll.heightHeaderWeek = 70
            style.event.isEnableVisualSelect = false
            style.month.isHiddenTitle = true
            style.month.weekDayAlignment = .center
        } else {
            style.timeline.widthEventViewer = 350
            style.headerScroll.fontNameDay = .systemFont(ofSize: 17)
        }
        style.month.autoSelectionDateWhenScrolling = true
        style.timeline.offsetTimeY = 25
        style.startWeekDay = .sunday
        style.timeSystem = .current ?? .twelve
        style.systemCalendars = ["Calendar"]
        if #available(iOS 13.0, *) {
            style.event.iconFile = UIImage(systemName: "paperclip")
        }
        return style
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let array = [CalendarType.day, CalendarType.week]
        let control = UISegmentedControl(items: array.map({ $0.rawValue.capitalized }))
        control.tintColor = UIColor.mainBlue
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        control.backgroundColor = UIColor(named: "secondaryBackground")!
        control.selectedSegmentIndex = 0
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: UIControl.State.selected)
        control.selectedSegmentTintColor = UIColor.mainBlue
        control.addTarget(self, action: #selector(switchCalendar), for: .valueChanged)
        return control
    }()
    
    let calendarView1 : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let topView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "backgroundColor")!
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        view.backgroundColor = UIColor(named: "backgroundColor")!

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        backend()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = UIColor.mainBlue
        navigationController?.navigationBar.prefersLargeTitles = true
        UINavigationBar().backgroundColor = .green
        navigationItem.largeTitleDisplayMode = UINavigationItem.LargeTitleDisplayMode.always
        
        navigationItem.backButtonTitle = "Back"
        navigationItem.title = "Reservation"
        
        let filterBtn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        filterBtn.setImage(UIImage(systemName: "book"), for: .normal)
        filterBtn.contentMode = UIView.ContentMode.scaleAspectFill
        filterBtn.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        filterBtn.addTarget(self, action: #selector(openRequests), for: .touchUpInside)
        
        Database.database().reference().child("Apps").child(globalAppId).child("reservations").observe(DataEventType.childAdded) { snapshot in
            if let value = snapshot.value as? [String : Any] {
                let reservation = Reservation()
                reservation.userId = value["userId"] as? String
                reservation.recipient = value["recipient"] as? String
                reservation.startTime = value["startTime"] as? String
                reservation.endTime = value["endTime"] as? String
                reservation.key = snapshot.key
                reservation.numberOfSeats = value["numberOfSeats"] as? Int
                reservation.timeRequestSubmitted = value["timeRequestSubmitted"] as? Int
                reservation.status = value["status"] as? String
                if reservation.status == "pending" {
                    let lblBadge = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: 15, height: 15))
                    lblBadge.backgroundColor = UIColor.red
                    lblBadge.clipsToBounds = true
                    lblBadge.layer.cornerRadius = 7
                    lblBadge.textColor = UIColor.white
                    lblBadge.font = UIFont.systemFont(ofSize: 10)
                    lblBadge.textAlignment = .center
                    filterBtn.addSubview(lblBadge)
                }
            }
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: filterBtn)]
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        view.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -25).isActive = true
        segmentedControl.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 25).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        view.addSubview(calendarView1)
        calendarView1.backgroundColor = .white
        calendarView1.topAnchor.constraint(equalTo: segmentedControl.topAnchor, constant: -20).isActive = true
        calendarView1.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        calendarView1.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        calendarView1.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        view.addSubview(topView)
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        topView.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 7).isActive = true
        
        view.bringSubviewToFront(segmentedControl)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calendarView1.addSubview(calendarView)
        var frame = calendarView1.frame
        frame.origin.y = 0
        calendarView.reloadFrame(frame)
    }
    
    @objc private func reloadCalendarStyle() {
        style.timeSystem = style.timeSystem == .twentyFour ? .twelve : .twentyFour
        calendarView.updateStyle(style)
        calendarView.reloadData()
    }
    
    @objc private func switchCalendar(sender: UISegmentedControl) {
        let type = CalendarType.allCases[sender.selectedSegmentIndex]
        calendarView.set(type: type, date: selectDate)
        calendarView.reloadData()
    }
    
    
    @objc func openRequests() {
        let controller = RequestsController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func timeFormatter(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = style.timeSystem.format
        return formatter.string(from: date)
    }
    
    private func formatter(date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter.date(from: date) ?? Date()
    }
    
    private func backend() {
        events.removeAll()
        Database.database().reference().child("Apps").child(globalAppId).child("reservations").observe(DataEventType.childAdded) { snapshot in
            if let value = snapshot.value as? [String : Any] {
                var event = Event(ID: value["key"] as! String)
                
                let status = value["status"] as? String
                let startDate = self.formatter(date: value["startTime"] as! String)
                let endDate = self.formatter(date: value["endTime"] as! String)
                let seats = value["numberOfSeats"] as? Int ?? 4
                let startTime = self.timeFormatter(date: startDate)
                let endTime = self.timeFormatter(date: endDate)
                
                if status != "accepted" {
                    return
                }
                
                event.start = startDate
                event.end = endDate
                event.color = Event.Color.init(UIColor.mainBlue)
                event.isAllDay = false
                event.isContainsFile = false
                
                event.text = "\(startTime) - \(endTime)\n\(value["userId"] as! String) (\(seats) Seats)"
                event.textForList = "\(startTime) - \(endTime)   \(value["userId"] as! String)"
                
                self.events.append(event)
            }
            self.calendarView.reloadData()
        }
    }
    
    func eventsForCalendar(systemEvents: [EKEvent]) -> [Event] {
        return events
    }
    
    func didSelectEvent(_ event: Event, type: CalendarType, frame: CGRect?) {
//        let controller = ViewReservationController()
//        controller.event = event
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func willDisplayEventView(_ event: Event, frame: CGRect, date: Date?) -> EventViewGeneral? {
        guard event.ID == "2" else { return nil }
        
        return CustomViewEvent(style: style, event: event, frame: frame)
    }
    
    func dequeueCell<T>(dateParameter: DateParameter, type: CalendarType, view: T, indexPath: IndexPath) -> KVKCalendarCellProtocol? where T: UIScrollView {
        switch type {
        case .year where dateParameter.date?.month == Date().month:
            let cell = (view as? UICollectionView)?.dequeueCell(indexPath: indexPath) { (cell: CustomDayCell) in
                cell.imageView.image = UIImage(named: "ic_stub")
            }
            return cell
        case .day, .week, .month:
            guard dateParameter.date?.day == Date().day else { return nil }
            
            let cell = (view as? UICollectionView)?.dequeueCell(indexPath: indexPath) { (cell: CustomDayCell) in
                cell.imageView.image = UIImage(named: "ic_stub")
            }
            return cell
        case .list:
            guard dateParameter.date?.day == 14 else { return nil }
            
            let cell = (view as? UITableView)?.dequeueCell { (cell) in
                cell.backgroundColor = .mainBlue
            }
            return cell
        default:
            return nil
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



final class CustomViewEvent: EventViewGeneral {
    override init(style: Style, event: Event, frame: CGRect) {
        super.init(style: style, event: event, frame: frame)
        
        let imageView = UIImageView(image: UIImage(named: "ic_stub"))
        imageView.frame = CGRect(origin: CGPoint(x: 3, y: 1), size: CGSize(width: frame.width - 6, height: frame.height - 2))
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        backgroundColor = event.backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UINavigationController {
    func transparentNavigationBar() {
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
    }

    func setTintColor(_ color: UIColor) {
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        self.navigationBar.tintColor = color
    }

    func backgroundColor(_ color: UIColor) {
        navigationBar.setBackgroundImage(nil, for: .default)
        navigationBar.barTintColor = color
        navigationBar.shadowImage = UIImage()
    }
}
