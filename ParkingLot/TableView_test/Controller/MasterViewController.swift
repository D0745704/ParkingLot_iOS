//
//  MasterViewController.swift
//  TableView_test
//
//  Created by 仲輝 on 2022/2/22.
//
import UIKit
import CoreLocation

class MasterViewController: UIViewController, AreaPopupDelegate, CLLocationManagerDelegate, LocationServiceDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedItems: [String] = [String]()
    var refreshControl: UIRefreshControl!
    var timer: Timer!
    var userLoc: CLLocationCoordinate2D!
    
    let apiModel = APIModel()
    let dbModel = DBModel()
    let selectedBackgroundView = UIView()
    
    var locService: LocationService!
    //let locationManager = LocationManager.shared
    //let locationManager2 = LocationManager()
    // 1.Shared <- 系統就會給你固定Memory Addr 位置
    // 2. locationManager != locationManager2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locService = LocationService.getSharedInstance()
        
        locService.delegate = self
        locService.checkAuthorization()
        
//        locService.startUpdatingLocation()
//        locService.locationManager?.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        getParkingData()
        pullToRefresh()
        addLongPress()
    }
        
    //MARK: - 手勢
    func addLongPress() {
        
        let longPress = UILongPressGestureRecognizer(target: self,action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
    }


    @objc
    private func handleLongPress(sender: UILongPressGestureRecognizer) {

        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                dump(indexPath.item)
                showParkingChangedAlert(at: indexPath)
            }
        }
    }
    
    @objc func dismissOnTapOutside(){
       self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                dump(indexPath.item)
            }
        }
    }

    //MARK: - 篩選
    @IBAction func dataFilter(_ sender: Any) {
        
        showAreaPopupView()
    }
    // MARK: - 我的方法
    
    func getParkingData() {
        apiModel.getParkingDataFromURL { objects in

            objects.forEach { content in
                self.dbModel.insertObjects(data: content)
            }
            
            self.dbModel.showObjects(by: self.selectedItems)
            self.tableView.reloadData()
        }
    }
        
    func pushToDetailVC(park: Parking) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        detailVC.parkingDesc = park
        detailVC.userLoc = self.userLoc
        let rootNav = UINavigationController(rootViewController: detailVC)
        rootNav.modalPresentationStyle = .fullScreen
        self.present(rootNav, animated: true)
    }
    
    func showAreaPopupView() {
        
        let areaVC = self.storyboard?.instantiateViewController(withIdentifier: "AreaVC") as! AreaViewController
        areaVC.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        areaVC.delegate = self
        areaVC.selectItems = self.selectedItems
        areaVC.isSelected = { items in
            self.selectedItems = items
            self.dbModel.showObjects(by: self.selectedItems)
            self.tableView.reloadData()
        }
        
        let rootNav = UINavigationController(rootViewController: areaVC)
        rootNav.modalPresentationStyle = .fullScreen
        rootNav.modalPresentationStyle = .custom
        self.present(rootNav, animated: false)
    }
    
    func pullToRefresh() {
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "refresh...")
        refreshControl.addTarget(self, action: #selector(loadData), for: UIControl.Event.valueChanged)
        
        tableView.addSubview(refreshControl)
    }
    @objc func loadData(){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.refreshControl.endRefreshing()
            self.getParkingData()
        }
    }
    
    // MARK: - Delegate
    func areaSelectedItem(items: [String]) {
        //print("Delegate: 地區item數量 = \(items.count)")
        //self.selectedItems = items
        //self.dbModel.showObjects(by: self.selectedItems)
        //self.tableView.reloadData()
    }
    
    func tracingLocation(_ lastLocation: CLLocationCoordinate2D) {
        self.userLoc = lastLocation
        print("lat: \(lastLocation.latitude)")
    }
}

// MARK: - UITableView Data
extension MasterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(dbModel.parkingList.count)
        return dbModel.parkingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkingCell",
                                                 for: indexPath) as! ParkingLocTableCell
        cell.nameLabel.text = dbModel.parkingList[indexPath.item].loc//停車場名字
        cell.areaLabel.text = dbModel.parkingList[indexPath.item].area//地區
        cell.areaLabel.textColor = UIColor.systemBlue
        cell.addrLabel.text = dbModel.parkingList[indexPath.item].addr//地址
        cell.addrLabel.textColor = UIColor.systemGray
        cell.servTimeLabel.text = dbModel.parkingList[indexPath.item].servTime//服務時間
        cell.servTimeLabel.textColor = UIColor.systemGray
        return cell
    }
    //MARK: - 點擊事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let parkData = dbModel.parkingList[indexPath.item]
        
        switch LocationService.shared.locationManager?.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            //locService.startUpdatingLocation()
            pushToDetailVC(park: parkData)
        case .denied:
            showWarningAlert("Location Service off")
        default:
            break
        }
