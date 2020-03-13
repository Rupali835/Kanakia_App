//
//  Kra&FeedbackVc.swift
//  Pms App
//
//  Created by user on 29/03/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class Kra_FeedbackVc: UIViewController {

    @IBOutlet weak var btnMyKra: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var Fvc: UIView!
    @IBOutlet weak var forVc: UIView!
    @IBOutlet weak var Tvc: UIView!
    @IBOutlet weak var Svc: UIView!
    var EmpNm : String?
    var Up_id: String!
    var Check = Bool(true)
    var cFeedback : FeedBackForAnyVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
       // self.navigationItem.backBarButtonItem?.title = "Back"
        
        self.mainView.backgroundColor =  UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        
//        self.designCell(cView: Fvc)
//        self.designCell(cView: Svc)
//        self.designCell(cView: Tvc)
//        self.designCell(cView: forVc)
        
        setupData(cId: self.Up_id)
        
        self.navigationItem.backBarButtonItem?.title = ""
        
        if Check
        {
              setEmpName(cNm: EmpNm!)
            self.navigationItem.title = self.EmpNm
            self.btnMyKra.setTitle("KRA, KPI, Target, Highlights/Lowlights", for: .normal)
        }else {
             self.navigationItem.title = ""
        }
    
        let button1 = UIBarButtonItem(image: UIImage(named: "MSG"), style: .plain, target: self, action: #selector(btnChat_Click))
        self.navigationItem.rightBarButtonItem  = button1

    }

    override func awakeFromNib()
    {
        self.cFeedback = self.storyboard?.instantiateViewController(withIdentifier: "FeedBackForAnyVC") as! FeedBackForAnyVC
    }
    
    @objc func btnChat_Click()
    {
        self.cFeedback.view.frame = self.view.frame
        self.cFeedback.setId(Id: self.Up_id)
        self.view.addSubview(self.cFeedback.view)
        self.cFeedback.view.clipsToBounds = true
    }
    
    func setEmpName(cNm: String)
    {
        self.EmpNm = cNm
        self.navigationItem.title = cNm
    }
    
    func setupData(cId: String)
    {
        self.Up_id = cId
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func designCell(cView : UIView)
    {
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cView.layer.shadowRadius = 4.0
        cView.layer.shadowColor = UIColor.gray.cgColor
        cView.backgroundColor = UIColor.white
    }
    
    @IBAction func Achivement_BtnClick(_ sender: Any)
    {
        let cAchivementList = self.storyboard?.instantiateViewController(withIdentifier: "AchivementList") as! AchivementList
        cAchivementList.setupData(cId: self.Up_id)
        
        navigationController?.pushViewController(cAchivementList, animated: true)
    }
    
    @IBAction func Feedback_BtnClick(_ sender: Any)
    {
        let vc1 = self.storyboard?.instantiateViewController(withIdentifier: "GetFeedbackVc") as! GetFeedbackVc
         vc1.setupData(cId: self.Up_id)
        vc1.checkEmp = Check
        navigationController?.pushViewController(vc1, animated: true)
    }
    
    @IBAction func Training_btnClicked(_ sender: Any)
    {
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "TrainListVc") as! TrainListVc
         vc2.setupData(cId: self.Up_id)
         navigationController?.pushViewController(vc2, animated: true)
    }
    
    @IBAction func KraWhgt_btnClicked(_ sender: Any)
    {
        let vc3 = self.storyboard?.instantiateViewController(withIdentifier: "KraListVc") as! KraListVc
        if Check
        {
            vc3.setEmpName(cNm: self.EmpNm!,bStatus: Check)
        }
        
        vc3.setupData(cId: self.Up_id)
        navigationController?.pushViewController(vc3, animated: true)
    }
    
    
}
