//
//  ViewController.swift
//  ExpandableCellScrollView
//
//  Created by Marko Nedeljkovic on 27/04/20.
//  Copyright © 2020 MarkoNedeljkovic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView:UITableView!
    var linije:[[String:AnyObject]] = []
    var t_count:Int = -1
    var lastCell: StackViewCell = StackViewCell()
    var button_tag:Int = -1
    let cellSpacingHeight: CGFloat = 5
    //@IBOutlet weak var scrollViewHolder: UIView!
    
    @IBOutlet weak var scrollViewHolder: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //!!!!!!!DEO KODA ZA POZIVANJE JSON-a SA SERVERA!!!!!!//
        
//        let url = URL(string: "http://developya.com/gradskelinije.json")
//
//        let task = URLSession.shared.dataTask(with: url! as URL) {
//            data, response, error in
//            if error == nil
//            {
//                do {
//
//        let results = try JSONSerialization.jsonObject(with: data as Data, options: []) as! [String:AnyObject]
//
//        self.linije = results["gradskelinije"] as! Array<[String: Any]> as [[String : AnyObject]]
//
//        DispatchQueue.main.async(execute: {
//        self.tableView.reloadData()
//        })
//        print(results)
//    } catch let error {
//        print("\(error)")
//    }
//            }
//        }
//        task.resume()
        
        
        
        loadJSON()
//        scrollViewHolder.backgroundColor = UIColor.white
//        tableView = UITableView(frame: view.frame)
//        tableView.layer.frame.size.height = scrollViewHolder.frame.height
//        tableView.backgroundColor = UIColor.white
//        //tableView.layer.frame.size.height = self.view.frame.height
//        tableView.layer.frame.size.width = scrollViewHolder.frame.width
//        tableView.frame.origin.y += 0
//        tableView.register(UINib(nibName: "StackViewCell", bundle: nil), forCellReuseIdentifier: "StackViewCell")
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.allowsSelection = false
//        tableView.separatorStyle = .singleLine
//        scrollViewHolder.addSubview(tableView)
        
        scrollViewHolder.register(UINib(nibName: "StackViewCell", bundle:nil), forCellReuseIdentifier: "StackViewCell")

        scrollViewHolder.delegate = self
        scrollViewHolder.dataSource = self
        
    }

    @objc func loadJSON() {
        
        if let path = Bundle.main.path(forResource: "gradskelinije", ofType: "json") {
            if let data = NSData(contentsOfFile: path) as Data? {
               
                do {
                    let results = try JSONSerialization.jsonObject(with: data as Data, options: []) as! [String:AnyObject]
                    self.linije = results["gradskelinije"] as! Array<[String: Any]> as [[String : AnyObject]]
                    DispatchQueue.main.async(execute: {
                        //tableView.reloadData()
                    })
                    print(results)
                } catch let error {
                    print("\(error)")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == button_tag {
            return 280
        } else {
            return 50
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return cellSpacingHeight
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.black
//        return headerView
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return linije.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StackViewCell", for: indexPath) as! StackViewCell
        let dataSource = linije[indexPath.row]

        cell.indexLinijaRadni = indexPath.row
        cell.indexLinijaSubota = indexPath.row
        cell.indexLinijaNedelja = indexPath.row
        cell.execute()
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.labelMinut.text = "Odaberite dan i sat polaska!"
        cell.labelNocniPrevoz.text = (dataSource["nocniradni"] as! String)
        cell.labelInformacije.text = (dataSource["dodatneinformacije"] as! String)
        cell.open.setTitle(linije[indexPath.row]["linija"] as? String, for: .normal)
        cell.open.tag = indexPath.row
        cell.open.addTarget(self, action: #selector(cellOpened(sender:)), for: .touchUpInside)
        t_count += 1
        cell.cellExists = true
        cell.contentView.layoutMargins.left = 20
        
        UIView.animate(withDuration: 0) {
            cell.contentView.layoutIfNeeded()
        }
        return cell
    }

    @objc func cellOpened(sender:UIButton) {
        self.scrollViewHolder.beginUpdates()
        let previousCellTag = button_tag
        
        if lastCell.cellExists {
            self.lastCell.animate(duration: 0.2, c: {
                self.view.layoutIfNeeded()
            })
            if sender.tag == button_tag {
                button_tag = -1
                lastCell = StackViewCell()
            }
        }
        
        if sender.tag != previousCellTag {
            button_tag = sender.tag
            lastCell = scrollViewHolder.cellForRow(at: IndexPath(row: button_tag, section: 0)) as! StackViewCell
            self.lastCell.animate(duration: 0.2, c: {
                self.view.layoutIfNeeded()
            })
        }
        self.scrollViewHolder.endUpdates()
    }
    
}