//        if locService.locationManager.authorizationStatus == .authorizedAlways && locService.locationManager.authorizationStatus == .authorizedWhenInUse {
//            pushToDetailVC(park: parkData)
//        }
        //MARK:添加 else showAlert
    }
}

// MARK: - Alert 區塊
extension MasterViewController {
    
    func writeParkingAlert(type: String, alertTitle: String, actionHandler: ((_ textFields: [UITextField]?) -> Void)? = nil) {
        let alert = UIAlertController.init(
            title: alertTitle,
            message: "",
            preferredStyle: .alert
        )
        
        for index in 0...3 {
            alert.addTextField { (textField: UITextField) in
                if index == 0 {
                    textField.placeholder = type + "地區"
                }else if index == 1 {
                    textField.placeholder = type + "時間"
                }else if index == 2 {
                    textField.placeholder = type + "地址"
                }else if index == 3 {
                    textField.placeholder = type + "名稱"
                }
            }
        }
        alert.addAction(UIAlertAction.init(title: "確定", style: .default, handler: {(action: UIAlertAction) in
            DispatchQueue.main.async {
                actionHandler?(alert.textFields)
            }
        }))
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { _ in
            DispatchQueue.main.async {
                
            }
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        })
    }

    
    func showParkingChangedAlert(at indexPath: IndexPath) {
        
        let alert = UIAlertController.init(
            title: "\(dbModel.parkingList[indexPath.item].area ?? "")\n\(dbModel.parkingList[indexPath.item].loc ?? "新增或修改資料")",
            message: "",
            preferredStyle: .alert
        )
        let modifyAction = UIAlertAction(title: "修改", style: .default) { _ in
           
            
            DispatchQueue.main.async {
               
                
                self.writeParkingAlert(type: "修改", alertTitle: "修改停車場資料") { (textFields: [UITextField]?) in
                    let content = DataContents(area: textFields?[0].text ?? "", time: textFields?[1].text ?? "", addr: textFields?[2].text ?? "", location: textFields?[3].text ?? "")
                    self.dbModel.modifyObject(at: indexPath, data: content) { list in
                        if list == true {
                            self.tableView.reloadData()
                        }
                        else {
                            self.showDuplicateAlert()
                        }
                    }
                }
            }
        }
        let deleteAction = UIAlertAction(title: "刪除", style: .destructive) { _ in
            let deleteAlert = UIAlertController.init(
                title:          "已刪除",
                message:        "",
                preferredStyle: .alert
            )
            let deleteFinishedAction = UIAlertAction.init(title: "OK", style: .default)
            deleteAlert.addAction(deleteFinishedAction)
            DispatchQueue.main.async {
                self.dbModel.deleteObject(at: indexPath)
                self.present(deleteAlert, animated: true, completion: {
                    deleteAlert.view.superview?.isUserInteractionEnabled = true
                    deleteAlert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
                    self.dbModel.showObjects(by: self.selectedItems)
                    self.tableView.reloadData()
                })
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in
            DispatchQueue.main.async {
            }
        }
        alert.addAction(modifyAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: {
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        })
    }
    
    func showDuplicateAlert() {
        let duplicateAlert = UIAlertController.init(
            title:          "資料已存在",
            message:        "",
            preferredStyle: .alert
        )
        let finishAction = UIAlertAction.init(title: "好吧", style: .default)
        duplicateAlert.addAction(finishAction)
        self.present(duplicateAlert, animated: true, completion: {
            self.tableView.reloadData()
        })
    }
    
    //MARK: 前往設定
    func showWarningAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - 動畫
extension UIView {
    func shake(duration timeDuration: Double = 0.07, repeat countRepeat: Float = 3) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = timeDuration
        animation.repeatCount = countRepeat
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}
//MARK: - 待辦事項＆其他
