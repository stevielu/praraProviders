//The MIT License (MIT)
//
//Copyright (c) 2016 U Are My SunShine
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

/** 
 DiskCache
 
 thread safe = concurrent + semaphore lock
 
 sync
 thread safe write = write + semaphore lock
 thread safe read = read + semaphore lokc
 
 async
 thread safe write = async concurrent queue + thread safe sync write
 thread safe read = async concurrent queue + thread safe sync read
 */

import Foundation
import QuartzCore

/**
 *  FastGeneratorType, inherit GeneratorType and provide a method to shift offset.
 */
public protocol FastGeneratorType: IteratorProtocol {
    
    /**
     Shift like next, but there is no return value.
     If you just shift offset, it`s implementation should fast than `next()`
     */
    func shift()
}

/**
 DiskCacheGenerator, support `for...in` `map` `forEach`..., it is thread safe.
 */
 class DiskCacheGenerator : FastGeneratorType {
    
    public typealias Element = (String, AnyObject)
    
    fileprivate var _lruGenerator: LRUGenerator<DiskCacheObject>
    
    fileprivate var _diskCache: DiskCache
    
    fileprivate var _completion: (() -> Void)?
    
    fileprivate init(generate: LRUGenerator<DiskCacheObject>, diskCache: DiskCache, completion: (() -> Void)?) {
        self._lruGenerator = generate
        self._diskCache = diskCache
        self._completion = completion
    }
    
    /**
     Advance to the next element and return it, or `nil` if no next element exists.
     
     - returns: next element
     */
    
     func next() -> Element? {
        if let key = _lruGenerator.next()?.key {
            if  let value = _diskCache._unsafeObject(forKey: key) {
                return (key, value)
            }
        }
        return nil
    }
    
    /**
     Shift like next, but there is no return value and shift fast.
     */
     func shift() {
        let _ = _lruGenerator.shift()
    }
    
    deinit {
        _completion?()
    }
}

private class DiskCacheObject: LRUObject {
    
    var key: String = ""
    var cost: UInt = 0
    var date: Date = Date()
    
    init (key: String, cost: UInt = 0, date: Date) {
        self.key = key
        self.cost = cost
        self.date = date
    }
    
    convenience init (key: String, cost: UInt = 0) {
        self.init(key: key, cost: cost, date: Date())
    }
}

public typealias DiskCacheAsyncCompletion = (_ cache: DiskCache?, _ key: String?, _ object: AnyObject?) -> Void

/**
 DiskCache is a thread safe cache implement by dispatch_semaphore_t lock and DISPATCH_QUEUE_CONCURRENT
 Cache algorithms policy use LRU (Least Recently Used) implement by linked list.
 You can manage cache through functions to limit size, age of entries and memory usage to eliminate least recently used object.
 And support thread safe `for`...`in` loops, map, forEach...
 */
 class DiskCache {
    
    /**
     DiskCache folder name
     */
     let name: String
    
    /**
     DiskCache folder path URL
     */
     let cacheURL: URL
    
    /**
     Disk cache object total count
     */
     var totalCount: UInt {
        get {
            _lock()
            let count = _cache.count
            _unlock()
            return count
        }
    }
    
    /**
     Disk cache object total cost (byte)
     */
     var totalCost: UInt {
        get {
            _lock()
            let cost = _cache.cost
            _unlock()
            return cost
        }
    }
    
    fileprivate var _countLimit: UInt = UInt.max
    
    /**
     The maximum total quantity
     */
     var countLimit: UInt {
        set {
            _lock()
            _countLimit = newValue
            _unlock()
            trim(toCount: newValue)
        }
        get {
            _lock()
            let countLimit = _countLimit
            _unlock()
            return countLimit
        }
    }
    
    fileprivate var _costLimit: UInt = UInt.max
    
    /**
     The maximum disk cost limit
     */
     var costLimit: UInt {
        set {
            _lock()
            _costLimit = newValue
            _unlock()
            trim(toCost: newValue)
        }
        get {
            _lock()
            let costLimit = _costLimit
            _unlock()
            return costLimit
        }
    }
    
    fileprivate var _ageLimit: TimeInterval = DBL_MAX
    
    /**
     Disk cache object age limit
     */
     var ageLimit: TimeInterval {
        set {
            _lock()
            _ageLimit = newValue
            _unlock()
            trim(toAge: newValue)
        }
        get {
            _lock()
            let ageLimit = _ageLimit
            _unlock()
            return ageLimit
        }
    }
    
    fileprivate let _cache: LRU = LRU<DiskCacheObject>()
    
    fileprivate let _queue: DispatchQueue = DispatchQueue(label: TrackCachePrefix + (String(describing: DiskCache)), attributes: DispatchQueue.Attributes.concurrent)
    
    fileprivate let _semaphoreLock: DispatchSemaphore = DispatchSemaphore(value: 1)
    
    /**
     A share disk cache, name "defauleTrackCache" path "Library/Caches/"
     */
    
    static let shareInstance = DiskCache(name: TrackCacheDefauleName)!
    
    /**
     Design constructor
     The same name and path has the same disk folder Cache
     
     - parameter name: disk cache folder name
     - parameter path: disk cache folder path
     
     - returns: if no name or path will be fail
     */
    public init?(name: String, path: String) {
        if name.characters.count == 0 || path.characters.count == 0 {
            return nil
        }
        self.name = name
        self.cacheURL = URL(fileURLWithPath: path).URLByAppendingPathComponent(TrackCachePrefix + name, isDirectory: false)
        
        _lock()
        _queue.async {
            self._createCacheDir()
            self._loadFilesInfo()
            self._unlock()
        }
    }
    
    /**
     convenience constructor
     
     - parameter name: disk cache foler name
     
     - returns: if no name will be fail
     */
    public convenience init?(name: String) {
        self.init(name: name, path: NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0])
    }
}

