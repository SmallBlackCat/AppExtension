//
//  AssetGridViewController.swift
//  ZiWoYou
//
//  Created by ZJaDe on 16/12/24.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

import UIKit
import Photos
open class AssetGridViewController: AdapterCollectionViewController, PHPhotoLibraryChangeObserver {
    var fetchResult: PHFetchResult<PHAsset>!
    let imageManager = PHImageManager()

    public private(set) lazy var selectionPlugin: CollectionSelectionPlugin = CollectionSelectionPlugin(adapter)
    public var selectedItemArray: [CollectionSelectionPlugin.SelectItemType] {
        selectionPlugin.selectedItemArray
    }
    public var maxImageCount: MaxSelectedCount {
        get { selectionPlugin.maxSelectedCount }
        set { selectionPlugin.maxSelectedCount = newValue }
    }
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.configCollectionViewLayout()

        PHPhotoLibrary.shared().register(self)
        setNeedRequest()
    }
    open func configCollectionViewLayout() {
        guard let flowLayout = self.rootView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.itemSize = self.itemSize()
        flowLayout.scrollDirection = .vertical
        let edge = Space.VCEdge
        let itemSpace = Space.itemSpace
        flowLayout.sectionInset = UIEdgeInsets(top: edge, left: edge, bottom: edge, right: edge)
        flowLayout.minimumLineSpacing = itemSpace
        flowLayout.minimumInteritemSpacing = itemSpace
    }
    // MARK: -
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    open override func request(isRefresh: Bool) {
        loadPhotos()
    }
    // ZJaDe: PHPhotoLibraryChangeObserver
    @objc public func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let changes = changeInstance.changeDetails(for: fetchResult)
            else { return }
        DispatchQueue.main.sync {
            fetchResult = changes.fetchResultAfterChanges
            self.updateImages(fetchResult)
        }
    }
    // TODO: 如果已经选择图 ，相册列表又刷新了， 需要保证之前的图还是选中状态
    open func updateImages(_ fetchResult: PHFetchResult<PHAsset>) {
        let targetSize = self.itemSize()
        var array = [AssetGridModel]()
        fetchResult.enumerateObjects { (asset, _, _) in
            guard asset.sourceType == .typeUserLibrary else {
                return
            }
            let model = AssetGridModel()
            model.cellSize = targetSize
            model.asset = asset
            model.asset.requestImage(targetSize) { (image) in
                model.image.onNext(image)
            }
            array.append(model)
        }
        self.adapter.reloadData(array, isRefresh: true)
    }
    open func requestSelectedImages(_ closure: @escaping ([UIImage]) -> Void) {
        let assets: [PHAsset] = self.selectedItemArray.compactMap({($0 as? AssetGridModel)?.asset})
        guard assets.isNotEmpty else {
            closure([])
            return
        }
        requestAllImage(assets: assets) { (dataArr) in
            if dataArr.isEmpty {
                HUD.showError("图片选择失败")
            } else if dataArr.count < assets.count {
                HUD.showError("部分图片选择失败")
            }
            closure(dataArr)
        }
    }
    open func itemSize() -> CGSize {
        let edge = Space.VCEdge
        let itemSpace = Space.itemSpace
        let columnCount = 4
        let width = (jd.screenWidth - (columnCount - 1).toCGFloat * itemSpace - edge * 2) / columnCount.toCGFloat - 1
        return CGSize(width: width, height: width)
    }
}

extension AssetGridViewController {
    func loadPhotos() {
        if fetchResult == nil {
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
            self.updateImages(fetchResult)
        }
    }
}
extension AssetGridViewController {
    public func requestAllImage(assets: [PHAsset], callback: @escaping ([UIImage]) -> Void) {
        var dataArr: [UIImage] = []
        let group: DispatchGroup = DispatchGroup()
        for asset in assets {
            group.enter()
            asset.requestImage { (image) in
                if let image = image {
                    dataArr.append(image)
                }
                group.leave()
            }
            group.notify(queue: DispatchQueue.main) {
                callback(dataArr)
            }
        }
    }
//    private func requestAllImageData(assets: [PHAsset], dataArr: [Data], callback: @escaping ([Data])->()) {
//        var assets: [PHAsset] = assets
//        var dataArr: [Data] = dataArr
//        if let last = assets.popLast() {
//            requestImageData(asset: last) { (data) in
//                if let data = data {
//                    dataArr.insert(data, at: 0)
//                }
//                if assets.isNotEmpty {
//                    self.requestAllImageData(assets: assets, dataArr: dataArr, callback: callback)
//                } else {
//                    callback(dataArr)
//                }
//            }
//        }
//    }
}
