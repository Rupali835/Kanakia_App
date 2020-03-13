//
//  MomVc.swift
//  Kworld
//
//  Created by user on 12/03/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import Foundation
import SVProgressHUD

class MomVc: UIViewController, UITextViewDelegate  //,UIDocumentMenuDelegate,UIDocumentPickerDelegate
{
    @IBOutlet weak var txtRemark: UITextView!
    @IBOutlet weak var txtMinOfM: UITextView!
    @IBOutlet weak var MomView: UIView!
    
    var activeField        : UITextField?
    private var toast: JYToast!
    var attachmentArr : NSMutableArray!
    var Selected_m_id : String!
    var momSt : String!
    var strUserId:String = ""
    var TypeMom = String()
    
    var DBAttachmentArr = [DBAttachment]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        
        txtMinOfM.delegate = self
        txtRemark.delegate = self
        let userDict = UserDefaults.standard.value(forKey: "userdata") as! NSDictionary
        strUserId = userDict["user_id"] as! String
        
        self.txtRemark.layer.borderColor = UIColor.purple.cgColor
        self.txtMinOfM.layer.borderColor = UIColor.purple.cgColor
        initUi()
        

     
        self.DBAttachmentArr.removeAll(keepingCapacity: false)
       
    }

    
    private func textFieldDidBeginEditing(_ textField: UITextField)
    {
        activeField = textField
    }
    
     private func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
    
        return true
    }
    
    
   func initUi() {
        toast = JYToast()
    }
    
    func setUpData(lcM_id: String)
    {
        self.Selected_m_id = lcM_id
        print("M_id = \(self.Selected_m_id!)")
        
    }
    
    func setData(mM_id: String)
    {
        self.momSt = mM_id
        print(self.momSt)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
   
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
  
    @IBAction func AttachSubmit_BtnClick(_ sender: Any)
    {
        uploadWithAlamofire()
    }
    
    @IBAction func AttachCancel_BtnClick(_ sender: Any)
    {
        self.view.removeFromSuperview()
    }
    
    @IBAction func OpenFile_BtnClick(_ sender: Any)
    {
      
    let attachmentPickerController = DBAttachmentPickerController.imagePickerControllerFinishPicking({ CDBAttachmentArr in
      
    
        for lcAttachment in CDBAttachmentArr
        {
            print("fileName= \(lcAttachment.fileName)")
            print("fileSizeStr = \(String(describing: lcAttachment.fileSizeStr))")
           
            print("Count= \(self.DBAttachmentArr.count)")
            
               self.DBAttachmentArr.append(lcAttachment)
            
            
        }
            self.toast.isShow("file attached successfully")
        
        }, cancel: nil)

        
        attachmentPickerController.mediaType = .image
        attachmentPickerController.mediaType = .video
        attachmentPickerController.mediaType = .other
        
        attachmentPickerController.capturedVideoQulity = UIImagePickerControllerQualityType.typeHigh
        
        attachmentPickerController.allowsMultipleSelection = true
        attachmentPickerController.allowsSelectionFromOtherApps = true
        attachmentPickerController.present(on: self)
        
    }
    
  
 //**********************    Upload File      *************************//
    
    func uploadWithAlamofire()
    {
        
        let strUrl = "http://kanishkagroups.com/sop/android/insertMomMms.php"

        var parameters = [String: Any]()
        
        if self.momSt == "1"
        {
            self.TypeMom = "2"
            let md_id: String! = UserDefaults.standard.string(forKey: "md_id")
    parameters =
                [
                    "u_id" : self.strUserId ,
                    "doc_count" : "1",
                    "remark" : txtRemark.text!,
                    "md_id" : md_id!,
                    "mom" : txtMinOfM.text!,
                    "type" : self.TypeMom
               ]
            
            
        }else
        {
           self.TypeMom = "1"
            
            parameters =
                [
                    "u_id" : self.strUserId,
                    "doc_count" : "1",
                    "remark" : self.txtRemark.text!,
                    "m_id" : self.Selected_m_id!,
                    "mom" : self.txtMinOfM.text!,
                    "type" : self.TypeMom
                 ]
        }
        
        print(parameters)
      
        
        for lcAttachment in self.DBAttachmentArr
        {
            var MimeType = String()
            
            let lcFileName: String? = lcAttachment.fileName
            let fileName = lcAttachment.fileName?.fileName()
            let fileExtension = lcAttachment.fileName?.fileExtension()
            print(fileExtension!)
            
           if (fileExtension == "jpg") || (fileExtension == "PNG") || (fileExtension == "jpeg") || (fileExtension == "JPEG") || (fileExtension == "GIF") || (fileExtension == "gif") || (fileExtension == "JPG") || (fileExtension == "png")
            {
                MimeType = "image/jpeg"
            }
            if fileExtension == "pdf"
            {
                MimeType = "pdf/text"
            }
            if fileExtension == "css"
            {
                MimeType = "text/css"
            }
            if (fileExtension == "htm") || (fileExtension == "html")
            {
                MimeType = "text/html"
            }
        
                let lcURL: URL! = lcAttachment.url
                print("URL = \(lcURL)")
            
            if lcURL == nil
            {
                self.toast.isShow("This file cannot be uploaded")
                self.view.removeFromSuperview()
                return
            }
    
            
            OperationQueue.main.addOperation {
                SVProgressHUD.setDefaultMaskType(.custom)
                SVProgressHUD.setBackgroundColor(UIColor.gray)
                SVProgressHUD.setBackgroundLayerColor(UIColor.clear)
                SVProgressHUD.show()
            }
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    
                            multipartFormData.append(lcURL!, withName: "document", fileName: lcFileName!, mimeType: MimeType)
                    
                    for (key, val) in parameters {
                        multipartFormData.append((val as AnyObject).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue).rawValue)!, withName: key)
                    }
            },
                
                usingThreshold : SessionManager.multipartFormDataEncodingMemoryThreshold,
                to : strUrl,
                method: .post)
            { (result) in
                
              
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        
                        OperationQueue.main.addOperation {
                            SVProgressHUD.dismiss()
                            
                        }
                        
                        switch response.result
                        {
                        case .success(_):
                           if let jsonResponse = response.result.value as? [String: Any] {
                                print(jsonResponse)
                                self.fetchFile()
                                let resData = jsonResponse["msg"] as! String
                            
                            if resData == "Minutes Of Meeting Updated Successfully"
                            {
                                self.toast.isShow("Minutes of meeting added successfully")
                                self.view.removeFromSuperview()
                            }
                            
                                let concurrentQueue = DispatchQueue(label: "queuename", attributes: .concurrent)
                                concurrentQueue.sync {
                                    self.toast.isShow(resData)
                                }
                                
                            }
                            
                            break
                        
                        case .failure(_):
                            self.toast.isShow("Something went wrong")
                            break
                            
                        }
                        
                      
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                    self.toast.isShow(encodingError as! String)
                }
                
            }
            

    }
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
            let data = resp.result.value as! [AnyObject]
            print(data)
            
           let Md_id = data[0]["md_id"] as! String
            
            
          UserDefaults.standard.set(Md_id, forKey: "md_id")
            
        }
    }
 
}

extension String {
    
    func fileName() -> String {
        return NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent ?? ""
    }
    
    func fileExtension() -> String {
        return NSURL(fileURLWithPath: self).pathExtension ?? ""
    }
}



