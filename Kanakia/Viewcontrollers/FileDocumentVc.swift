//
//  FileDocumentVc.swift
//  Kanakia SOP
//
//  Created by user on 26/03/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import Alamofire

class FileDocumentVc: UIViewController,UIDocumentInteractionControllerDelegate,UITableViewDataSource,UITableViewDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var FileNameLbl      : UILabel!
    @IBOutlet weak var imgThambnail     : UIImageView!
    @IBOutlet weak var resFile: UILabel!
    @IBOutlet weak var resRemark: UILabel!
    @IBOutlet weak var resMom: UITextView!
    var Selected_m_id : String!
    var DocumentArr = [Any]()
    
    var cDocumentInteractionController: UIDocumentInteractionController!
    var path = "http://www.kanishkagroups.com/sop/upload_mom/"
    
    var StringURL : String!
    var toast = JYToast()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.resRemark.layer.borderColor = UIColor.purple.cgColor
        self.resMom.layer.borderColor = UIColor.purple.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpData(mM_id: String)
    {
        self.Selected_m_id = mM_id
        print("M_id = \(self.Selected_m_id!)")
        fetchFile()
    }
    
    func fetchFile()
    {
        let fileUrl =  "http://www.kanishkagroups.com/sop/android/getSingleMeetingDetailMms.php"
        
        let postData : [String: Any] =
            [
                "m_id" : self.Selected_m_id!
        ]
        
        print(postData)
       
        Alamofire.request(fileUrl, method: .post, parameters:postData).responseJSON { (resp) in
            print(resp)
            
            switch resp.result
            {
            case .success(_):
                
                let data = resp.result.value as! [AnyObject]
                print(data)
                
                let Md_id = data[0]["md_id"] as! String
                let md_attachment = data[0]["md_attachment"] as! String
                let md_Minutes = data[0]["md_minutes"] as! String
                let md_remark = data[0]["md_remark"] as! String
                UserDefaults.standard.set(Md_id, forKey: "md_id")
                self.resMom.text = md_Minutes
                self.resRemark.text = md_remark
                
                let lcAttacmentArr = self.getArrayFromJSonString(cJsonStr: md_attachment)
                print(lcAttacmentArr)
                self.DocumentArr.removeAll(keepingCapacity: false)
                
                for lcAttacment in lcAttacmentArr
                {
                    let lcFilePath = self.path + "\(lcAttacment)"
                    print("lcFilePath=",lcFilePath)
                    self.DocumentArr.append(lcAttacment)
                }
                
                self.tableView.reloadData()
                
                break
                
            case .failure(_):
                self.toast.isShow(EncodingError.self as! String)
                break
            }
            
           
        }
 }

    @IBAction func OnCancel_BtnClick(_ sender: Any)
    {
        self.view.removeFromSuperview()
    }
    
    func getArrayFromJSonString(cJsonStr: String)->[String]
    {
        let jsonData = cJsonStr.data(using: .utf8)!
        
        guard let lcArrData = try? JSONSerialization.jsonObject(with: jsonData, options: []) as! [String] else {
            return ["No Found"]
        }
       
        return lcArrData
    }
    
//MARK: UIDocumentInteractionController delegates
   

    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DocumentArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let lcDocumentCell = self.tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath) as! DocumentCell
        let theFileName = self.DocumentArr[indexPath.row] as! String
        
        lcDocumentCell.DocumentNamelbl.text = (theFileName as NSString).lastPathComponent
        
        return lcDocumentCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
       let lcFileName = self.DocumentArr[indexPath.row] as! String
        let lcFilePath = self.path + "\(lcFileName)"
        print("lcFilePath =",lcFilePath)
        let urlString: String! = (lcFilePath as AnyObject).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

            print("fileRemoveSpace=",lcFilePath)

            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                let documentsURL: NSURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
                print("DocumentURl: = ",documentsURL)
                let fileURL = documentsURL.appendingPathComponent("0.pdf")
                print("fileURl =", fileURL as Any)
                return (fileURL!, [.removePreviousFile, .createIntermediateDirectories])
            }

            Alamofire.download(urlString, to: destination).response
                { response in
                    print(response)

                    if response.error == nil, let filePath = response.destinationURL?.path
                    {
                        print("mmm",filePath)
                        self.StringURL = filePath
                       // self.FileNameLbl.text = lcAttachment
                        
                        let lcPDFReaderVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: PDFReaderVC.storyboardID) as! PDFReaderVC
                        lcPDFReaderVC.URLString = self.StringURL
                        self.present(lcPDFReaderVC, animated: true, completion: nil)
                    }
         }
    }
}
    

