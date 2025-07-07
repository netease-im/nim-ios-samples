//
//  MediaUtil.swift
//  nim-ios-samples
//
//  Created by 陈吉力 on 2025/6/23.
//

import Foundation
import AVFoundation
import CoreVideo
import UIKit

class MediaUtil: NSObject {
    
    static func randomAudioPath(targetSizeInBytes: Int, fileName: String? = nil) -> String? {
        var name: String
        if let fileName = fileName {
            name = fileName
        } else {
            name = UUID().uuidString + ".wav"
        }
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name)
        
        // WAV文件头大小 (44字节)
        let wavHeaderSize = 44
        
        // 确保目标大小至少包含WAV头
        guard targetSizeInBytes > wavHeaderSize else {
            Logger.log("target size: \(targetSizeInBytes) bytes is too small for a WAV file. Must be greater than \(wavHeaderSize) bytes.")
            return nil
        }
        
        // 计算音频数据大小
        let audioDataSize = targetSizeInBytes - wavHeaderSize
        
        // 音频参数
        let sampleRate: UInt32 = 44100
        let channels: UInt16 = 2  // 立体声
        let bitsPerSample: UInt16 = 16
        let bytesPerSample = Int(channels) * Int(bitsPerSample) / 8
        
        // 创建WAV文件头
        var wavHeader = Data()
        
        // RIFF头
        wavHeader.append("RIFF".data(using: .ascii)!)
        wavHeader.append(withUnsafeBytes(of: UInt32(targetSizeInBytes - 8).littleEndian) { Data($0) })
        wavHeader.append("WAVE".data(using: .ascii)!)
        
        // fmt子块
        wavHeader.append("fmt ".data(using: .ascii)!)
        wavHeader.append(withUnsafeBytes(of: UInt32(16).littleEndian) { Data($0) }) // fmt子块大小
        wavHeader.append(withUnsafeBytes(of: UInt16(1).littleEndian) { Data($0) })  // 音频格式 (PCM)
        wavHeader.append(withUnsafeBytes(of: channels.littleEndian) { Data($0) })   // 声道数
        wavHeader.append(withUnsafeBytes(of: sampleRate.littleEndian) { Data($0) }) // 采样率
        
        let byteRate = sampleRate * UInt32(channels) * UInt32(bitsPerSample) / 8
        wavHeader.append(withUnsafeBytes(of: byteRate.littleEndian) { Data($0) })   // 字节率
        
        let blockAlign = channels * bitsPerSample / 8
        wavHeader.append(withUnsafeBytes(of: blockAlign.littleEndian) { Data($0) }) // 块对齐
        wavHeader.append(withUnsafeBytes(of: bitsPerSample.littleEndian) { Data($0) }) // 位深度
        
        // data子块头
        wavHeader.append("data".data(using: .ascii)!)
        wavHeader.append(withUnsafeBytes(of: UInt32(audioDataSize).littleEndian) { Data($0) })
        
        // 生成随机音频数据
        var audioData = Data()
        let bufferSize = min(audioDataSize, 1024 * 1024) // 1MB缓冲区
        var remainingBytes = audioDataSize
        
        while remainingBytes > 0 {
            let currentBufferSize = min(bufferSize, remainingBytes)
            var randomBuffer = Data(count: currentBufferSize)
            
            // 生成随机数据
            randomBuffer.withUnsafeMutableBytes { bytes in
                guard let baseAddress = bytes.baseAddress else { return }
                arc4random_buf(baseAddress, currentBufferSize)
            }
            
            // 为了生成更好听的随机音频，可以对数据进行一些处理
            // 这里简单地减小幅度以避免过于刺耳的噪音
            for i in 0..<currentBufferSize {
                let originalValue = randomBuffer[i]
                randomBuffer[i] = UInt8(Int(originalValue) / 4 + 64) // 减小幅度并添加偏移
            }
            
            audioData.append(randomBuffer)
            remainingBytes -= currentBufferSize
        }
        
        // 合并头部和音频数据
        var finalData = Data()
        finalData.append(wavHeader)
        finalData.append(audioData)
        
