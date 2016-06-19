//
//  RateListViewController.swift
//  SwiftCurrencyExchangeRate
//
//  Created by 周际航 on 16/6/14.
//  Copyright © 2016年 zjh. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import ObjectMapper

class RateListViewController: UIViewController {
    
    weak var rateListTableView: UITableView!
    var searchController: UISearchController!                   // 搜索框
    
    // 数据源
    var searchRateModelArray: [CurrencyCodeModel] = []          // 满足搜索结果的货币
    var rateModelArray: [CurrencyCodeModel] = []                // 所有的货币名称
    var rateDetailDic: [String : ExchangeRateReturnModel] = [:] // 详情数据
    var rateDetailHeightDic: [String : NSNumber] = [:]          // 缓存详情cell的高度
    
    // 标志
    var showSearchResult: Bool  = false                         // 显示搜索结果
    var standCurrencyCodeModel: CurrencyCodeModel?              // 参照货币
    var requestingCodeSet: Set<String> = []                     // 正在请求详情的code集合
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.standCurrencyCodeModel = CurrencyCodeModel.chineseModel()
        self.setUpViews()
        self.setUpConstraints()
        self.setUpData()
    }
    func setUpViews() {
        self.navigationItem.title = "汇率表"
        
        let rateListTableView = UITableView(frame: CGRectZero, style: .Plain)
        rateListTableView.delegate = self
        rateListTableView.dataSource = self
        rateListTableView.rowHeight = RateListSimpleViewCell().cellHeight()
        rateListTableView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(rateListTableView)
        self.rateListTableView = rateListTableView
        
        self.setUpSearchController()
        
        self.rateListTableView.registerClass(RateListSimpleViewCell.classForCoder(), forCellReuseIdentifier: RateListSimpleViewCell.cellIdentifier())
        self.rateListTableView.registerClass(RateListDetailViewCell.classForCoder(), forCellReuseIdentifier: RateListDetailViewCell.cellIdentifier())
    }
    func setUpSearchController() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "search hear"
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.sizeToFit()
        self.rateListTableView.tableHeaderView = self.searchController.searchBar
    }
    func setUpConstraints() {
        self.rateListTableView.snp_makeConstraints { [weak self] (make) in
            if let strongSelf = self {
                make.edges.equalTo(strongSelf.view)
            }
        }
    }
    func setUpData() {
        self.requestRateList()
    }
    
    //MARK: 网络
    func addDetailRequest(forSimpleCell cell:RateListSimpleViewCell, indexPath: NSIndexPath) {
        let model = cell.currencyModel!
        guard self.requestingCodeSet.contains(model.code!) == false else {
            return
        }
        
        self.requestingCodeSet.insert(model.code!)
        self.requestRateDetail(self.standCurrencyCodeModel!, toCurrency: model)
    }
    func requestRateList() {
        NetworkManager.requestRateListData { [weak self] (response) in
            switch response.result {
            case .Success(let value):
                let json = JSON(value)
                
                if let strongSelf = self {
                    if let rateListModel = Mapper<RateListModel>().map(json.object) {
                        rateListModel.removeUnExistCode()
                        strongSelf.rateModelArray = rateListModel.existCurrencyModelArr
                        strongSelf.rateListTableView.reloadData()
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    func requestRateDetail(fromCurrency: CurrencyCodeModel, toCurrency: CurrencyCodeModel) {
        
        NetworkManager.requestRateDetail(fromCurrency, toCurrency: toCurrency) { [weak self] (response) in
            switch response.result {
            case .Success(let value):
                let json = JSON(value)
                
                if let strongSelf = self {
                    let model = Mapper<ExchangeRateModel>().map(json.object)
                    strongSelf.rateDetailDic[toCurrency.code!] = model?.retData
                    strongSelf.rateListTableView.reloadData()
                }
            case .Failure(let error):
                print(error)
            }
            
            if let strongSelf = self {
                strongSelf.requestingCodeSet.remove(toCurrency.code!)
            }
        }
    }
}

// 似乎没啥用
extension RateListViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func willPresentSearchController(searchController: UISearchController){
        print(#function)
    }
    func didPresentSearchController(searchController: UISearchController){
        print(#function)
    }
    func willDismissSearchController(searchController: UISearchController){
        print(#function)
    }
    func didDismissSearchController(searchController: UISearchController){
        print(#function)
    }
    func presentSearchController(searchController: UISearchController){
        print(#function)
    }
    func updateSearchResultsForSearchController(searchController: UISearchController){
        print(#function)
    }
}
extension RateListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        print(#function)
        self.showSearchResult = true
        
        if let text = searchBar.text {
            self.showSearchResultForSearchText(text)
        }else {
            self.showSearchResultForSearchText("")
        }
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function)
        self.showSearchResultForSearchText(searchText)
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print(#function)
        if let text = searchBar.text {
            self.showSearchResultForSearchText(text)
        }
        // 结束搜索，取消第一响应者
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar){
        print(#function)
        self.showSearchResult = false
        self.rateListTableView.reloadData()
    }
    
    // 过滤搜索结果
    func showSearchResultForSearchText(text: String) {
        if text == "" {
            self.searchRateModelArray = self.rateModelArray
            self.rateListTableView.reloadData()
            return
        }
        // 根据用户输入过滤数据到 filteredArray
        self.searchRateModelArray = self.filterModelForSearchText(text)
        self.rateListTableView.reloadData()
    }
    func filterModelForSearchText(text: String) -> [CurrencyCodeModel] {
        var marr: [CurrencyCodeModel] = []
        for model in self.rateModelArray {
            let rangeName = model.name!.rangeOfString(text, options: .CaseInsensitiveSearch, range: nil, locale: nil)
            if rangeName?.startIndex != nil {
                marr.append(model)
                continue
            }
            let rangeCode = model.code!.rangeOfString(text, options: .CaseInsensitiveSearch, range: nil, locale: nil)
            if rangeCode?.startIndex != nil {
                marr.append(model)
                continue
            }
        }
        return marr
    }
}

//MARK: tableview 代理
extension RateListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.showSearchResult ? self.searchRateModelArray.count : self.rateModelArray.count
        return count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currencyModel = self.showSearchResult ? self.searchRateModelArray[indexPath.row] : self.rateModelArray[indexPath.row]
        var cell: UITableViewCell?
        if let detailModel = self.rateDetailDic[currencyModel.code!] {
            // 显示详情
            let detailCell = tableView.dequeueReusableCellWithIdentifier(RateListDetailViewCell.cellIdentifier(), forIndexPath: indexPath) as! RateListDetailViewCell
            detailModel.fromCurrencyModel = self.standCurrencyCodeModel
            detailModel.toCurrencyModel = currencyModel
            detailCell.rateModel = detailModel
            cell = detailCell
        }else{
            // 显示simple
            let simpleCell = tableView.dequeueReusableCellWithIdentifier(RateListSimpleViewCell.cellIdentifier(), forIndexPath: indexPath) as! RateListSimpleViewCell
            simpleCell.currencyModel = currencyModel
            cell = simpleCell
        }
    
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let currencyModel = self.showSearchResult ? self.searchRateModelArray[indexPath.row] : self.rateModelArray[indexPath.row]
        var height: CGFloat = 0.0
        if let detailModel = self.rateDetailDic[currencyModel.code!] {
            // 详情
            if let storedHeight = self.rateDetailHeightDic[currencyModel.code!] {
                height = CGFloat(storedHeight.floatValue)
            }else {
                let detailCell = RateListDetailViewCell()
                detailModel.fromCurrencyModel = self.standCurrencyCodeModel
                detailModel.toCurrencyModel = currencyModel
                detailCell.rateModel = detailModel
                height = detailCell.cellHeight()
                self.rateDetailHeightDic[currencyModel.code!] = NSNumber(float: Float(height))
            }
        }else {
            // simple
            height = 60
        }
        return height
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // 加入下载详情的队列
        if cell.isKindOfClass(RateListSimpleViewCell.classForCoder()) {
            let simpleCell = cell as! RateListSimpleViewCell
            self.addDetailRequest(forSimpleCell: simpleCell, indexPath: indexPath)
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if (cell!.isKindOfClass(RateListDetailViewCell.classForCoder())) {
            // 点击 详情
            
        }else {
            // 点击 simple
            let simpleCell = cell as! RateListSimpleViewCell
            self.addDetailRequest(forSimpleCell: simpleCell, indexPath: indexPath)
        }
    }
}