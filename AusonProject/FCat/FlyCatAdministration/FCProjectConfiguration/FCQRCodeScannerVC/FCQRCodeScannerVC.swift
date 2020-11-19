//
//  FCQRCodeScannerVC.swift
//  FlyCatAdministration
//
//  Created by Frank on 2018/9/17.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class FCQRCodeScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    typealias scanResult = (_ result: String) -> Void
    typealias OperationBlock = () -> Void
    
    //UI
    var scannerView : FCQRCodeScannerView!
    var scannerEngine : FCQRCodeScanerEngine!
    var maskView : FCQRCodeScannerView!
    
    //Engine
    var flashOpen: Bool! = nil
    var session:AVCaptureSession!
    
    //callback
    var scanResultBlock : scanResult?
    
    override func loadView() {
        super.loadView()
        self.title = "扫描二维码"
        self.maskView = FCQRCodeScannerView.init(frame: UIScreen.main.bounds)
        self.view = self.maskView
        
        self.addrightNavigationItemImgNameStr(nil, title: "相册", textColor: COLOR_HighlightColor, textFont: UIFont (_customTypeSize: 17), clickCallBack: {
            
            //获取相册权限, 有则打开相册
            self.photoAlbumPermissions(authorizedBlock: {
                
                self.getImageFromPhotoLib()
            }, deniedBlock: {
                
                self.headToSystemSettingPage()
            })
        })
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //获取相机权限, 有权限则打开相机
        cameraPermissions(authorizedBlock: {
            
            DispatchQueue.global().async {
                
                self.setCamera()
            }
            
        }, deniedBlock: {
            
            self.headToSystemSettingPage()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //设置相机
    private func setCamera() {
        //获取摄像设备
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else {
            
            return
        }
        
        do {
            //创建输入流
            var input:AVCaptureDeviceInput!
            
            do {
                
                let myinput:AVCaptureDeviceInput = try AVCaptureDeviceInput(device: device)
                input = myinput
                
            }catch let error as NSError{
                
                print(error)
            }
            
            //创建输出流
            let output = AVCaptureMetadataOutput()
            
            //设置会话
            session = AVCaptureSession()
            
            //连接输入输出
            
            if session.canAddInput(input){
                
                session.addInput(input)
            }
            
            if session.canAddOutput(output){
                
                session.addOutput(output)
                
                //设置输出流代理，从接收端收到的所有元数据都会被传送到delegate方法，所有delegate方法均在queue中执行
                
                output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                
                //设置扫描二维码类型
                
                output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
                
                let pickingHeight : CGFloat = 260
                let pickingWidth : CGFloat = 260
                
                //扫描区域
                //rectOfInterest 属性中x和y互换，width和height互换。
                output.rectOfInterest = CGRect(x: (kSCREENHEIGHT/2 - pickingHeight/2)/kSCREENHEIGHT, y: (kSCREENWIDTH/2-pickingWidth/2)/kSCREENWIDTH, width: pickingHeight/kSCREENHEIGHT, height: pickingWidth/kSCREENWIDTH)
            }
            
            //捕捉图层
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            DispatchQueue.main.async {
                
                previewLayer.frame = self.view.layer.bounds
                self.view.layer.insertSublayer(previewLayer, at: 0)
            }
            
            //持续对焦
            
            if device.isFocusModeSupported(.continuousAutoFocus){
                
                do {
                    try input.device.lockForConfiguration()
                    input.device.focusMode = .continuousAutoFocus
                    input.device.unlockForConfiguration()
                    
                }catch let error as NSError{
                    
                    print(error)
                }
            }
        }
        
        session.startRunning()
    }
    
    func scanDidCompleted(_ resultBlock: @escaping scanResult)  {
        
        self.scanResultBlock = resultBlock
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        session.stopRunning()
        self.maskView.stopAnimation()
        
        if let metadataObject = metadataObjects.first {
            
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject

            if self.scanResultBlock != nil {
                
                self.scanResultBlock!(readableObject.stringValue!)
            }
        }
    
        self.navigationController?.popViewController(animated: true)
    }
    
    private func detectQRCodeImage(image: UIImage?) {
        
        
        let ciImage:CIImage=CIImage(image:image!)!
        
        let context = CIContext(options: nil)
        let detector:CIDetector = CIDetector(ofType: CIDetectorTypeQRCode,
                                             context: context, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
        let features = detector.features(in: ciImage)
        
        if features.count != 0 {
            
            let feature: CIQRCodeFeature = features.first as! CIQRCodeFeature
            if self.scanResultBlock != nil {
                
                self.scanResultBlock!(feature.messageString!)
            }
            
            self.navigationController?.popViewController(animated: true)
        }else if self.session != nil{
            
            //恢复扫描
            self.maskView.resumeAnimation()
            session.startRunning()
            PCAlertManager.showAlertMessage("未检测到有效二维码")
        }else{
            
            PCAlertManager.showAlertMessage("未检测到有效二维码")
        }
    }
    
    
    //打开相册
    func getImageFromPhotoLib() {
        
        //停止扫描
        if session != nil {
            
            session.stopRunning()
            self.maskView.stopAnimation()
        }
        
        let pick = UIImagePickerController()
        pick.delegate = self
        pick.sourceType = .photoLibrary
        self.present(pick, animated: true, completion:nil)
    }
    
     //MARK:- UIImagePickerControllerDelegate
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let type:String = info[UIImagePickerController.InfoKey.mediaType as? String ?? ""] as? String ?? ""
        //当选择的类型是图片
        if type == "public.image" {
            
          
            let img = info[UIImagePickerController.InfoKey.originalImage as? String ?? ""] as? UIImage
            detectQRCodeImage(image: img)
        }
        
       picker.dismiss(animated:true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        picker.dismiss(animated: true) {
            
            if self.session != nil {
                
                self.maskView.resumeAnimation()
                self.session.startRunning()
            }
        }
    }

    //相册权限
    private func photoAlbumPermissions(authorizedBlock: OperationBlock?, deniedBlock: OperationBlock?) {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        
        // .notDetermined  .authorized  .restricted  .denied
        if authStatus == .notDetermined {
            
            // 第一次触发授权alert
            PHPhotoLibrary.requestAuthorization { (status:PHAuthorizationStatus) -> Void in
                
                self.photoAlbumPermissions(authorizedBlock: authorizedBlock, deniedBlock: deniedBlock)
            }
        }else if authStatus == .authorized {
            
            if authorizedBlock != nil {
                authorizedBlock!()
            }
        }else{
            
           
            if deniedBlock != nil {
                deniedBlock!()
            }
        }
    }
        
    
    // 相机权限
    private func cameraPermissions(authorizedBlock: OperationBlock?, deniedBlock: OperationBlock?) {
        
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        // .notDetermined  .authorized  .restricted  .denied
        if authStatus == .notDetermined {
            // 第一次触发授权 alert
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                
                self.cameraPermissions(authorizedBlock: authorizedBlock, deniedBlock: deniedBlock)
            })
        }else if authStatus == .authorized {
            
            if authorizedBlock != nil {
                authorizedBlock!()
            }
        }else {
            
            if deniedBlock != nil {
                deniedBlock!()
            }
        }
    }
    
    private func headToSystemSettingPage() {
        
        PCAlertManager.showCustomAlertView("缺少权限", message: "去系统设置界面打开相机或相册权限", btnFirstTitle: "取消", btnFirstBlock: {
            
        }, btnSecondTitle: "设置") {
            
            if let url = URL(string: UIApplication.openSettingsURLString){
                
                if (UIApplication.shared.canOpenURL(url)){
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}
    