        // 保存文件
        do {
            try finalData.write(to: fileURL)
            Logger.log("random audio created at: \(fileURL.path). size: \(finalData.count) bytes")
            return fileURL.path
        } catch {
            Logger.log("failed to write random audio file: \(error)")
            return nil
        }
    }
    
    static func randomImage() -> UIImage {
        return self.genImage(1024, count: 200)
    }
    
    static func randomImageData() -> Data? {
        let image = self.randomImage()
        return image.jpegData(compressionQuality: 1.0)

    }
    
    static func randomImagePath() -> String? {
        let image = self.randomImage()
        let data = image.jpegData(compressionQuality: 1.0)
        let name = UUID().uuidString + ".jpg"
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name)
        
        do {
            try  data?.write(to: url, options: NSData.WritingOptions.atomicWrite)
        } catch {
            return nil
        }
        return url.path
    }
    
    static func randomVideoPath(targetSizeInBytes: Int, fileName: String? = nil) -> String? {
        var name: String
        if let fileName = fileName {
            name = fileName
        } else {
            name = UUID().uuidString + ".mp4"
        }
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name)
        
        // 删除已存在的文件
        try? FileManager.default.removeItem(at: fileURL)
        
        // 视频参数
        let videoWidth = 160
        let videoHeight = 120
        let frameRate = 10
        let videoDuration = 1.0 // 初始时长，会根据目标大小调整
        
        // 创建AVAssetWriter
        guard let assetWriter = try? AVAssetWriter(outputURL: fileURL, fileType: .mp4) else {
            print("无法创建AVAssetWriter")
            return nil
        }
        
        // 视频输出设置
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: videoWidth,
            AVVideoHeightKey: videoHeight,
            AVVideoCompressionPropertiesKey: [
                AVVideoAverageBitRateKey: self.calculateBitRate(targetSize: targetSizeInBytes, duration: videoDuration),
                AVVideoProfileLevelKey: AVVideoProfileLevelH264BaselineAutoLevel
            ]
        ]
        
        let videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        videoInput.expectsMediaDataInRealTime = false
        
        // 像素缓冲区适配器
        let pixelBufferAttributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
            kCVPixelBufferWidthKey as String: videoWidth,
            kCVPixelBufferHeightKey as String: videoHeight
        ]
        
        let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: videoInput,
            sourcePixelBufferAttributes: pixelBufferAttributes
        )
        
        // 添加输入到writer
        guard assetWriter.canAdd(videoInput) else {
            print("无法添加视频输入")
            return nil
        }
        assetWriter.add(videoInput)
        
        // 开始写入
        guard assetWriter.startWriting() else {
            print("无法开始写入")
            return nil
        }
        
        assetWriter.startSession(atSourceTime: .zero)
        
        // 生成视频帧
        let semaphore = DispatchSemaphore(value: 0)
        var frameCount = 0
        let totalFrames = Int(videoDuration * Double(frameRate))
        
        videoInput.requestMediaDataWhenReady(on: DispatchQueue.global()) {
            while videoInput.isReadyForMoreMediaData && frameCount < totalFrames {
                let presentationTime = CMTime(value: Int64(frameCount), timescale: Int32(frameRate))
                
                if let pixelBuffer = self.createRandomPixelBuffer(width: videoWidth, height: videoHeight) {
                    pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
                }
                
                frameCount += 1
            }
            
            videoInput.markAsFinished()
            semaphore.signal()
        }
        
        // 等待写入完成
        semaphore.wait()
        
        // 完成写入
        let group = DispatchGroup()
        group.enter()
        
        assetWriter.finishWriting {
            group.leave()
        }
        
        group.wait()
        
        // 检查文件大小并调整
        if let fileSize = getFileSize(at: fileURL) {
            print("生成的视频文件大小: \(fileSize) bytes")
            
            // 如果文件大小差距太大，可以尝试调整
            if abs(fileSize - targetSizeInBytes) > targetSizeInBytes / 10 {
                print("文件大小与目标大小差距较大，实际: \(fileSize), 目标: \(targetSizeInBytes)")
            }
        }
        
        return fileURL.path
    }

    // 辅助函数：计算比特率
    private static func calculateBitRate(targetSize: Int, duration: Double) -> Int {
        // 考虑到H.264编码的开销，使用80%的比率
        let bitsPerSecond = (Double(targetSize * 8) / duration) * 0.8
        return Int(bitsPerSecond)
    }

    // 辅助函数：创建随机像素缓冲区
    private static func createRandomPixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        let attributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
            kCVPixelBufferWidthKey as String: width,
            kCVPixelBufferHeightKey as String: height
        ]
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attributes as CFDictionary, &pixelBuffer)
        
        guard status == kCVReturnSuccess, let buffer = pixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(buffer, [])
        
        let pixelData = CVPixelBufferGetBaseAddress(buffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(buffer)
        
        // 填充随机颜色数据
        for y in 0..<height {
            for x in 0..<width {
                let pixelIndex = y * bytesPerRow + x * 4
                let pixel = pixelData!.advanced(by: pixelIndex).assumingMemoryBound(to: UInt8.self)
                
                // ARGB格式
                pixel[0] = UInt8.random(in: 0...255) // A
                pixel[1] = UInt8.random(in: 0...255) // R
                pixel[2] = UInt8.random(in: 0...255) // G
                pixel[3] = UInt8.random(in: 0...255) // B
            }
        }
        
        CVPixelBufferUnlockBaseAddress(buffer, [])
        
        return buffer
    }

    // 辅助函数：获取文件大小
    private static func getFileSize(at url: URL) -> Int? {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
            return attributes[.size] as? Int
        } catch {
            print("获取文件大小失败: \(error)")
            return nil
        }
    }
    
    static func randomTextFilePath(targetSizeInBytes: Int, fileName: String?) -> String? {
        var name: String
        if let fileName = fileName {
            name = fileName
        } else {
            name = UUID().uuidString + ".txt"
        }
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name)
        
        // 删除已存在的文件
        try? FileManager.default.removeItem(at: fileURL)
        
        // 确保目标大小大于0
        guard targetSizeInBytes > 0 else {
            print("目标文件大小必须大于0")
            return nil
        }
        
        // 生成随机文本内容
        let randomText = generateRandomText(targetSize: targetSizeInBytes)
        
        do {
            // 将文本写入文件
            try randomText.write(to: fileURL, atomically: true, encoding: .utf8)
            
            // 验证文件大小
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: fileURL.path)
            let actualSize = fileAttributes[.size] as? Int ?? 0
            
            print("文件创建成功")
            print("目标大小: \(targetSizeInBytes) 字节")
            print("实际大小: \(actualSize) 字节")
            print("文件路径: \(fileURL.path)")
            
            return fileURL.path
            
        } catch {
            print("文件写入失败: \(error.localizedDescription)")
            return nil
        }
    }

    // 生成指定大小的随机文本
    static func generateRandomText(targetSize: Int) -> String {
        // 可用字符集（包含字母、数字、标点符号、空格、换行符）
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.,!?;: \n\t"
        let charactersArray = Array(characters)
        
        var result = ""
        var currentSize = 0
        
        // 生成随机文本直到达到目标大小
        while currentSize < targetSize {
            let randomCharacter = charactersArray.randomElement()!
            let characterString = String(randomCharacter)
            
            // 检查添加这个字符后是否会超过目标大小
            let characterData = characterString.data(using: .utf8) ?? Data()
            let characterSize = characterData.count
            
            if currentSize + characterSize <= targetSize {
                result += characterString
                currentSize += characterSize
            } else {
                // 如果添加完整字符会超过大小，则用空格填充剩余空间
                let remainingSize = targetSize - currentSize
                if remainingSize > 0 {
                    result += String(repeating: " ", count: remainingSize)
                }
                break
            }
        }
        
        return result
    }
    
    fileprivate static func genImage(_ imageSize : Float, count : Int) -> UIImage {
        let size = CGSize(width: CGFloat(imageSize), height: CGFloat(imageSize));
        
        UIGraphicsBeginImageContext(size)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.beginPath()
        
        let maxSize = UInt32(UInt(imageSize))
        
        for _ in 0...count {

            let radius = CGFloat(arc4random_uniform(maxSize / 2) / 2)
            let x = CGFloat(arc4random_uniform(maxSize))
            let y = CGFloat(arc4random_uniform(maxSize))
            let r = CGFloat(arc4random_uniform(256)) / 255.0
            let g = CGFloat(arc4random_uniform(256)) / 255.0
            let b = CGFloat(arc4random_uniform(256)) / 255.0
            let alpha = CGFloat(arc4random_uniform(256)) / 255.0
            
            ctx?.addArc(center:CGPoint(x:x,y:y),radius:radius,startAngle:0,endAngle: CGFloat(2 * Double.pi),clockwise:false)
            ctx?.setFillColor(red: r,green: g,blue: b,alpha: alpha)
            ctx?.fillPath()

        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!;
    }
    
    fileprivate static func dataByInfo(_ filename : String , ext : String) -> Data? {
        guard let filepath = Bundle.main.path(forResource: filename, ofType: ext),
            let data = try? Data(contentsOf: URL(fileURLWithPath: filepath)),
            let appendData = UUID().uuidString.data(using: String.Encoding.utf8) else {
                return nil
        }
        var result = NSData(data: data) as Data
        result.append(appendData)
        return result
    }
    fileprivate static func filepathByInfo(_ filename : String, ext : String) -> String? {

        let name = UUID().uuidString + "." + ext
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name)
        let data = self.dataByInfo(filename, ext: ext)
        do {
            try  data?.write(to: url, options: NSData.WritingOptions.atomicWrite)
        } catch {
            return nil
        }
        return url.path
    }

    fileprivate static func dataBySize(_ filename : String , ext : String , size : Int64) -> Data? {
        guard let filepath = Bundle.main.path(forResource: filename, ofType: ext),
              let data = try? Data(contentsOf: URL(fileURLWithPath: filepath)),
              let appendData = NSMutableData(capacity: Int(size)) else {
            return nil
        }
        // 创建size个字节的Data
        // 设置足够多的随机数据到data
        let randomData = NSMutableData(length: 1024)!
        arc4random_buf(randomData.mutableBytes, randomData.length)
        while appendData.length < size {
            appendData.append(randomData as Data)
        }
        var result = NSData(data: data) as Data
        result.append(appendData as Data)
        return result
    }

    fileprivate static func filepathWithData(_ filename : String, ext : String, size: Int64) -> String? {
        let name = UUID().uuidString + "." + ext
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(name)
        let data = self.dataBySize(filename, ext: ext, size: size)
        do {
            try  data?.write(to: url, options: NSData.WritingOptions.atomicWrite)
        } catch {
            return nil
        }
        return url.path
    }
}