//  MARK:
//  MARK: Public 
public extension DiskCache {
    //  MARK: Async
    /**
     Async store an object for the unique key in disk cache and store object info to linked list head
     completion will be call after object has been store in disk
     
     - parameter object:     object must be implement NSCoding protocal
     - parameter key:        unique key
     - parameter completion: stroe completion call back
     */
    public func set(object: NSCoding, forKey key: String, completion: DiskCacheAsyncCompletion?) {
        _queue.async { [weak self] in
            guard let strongSelf = self else { completion?(nil, key, object); return }
            strongSelf.set(object: object, forKey: key)
            completion?(strongSelf, key, object)
        }
    }
    
    /**
     Async search object according to unique key
     if find object, object info will move to linked list head
     */
    public func object(forKey key: String, completion: DiskCacheAsyncCompletion?) {
        _queue.async { [weak self] in
            guard let strongSelf = self else { completion?(nil, key, nil); return }
            let object = strongSelf.object(forKey: key)
            completion?(strongSelf, key, object)
        }
    }
    
    /**
     Async remove object according to unique key from disk and remove object info from linked list
     */
    public func removeObject(forKey key: String, completion: DiskCacheAsyncCompletion?) {
        _queue.async { [weak self] in
            guard let strongSelf = self else { completion?(nil, key, nil); return }
            strongSelf.removeObject(forKey: key)
            completion?(strongSelf, key, nil)
        }
    }
    
    /**
     Async remove all object and info from disk and linked list
     */
    public func removeAllObjects_ (completion: DiskCacheAsyncCompletion?) {
        _queue.async { [weak self] in
            guard let strongSelf = self else { completion?(nil, nil, nil); return }
            strongSelf.removeAllObjects()
            completion?(strongSelf, nil, nil)
        }
    }
    
    /**
     Async trim disk cache total to countLimit according LRU
     
     - parameter countLimit: maximum countLimit
     */
    public func trim(toCount countLimit: UInt, completion: DiskCacheAsyncCompletion?) {
        _queue.async { [weak self] in
            guard let strongSelf = self else { completion?(nil, nil, nil); return }
            strongSelf.trim(toCount: countLimit)
            completion?(strongSelf, nil, nil)
        }
    }
    
    /**
     Async trim disk cache totalcost to costLimit according LRU
     
     - parameter costLimit:  maximum costLimit
     */
    public func trim(toCost costLimit: UInt, completion: DiskCacheAsyncCompletion?) {
        _queue.async { [weak self] in
            guard let strongSelf = self else { completion?(nil, nil, nil); return }
            strongSelf.trim(toCost: costLimit)
            completion?(strongSelf, nil, nil)
        }
    }
    
    /**
     Async trim disk cache objects which age greater than ageLimit
     
     - parameter ageLimit:  maximum ageLimit
     */
    public func trim(toAge ageLimit: TimeInterval, completion: DiskCacheAsyncCompletion?) {
        _queue.async { [weak self] in
            guard let strongSelf = self else { completion?(nil, nil, nil); return }
            strongSelf.trim(toAge: ageLimit)
            completion?(strongSelf, nil, nil)
        }
    }
    
