//
//  ViewController.swift
//  Swift Practice # 95 StopWatch Test
//
//  Created by Dogpa's MBAir M1 on 2021/10/15.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    
    @IBOutlet weak var timeLabel: UILabel!          //上方碼表
    
    @IBOutlet weak var startStopButton: UIButton!   //右側藍色開始和停止Button
    
    @IBOutlet weak var divideRestButton: UIButton!  //左側黃色分圈與重置Button
    
    @IBOutlet weak var divideTable: UITableView!    //下方的TableView

    var divideTimeStringArray = [String]()          //存放分圈時間的字串(右)
    var divideLoopStringArray = [String]()          //存放分圈第幾圈的字串(左)
   
    var divideIndexArray = [0] {                    //存放分圈的時間，並在有改變時執行自定義timeIntChageToSrting ()
        didSet {
                timeIntChageToSrting ()
        }
    }
    
    var stopWatchtimer = Timer()                    //時間計時用
    
    // @objc func observeTimeChange 使用參數
    var timeObserver = 0                            //取得每0.01秒的時間
    var calculateHour = 0                           //取得divideTable計算的小時
    var calculateMin = 0                            //取得divideTable計算的分鐘
    var calculateSec = 0                            //取得divideTable計算的秒數
    var calculateMiSec = 0                          //取得divideTable計算的毫秒
    var totalStr = ""                               //取得上面所有divideTable需要使用的資料存入
    var calculatedivideIndexArrayTotal = 0          //計算已經執行的分圈時間的加總
    
    override func viewDidLoad() {
        super.viewDidLoad()
        divideTable.delegate = self                 //divideTable的delegate與dataSource指派給ViewController
        divideTable.dataSource = self
        startStopButton.layer.cornerRadius = 40     //兩個button的cornerRadius設定成一半
        divideRestButton.layer.cornerRadius = 40
    }
    
    //自定義Function用於timer每次變化要執行的項目
    @objc func observeTimeChange () {
        
        timeObserver += 1                           //timeObserver＋1因為timer是每0.01執行一次，所以對應0.01秒
        calculateHour = timeObserver / 360000       //取得timeObserver換算的小時時間存入calculateHour
        calculateMin = timeObserver / 6000          //取得timeObserver換算的分鐘時間存入calculateMin
        calculateSec = (timeObserver / 100) % 60    //取得timeObserver換算的秒數時間存入calculateSec
        calculateMiSec = timeObserver % 100         //取得timeObserver換算的微秒時間存入calculateMiSec
        
        //讓divideIndexArray的第一個數字為timeObserver減去目前divideIndexArray的總數，取得目前這個分圈的間隔時間
        divideIndexArray[0] = timeObserver - calculatedivideIndexArrayTotal
       
        
        /*
        //原始寫法Label會跳
        if calculateHour < 1 {
            timeLabel.text = "\(String(calculateMin)):\(String(calculateSec)).\(calculateMiSec)"
        }else{
            "\(String(calculateHour)):\(String(calculateMin)):\(String(calculateSec)).\(calculateMiSec)"
        }
         */
         
        
        
        
        //透過判斷指派hourStr為需要的數字字串，讓0能夠在只有一位數時出現
        let hourStr = calculateHour > 9 ? "\(calculateHour)":"0\(calculateHour)"
        let minStr = calculateMin > 9 ? "\(calculateMin)":"0\(calculateMin)"
        let secStr = calculateSec > 9 ? "\(calculateSec)":"0\(calculateSec)"
        let miSecStr = calculateMiSec > 9 ? "\(calculateMiSec)":"0\(calculateMiSec)"
        
        //totalStr一樣透過calculateMin時間來指派是否出現hourStr的值，完成後將totalStr顯示在timeLabel上
        totalStr = calculateMin>59 ? "\(hourStr):\(minStr):\(secStr).\(miSecStr)":"\(minStr):\(secStr).\(miSecStr)"
        timeLabel.text = totalStr
         
        
    }
    
    //自定義Function用於顯示分圈的Label顯示
    func timeIntChageToSrting () {
        
        divideLoopStringArray = []                                          //先將兩個字串Array變成空字串
        divideTimeStringArray = []
        for i in 0...divideIndexArray.count - 1 {                           //透過For迴圈與的divideIndexArray每個值得字存入相對應的時間的常數
            let dividHourCalculate = (divideIndexArray[i]) / 360000         //小時
            let divideMinCalculate = (divideIndexArray[i]) / 6000           //分鐘
            let divideSecCalculate = ((divideIndexArray[i]) / 100) % 60     //秒
            let divideMiSecCalculate = (divideIndexArray[i]) % 100          //毫秒
            divideLoopStringArray.insert(("第 \(i+1) 圈"), at: 0)            //divideLoopStringArray先存入圈數插在第0個讓1永遠在最上面
            
            //透過判斷指派常數存入相對應的數字字串，小於9就增加0對齊。
            let divideHourStr = dividHourCalculate > 9 ? "\(dividHourCalculate)":"0\(dividHourCalculate)"
            let divideMinStr = divideMinCalculate > 9 ? "\(divideMinCalculate)":"0\(divideMinCalculate)"
            let divideSecStr = divideSecCalculate > 9 ? "\(divideSecCalculate)":"0\(divideSecCalculate)"
            let diviDeMiSecStr = divideMiSecCalculate > 9 ? "\(divideMiSecCalculate)":"0\(divideMiSecCalculate)"
            
            //stringSaveLoopString一樣透過分鐘判斷是否顯示小時時間
            let stringSaveLoopString = divideMinCalculate > 59 ? "\(divideHourStr):\(divideMinStr):\(divideSecStr).\(diviDeMiSecStr)":"\(divideMinStr):\(divideSecStr).\(diviDeMiSecStr)"
            //將stringSaveLoopString存入到divideTimeStringArray的最後一個
            //第一個算的時間永遠在最前面。
            divideTimeStringArray.append(stringSaveLoopString)
            
            //重置divideTable
            divideTable.reloadData()
            
        }
    }
    
    //右側藍色開始停止的Button
    @IBAction func startAndStop(_ sender: UIButton) {
        //button的字為開始時，透過時間stopWatchtimer開始計時並在每0.01秒執行observeTimeChange自定義Function
        //並在自身的title改為停止，將左側Button的title設為分圈"
        if sender.currentTitle == "開始" {
            stopWatchtimer = Timer.scheduledTimer(timeInterval: TimeInterval(0.01), target: self, selector: #selector(observeTimeChange), userInfo: nil, repeats: true)
            RunLoop.current.add(stopWatchtimer, forMode: .common)
            sender.setTitle("停止", for: .normal)
            sender.backgroundColor = .systemRed
            divideRestButton.setTitle("分圈", for: .normal)
        //如果button是目前title停止的話
        }else{
            //終止stopWatchtimer並將自身title設為"開始"左側button的title設為"重置"
            stopWatchtimer.invalidate()
            sender.setTitle("開始", for: .normal)
            sender.backgroundColor = .systemGreen
            //print(divideIndexArray)
            
            divideRestButton.setTitle("重置", for: .normal)
        }
    }
    
    //自定義Function
    func divideIndexArraycalculateAll () {
        
        //原本先前的算法
        /*
        //先指派區域變數divideIndexArrayAll為Int 0
        var divideIndexArrayAll = 0
        //透過迴圈相加divideIndexArray目前內部所有的值
        for x in 0...divideIndexArray.count - 1 {
            divideIndexArrayAll = divideIndexArrayAll + divideIndexArray[x]
        }
        //將目前跑出的時間(timeObserver) 減去divideIndexArray所有的值
        calculatedivideIndexArrayTotal = timeObserver - divideIndexArrayAll
        print("calculatedivideIndexArrayTotal目前\(calculatedivideIndexArrayTotal)")
        divideIndexArray.insert(calculatedivideIndexArrayTotal, at: 0)
        //divideIndexArray.insert(0, at: 0)
        
         */
        
        //在divideIndexArray第一個位置插入0用來準備儲存按下分圈後新分圈的分圈計時
        divideIndexArray.insert(0, at: 0)
        
        //計算目前所有divideIndexArray總數傳給時間0.01Function使用用來相減
        calculatedivideIndexArrayTotal = 0
        for a in 0...divideIndexArray.count - 1{
            calculatedivideIndexArrayTotal = calculatedivideIndexArrayTotal + divideIndexArray [a]
        }
    }
    
    
    //左側黃色Button
    @IBAction func divideAndClean(_ sender: UIButton) {
        //如果按下時自己的title為"分圈"
        if sender.currentTitle == "分圈" {
            //則執行自定義divideIndexArraycalculateAll ()
            divideIndexArraycalculateAll ()
        //如果為重置的話，將所有參數歸0
        }else{
            calculatedivideIndexArrayTotal = 0
            divideIndexArray = [0]
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
    
    
    //tableView相關
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        divideTimeStringArray.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DivideTableViewCell", for: indexPath) as! DivideTableViewCell
        cell.loopIndexLabel.text = divideLoopStringArray[indexPath.row]//左邊label
        cell.loopTimeLabel.text = divideTimeStringArray[indexPath.row]//右邊label
        return cell
    }
    
    

}

