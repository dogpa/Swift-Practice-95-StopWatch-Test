//
//  ViewController.swift
//  Swift Practice # 95 StopWatch Test
//
//  Created by Dogpa's MBAir M1 on 2021/10/15.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var startStopButton: UIButton!   //右側藍色開始和停止Button
    
    @IBOutlet weak var divideRestButton: UIButton!  //左側黃色分圈與重置Button
    
    @IBOutlet weak var divideTable: UITableView!
    
    
    var touchDivide = 0
    var divideTimeStringArray = [String]()
    var divideLoopStringArray = [String]()
    var minusArray = [0]
    var divideIndexArray = [Int]() {
        didSet {
            if divideIndexArray.count > 0 {
                timeIntChageToSrting ()
            }else{
                
            }
        }
    }
    
    var stopWatchtimer = Timer()
    
    // @objc func observeTimeChange 使用參數
    var timeObserver = 0
    var calculateHour = 0
    var calculateMin = 0
    var calculateSec = 0
    var calculateMiSec = 0
    var totalStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        divideTable.delegate = self
        divideTable.dataSource = self
        startStopButton.layer.cornerRadius = 35
        divideRestButton.layer.cornerRadius = 35
    }
    
    
    @objc func observeTimeChange () {
        timeObserver += 1
        calculateHour = timeObserver / 360000
        calculateMin = timeObserver / 6000
        calculateSec = (timeObserver / 100) % 60
        calculateMiSec = timeObserver % 100
        

        /*原始寫法Label會跳
        if calculateHour < 1 {
            timeLabel.text = "\(String(calculateMin)):\(String(calculateSec)).\(calculateMiSec)"
        }else{
            "\(String(calculateHour)):\(String(calculateMin)):\(String(calculateSec)).\(calculateMiSec)"
        }
         */
        
        let hourStr = calculateHour > 9 ? "\(calculateHour)":"0\(calculateHour)"
        let minStr = calculateMin > 9 ? "\(calculateMin)":"0\(calculateMin)"
        let secStr = calculateSec > 9 ? "\(calculateSec)":"0\(calculateSec)"
        let miSecStr = calculateMiSec > 9 ? "\(calculateMiSec)":"0\(calculateMiSec)"
        totalStr = calculateMin>59 ? "\(hourStr):\(minStr):\(secStr).\(miSecStr)":"\(minStr):\(secStr).\(miSecStr)"
        timeLabel.text = totalStr
        
    }
    
    
    func timeIntChageToSrting () {
        divideLoopStringArray = []
        divideTimeStringArray = []
        for i in 0...divideIndexArray.count - 1 {
            let dividHourCalculate = (divideIndexArray[i]) / 360000
            let divideMinCalculate = (divideIndexArray[i]) / 6000
            let divideSecCalculate = ((divideIndexArray[i]) / 100) % 60
            let divideMiSecCalculate = (divideIndexArray[i]) % 100
            divideLoopStringArray.insert(("第 \(i+1) 圈"), at: 0)
            
            let divideHourStr = dividHourCalculate > 9 ? "\(dividHourCalculate)":"0\(dividHourCalculate)"
            let divideMinStr = divideMinCalculate > 9 ? "\(divideMinCalculate)":"0\(divideMinCalculate)"
            let divideSecStr = divideSecCalculate > 9 ? "\(divideSecCalculate)":"0\(divideSecCalculate)"
            let diviDeMiSecStr = divideMiSecCalculate > 9 ? "\(divideMiSecCalculate)":"0\(divideMiSecCalculate)"
            let stringSaveLoopString = divideMinCalculate > 59 ? "\(divideHourStr):\(divideMinStr):\(divideSecStr).\(diviDeMiSecStr)":"\(divideMinStr):\(divideSecStr).\(diviDeMiSecStr)"
            divideTimeStringArray.append(stringSaveLoopString)
            divideTable.reloadData()
            
        }
    }
    
    @IBAction func startAndStop(_ sender: UIButton) {
        if sender.currentTitle == "開始" {
            stopWatchtimer = Timer.scheduledTimer(timeInterval: TimeInterval(0.01), target: self, selector: #selector(observeTimeChange), userInfo: nil, repeats: true)
            sender.setTitle("停止", for: .normal)
            divideRestButton.setTitle("分圈", for: .normal)

            
        }else{
            //divideIndexArraycalculateAll ()
            stopWatchtimer.invalidate()
            sender.setTitle("開始", for: .normal)
            print(divideIndexArray)
            
            divideRestButton.setTitle("重置", for: .normal)
        }
    }
    
    
    func divideIndexArraycalculateAll () {
        var divideIndexArrayAll = 0
        for x in 0...divideIndexArray.count - 1 {
            divideIndexArrayAll = divideIndexArrayAll + divideIndexArray[x]
        }
        touchDivide = timeObserver - divideIndexArrayAll
        divideIndexArray.insert(touchDivide, at: 0)
    }
    
    @IBAction func divideAndClean(_ sender: UIButton) {
        if sender.currentTitle == "分圈" {
            if startStopButton.currentTitle == "停止" {
                if  divideIndexArray == nil || divideIndexArray.count == 0 {
                    divideIndexArray.insert(timeObserver, at: 0)
                    print("no\(timeObserver)")
                }else{
                    divideIndexArraycalculateAll ()
                    print("yes\(timeObserver)")
                }
                
                print(divideIndexArray)
            }
        }else{
            divideIndexArray.removeAll()
            touchDivide = 0
            divideTimeStringArray = []
            divideLoopStringArray = []
            timeObserver = 0
            calculateHour = 0
            calculateMin = 0
            calculateSec = 0
            calculateMiSec = 0
            totalStr = ""
            timeLabel.text = "00:00.00"
            divideTable.reloadData()
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        divideTimeStringArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DivideTableViewCell", for: indexPath) as! DivideTableViewCell
        cell.loopIndexLabel.text = divideLoopStringArray[indexPath.row]
        cell.loopTimeLabel.text = divideTimeStringArray[indexPath.row]
        return cell
    }
    
    

}