    //  MARK: Sync
    /**
     Sync store an object for the unique key in disk cache and store object info to linked list head
     */
    public func set(object: NSCoding, forKey key: String) {
        let fileURL = _generateFileURL(key, path: cacheURL)
        guard let filePath = fileURL.path else { return }
        _lock()
        if NSKeyedArchiver.archiveRootObject(object, toFile: filePath) == true {
            do {
                let date: Date = Date()
                try FileManager.default.setAttributes([FileAttributeKey.modificationDate : date], ofItemAtPath: filePath)
                let infosDic: [String : AnyObject] = try (fileURL as NSURL).resourceValues(forKeys: [URLResourceKey.totalFileAllocatedSizeKey]) as! [String : AnyObject]
                var fileSize: UInt = 0
                if let fileSizeNumber = infosDic[URLResourceKey.totalFileAllocatedSizeKey] as? NSNumber {
                    fileSize = fileSizeNumber.uintValue
                }
                _cache.set(object: DiskCacheObject(key: key, cost: fileSize, date: date), forKey: key)
            } catch {}
        }
        if _cache.cost > _costLimit {
            _unsafeTrim(toCost: _costLimit)
        }
        if _cache.count > _countLimit {
            _unsafeTrim(toCount: _countLimit)
        }
        _unlock()
    }
    
    /**
     Sync search object according to unique key
     if find object, object info will move to linked list head
     */
    
    public func object(forKey key: String) -> AnyObject? {
        _lock()
        let object = _unsafeObject(forKey: key)
        _unlock()
        return object
    }
    
    /**
     Sync remove object according to unique key from disk and remove object info from linked list
     */
    public func removeObject(forKey key: String) {
        guard let filePath = _generateFileURL(key, path: cacheURL).path else { return }
        _lock()
        if FileManager.default.fileExists(atPath: filePath) {
            do {
                try FileManager.default.removeItem(atPath: filePath)
                _cache.removeObject(forKey: key)
            } catch {}
        }
        _unlock()
    }
    
    /**
     Sync remove all object and info from disk and linked list
     */
    public func removeAllObjects() {
        _lock()
        if FileManager.default.fileExists(atPath: self.cacheURL.absoluteString) {
            do {
                try FileManager.default.removeItem(atPath: self.cacheURL.absoluteString)
                _cache.removeAllObjects()
            } catch {}
        }
        _unlock()
    }
    
    /**
     Async trim disk cache total to countLimit according LRU
     */
    public func trim(toCount countLimit: UInt) {
        if self.totalCount <= countLimit {
            return
        }
        if countLimit == 0 {
            removeAllObjects()
            return
        }
        _lock()
        _unsafeTrim(toCount: countLimit)
        _unlock()
    }
    
    /**
     Sync trim disk cache totalcost to costLimit according LRU
     */
    public func trim(toCost costLimit: UInt) {
        if self.totalCost <= costLimit {
            return
        }
        if costLimit == 0 {
            removeAllObjects()
            return
        }
        _lock()
        _unsafeTrim(toCost: costLimit)
        _unlock()
    }
    
    /**
     Sync trim disk cache objects which age greater than ageLimit
     */
    public func trim(toAge ageLimit: TimeInterval) {
        if ageLimit <= 0 {
            removeAllObjects()
            return
        }
        _lock()
        _unsafeTrim(toAge: ageLimit)
        _unlock()
    }
    
    public subscript(key: String) -> NSCoding? {
        get {
            if let returnValue = object(forKey: key) as? NSCoding {
                return returnValue
            }
            return nil
        }
        set {
            if let newValue = newValue {
                set(object: newValue, forKey: key)
            }
            else {
                removeObject(forKey: key)
            }
        }
    }
}

//  MARK: SequenceType
extension DiskCache : Sequence {
    /**
     MemoryCacheGenerator
     */
    public typealias Iterator = DiskCacheGenerator
    
    /**
     Returns a generator over the elements of this sequence.
     It is thread safe, if you call `generate()`, remember release it,
     otherwise maybe it lead to deadlock.
     
     - returns: A generator
     */
    
    public func makeIterator() -> DiskCacheGenerator {
        var generatror: DiskCacheGenerator
        _lock()
        generatror = DiskCacheGenerator(generate: _cache.makeIterator(), diskCache: self) {
            self._unlock()
        }
        return generatror
    }
}

