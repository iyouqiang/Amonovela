
//
//  FCCrypto.swift
//  swifter
//
//  Created by Frank on 2018/9/6.
//  Copyright © 2018年 Lee. All rights reserved.
//

import UIKit

let CRYPTO_BOOK_SIZE : UInt8 = 16

let CRYPTO_BOOK : [UInt64] = [1350510043,
                              1608790369,
                              6257836237,
                              13231405039,
                              55072817851,
                              96914230663,
                              159676349881,
                              536249065189,
                              1665967211113,
                              15222584962201,
                              121980949752019,
                              625270383761161,
                              1265820572500069,
                              1540342081959601,
                              3187471138716793,
                              8128858308988369]

extension Date {
    
    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int64(timeInterval)
        return "\(timeStamp)"
    }
}

class FCCrypto: NSObject {

    @objc public class func Encoding(raw_in: String) -> String {
        let len = raw_in.count
        var byte_raw_in = stringToBytes(Str: raw_in)
        
        let index = Int64(Date().timeStamp)! % Int64(CRYPTO_BOOK_SIZE)
        
        var seed = CRYPTO_BOOK[Int(index)]
        var byte_array : [UInt8] = [UInt8]()
        byte_array.append(UInt8(index))
        
        for i in 0..<len {
            
            var a = (UInt64(byte_raw_in[i])^seed) >> 4
            var b = ((UInt64(byte_raw_in[i]) << 17)^seed) >> (17-4)
            a = (a << 56) >> 56
            b = (b << 56) >> 56
            a &= 0x0f
            b &= 0xf0
            let x = UInt8((a | b))
            byte_array.append(x)
            seed ^= UInt64(byte_raw_in[i])
        }

        let encodeStr = BytesToHexString(bytes: byte_array)
        
//        let utf8EncodeData = encodeStr.data(using: String.Encoding.utf8, allowLossyConversion: true)
//        let base64String = utf8EncodeData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0)))
//        print("encodedString: \(base64String!)")
        
        return encodeStr
    }
    
    @objc public class func Decoding(raw_out : String) -> String{
        
        //    let base64Data = NSData(base64Encoded:raw_out, options:NSData.Base64DecodingOptions(rawValue: 0))
        //    let stringWithDecode = NSString(data:base64Data! as Data, encoding:String.Encoding.utf8.rawValue)
        //    print("base64String \(stringWithDecode!)")
        
        var raw_in = hexStringToBytes(hexStr: raw_out)
        let len = raw_in.count
        let idx = raw_in[0]
        let index = Int(idx)
        var seed = CRYPTO_BOOK[index]
        
        var bytes = [UInt8]()
        
        for i in 1..<len {
            
            var a  = UInt64((raw_in[i] & 0x0F))
            var b  = UInt64((raw_in[i] & 0xF0))
            
            a = ((a << 4 ) ^ seed) & 0xF0
            b = (((b << (17 - 4)) ^ seed) >> 17) & 0x0F
            a = (a << 56) >> 56
            b = (b << 56) >> 56
            
            let x = UInt8 (a | b)
            bytes.append(x)
            seed ^= (a | b)
        }
        
        return BytesToString(bytes: bytes)
    }
    
    
    @objc private class func stringToBytes(Str : String) -> [UInt8] {
        
        var bytes = [UInt8]()
        
        for ch in Str {
            
            var numberFromC=0
      
            for scalar in String(ch).unicodeScalars
            {
                numberFromC = Int(scalar.value)
            }
            
            bytes.append(UInt8(numberFromC))
        }
        
        return bytes
    }
    
    @objc private class func hexStringToBytes(hexStr: String) -> [UInt8] {
        assert(hexStr.count % 2 == 0, "输入字符串格式不对，8位代表一个字符")
        var bytes = [UInt8]()
        var sum = 0
        // 整形的 utf8 编码范围
        let intRange = 48...57
        // 小写 a~f 的 utf8 的编码范围
        let lowercaseRange = 97...102
        // 大写 A~F 的 utf8 的编码范围
        let uppercasedRange = 65...70
        
        for (index, c) in hexStr.utf8CString.enumerated() {
            var intC = Int(c.byteSwapped)
            if intC == 0 {
                break
            } else if intRange.contains(intC) {
                intC -= 48
            } else if lowercaseRange.contains(intC) {
                intC -= 87
            } else if uppercasedRange.contains(intC) {
                intC -= 55
            } else {
                assertionFailure("输入字符串格式不对，每个字符都需要在0~9，a~f，A~F内")
            }
            sum = sum * 16 + intC
            // 每两个十六进制字母代表8位，即一个字节
            if index % 2 != 0 {
                bytes.append(UInt8(sum))
                sum = 0
            }
        }
        return bytes
    }
    
    
    private static func BytesToHexString(bytes: [UInt8]) -> String {
        
        var hexStr : String = String()
        
        for num in bytes {
            
            hexStr += String(format: "%02x", num)
        }
        
        return hexStr
    }
    
    private static func BytesToString(bytes: [UInt8]) -> String {
        
        var str : String = String()
        
        for num in bytes {
            
            str.append (Character(UnicodeScalar(num)))
        }
    
        return str
    }

    static func FCCryptoExample() {
        
        let raw_out = FCCrypto.Encoding(raw_in: "_w94e35987dbd249049fcf47c78d9b9ab8")
        
        print("加密前的字符串为：","_w94e35987dbd249049fcf47c78d9b9ab8")
        
        print("加密后的字符串为：", raw_out)
        
        print("解密后的字符串为：", FCCrypto.Decoding(raw_out: raw_out))
        
    }
}