//  MARK:
//  MARK: Private
private extension DiskCache {

    func _createCacheDir() -> Bool {
        if FileManager.default.fileExists(atPath: cacheURL.absoluteString) {
            return false
        }
        do {
            try FileManager.default.createDirectory(atPath: cacheURL.absoluteString, withIntermediateDirectories: true, attributes: nil)
        } catch {
            return false
        }
        return true
    }
    
    func _loadFilesInfo() -> Bool {
        var fileInfos: [DiskCacheObject] = [DiskCacheObject]()
        let fileInfoKeys: [String] = [URLResourceKey.contentModificationDateKey.rawValue, URLResourceKey.totalFileAllocatedSizeKey.rawValue]
        do {
            let filesURL: [URL] = try FileManager.default.contentsOfDirectory(at: cacheURL, includingPropertiesForKeys: fileInfoKeys, options: .skipsHiddenFiles)
            for fileURL: URL in filesURL {
                do {
                    let infosDic: [String : AnyObject] = try (fileURL as NSURL).resourceValues(forKeys: fileInfoKeys as! [URLResourceKey])
                    
                    if let key = fileURL.lastPathComponent as String?,
                        let date = infosDic[URLResourceKey.contentModificationDateKey] as? Date,
                        let fileSize = infosDic[URLResourceKey.totalFileAllocatedSizeKey] as? NSNumber {
                        fileInfos.append(DiskCacheObject(key: key, cost: fileSize.uintValue, date: date))
                    }
                }
                catch {
                    return false
                }
            }
            fileInfos.sort { $0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970 }
            fileInfos.forEach {
                _cache.set(object: $0, forKey: $0.key)
            }
        } catch {
            return false
        }
        return true
    }
    
    func _unsafeTrim(toCount countLimit: UInt) {
        if var lastObject: DiskCacheObject = _cache.lastObject() {
            while (_cache.count > countLimit) {
                if let filePath = _generateFileURL(lastObject.key, path: cacheURL).path , FileManager.default.fileExists(atPath: filePath) {
                    do {
                        try FileManager.default.removeItem(atPath: filePath)
                        _cache.removeLastObject()
                        guard let newLastObject = _cache.lastObject() else { break }
                        lastObject = newLastObject
                    } catch {}
                }
            }
        }
    }
    
    func _unsafeTrim(toCost costLimit: UInt) {
        if var lastObject: DiskCacheObject = _cache.lastObject() {
            while (_cache.cost > costLimit) {
                if let filePath = _generateFileURL(lastObject.key, path: cacheURL).path , FileManager.default.fileExists(atPath: filePath) {
                    do {
                        try FileManager.default.removeItem(atPath: filePath)
                        _cache.removeLastObject()
                        guard let newLastObject = _cache.lastObject() else { break }
                        lastObject = newLastObject
                    } catch {}
                }
            }
        }
    }
    
    func _unsafeTrim(toAge ageLimit: TimeInterval) {
        if var lastObject: DiskCacheObject = _cache.lastObject() {
            while (lastObject.date.timeIntervalSince1970 < Date().timeIntervalSince1970 - ageLimit) {
                if let filePath = _generateFileURL(lastObject.key, path: cacheURL).path , FileManager.default.fileExists(atPath: filePath) {
                    do {
                        try FileManager.default.removeItem(atPath: filePath)
                        _cache.removeLastObject()
                        guard let newLastObject = _cache.lastObject() else { break }
                        lastObject = newLastObject
                    } catch {}
                }
            }
        }
    }
    
    func _unsafeObject(forKey key: String) -> AnyObject? {
        guard let filePath = _generateFileURL(key, path: cacheURL).path else { return nil }
        var object: AnyObject? = nil
        let date: Date = Date()
        if FileManager.default.fileExists(atPath: filePath) {
            object = NSKeyedUnarchiver.unarchiveObject(withFile: filePath)
            do {
                try FileManager.default.setAttributes([FileAttributeKey.modificationDate : date], ofItemAtPath: filePath)
                if object != nil {
                    if let diskCacheObj = _cache.object(forKey: key) {
                        diskCacheObj.date = date
                    }
                }
            } catch {
                
            }
        }
        return object
    }
    
    func _generateFileURL(_ key: String, path: URL) -> URL {
        return path.URLByAppendingPathComponent(key)
    }
    
    func _lock() {
        _semaphoreLock.wait(timeout: DispatchTime.distantFuture)
    }
    
    func _unlock() {
        _semaphoreLock.signal()
    }
}
