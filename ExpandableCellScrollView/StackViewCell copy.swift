//
//  StackViewCell.swift
//  ExpandableCellScrollView
//
//  Created by Vamshi Krishna on 27/04/17.
//  Copyright © 2017 VamshiKrishna. All rights reserved.
//

import UIKit

struct CustomData {
    var title: String
    var url: String
    var backgroundImage: UIImage
}

struct Sat {
  let sat: [String]
}

class StackViewCell: UITableViewCell {
    
    var satnica = [SatnicaModel]()
    var linije:[[String:AnyObject]] = []
    var cellExists:Bool = false
    
    @IBOutlet weak var openView: UIView!
    @IBOutlet weak var stuffView: UIView!{
        didSet{
            stuffView.isHidden = true
            stuffView.alpha = 0
            
        }
        
    }
    
    @IBOutlet weak var open: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var satButton: UIButton!
    
    @IBOutlet weak var danRadni: UIButton!
    @IBOutlet weak var danSubota: UIButton!
    @IBOutlet weak var danNedelja: UIButton!
    
    
    @IBOutlet weak var labelSat: UILabel!{
    didSet {
        labelSat.numberOfLines = 0
        }}
    @IBOutlet weak var labelMinut: UILabel! {
    didSet {
        labelMinut.numberOfLines = 0
        }}
    
    @IBOutlet weak var labelNocniPrevoz: UILabel!{
    didSet {
        labelNocniPrevoz.numberOfLines = 0
        }}
    @IBOutlet weak var labelInformacije: UILabel!{
    didSet {
        labelInformacije.numberOfLines = 0
        }}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    fileprivate let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()

    func execute(){
        
        stuffView.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.topAnchor.constraint(equalTo: stuffView.topAnchor, constant: 50).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: stuffView.leadingAnchor, constant: 10).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: stuffView.trailingAnchor, constant: -10).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        DataService.shared.getData { (data) in
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON else { return }
                let itemResponse = ItemResponse(json: json)
                guard let satnica = itemResponse?.items.first?.satnica.satnica else { return }
                print(satnica)
                self.satnica = satnica
                
//                guard let dostupnisati = itemResponse?.items.first?.satnica else { return }
//                print(satnica)
//                self.satnica = dostupnisati
                
                let results = try JSONSerialization.jsonObject(with: data as Data, options: []) as! [String:AnyObject]
                self.linije = results["gradskelinije"] as! Array<[String: Any]> as [[String : AnyObject]]
                
                
            } catch {
                print(error)
            }
        }
        
    }

    @IBAction func danVikendBtnClick(_ sender: UIButton) {
        
        switch sender.tag{
            
        case 1:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "loadGradskeRadniDan"), object: nil)
        case 2:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "loadGradskeRadniDan"), object: nil)
        case 3:
            NotificationCenter.default.post(name: Notification.Name(rawValue: "loadGradskeNedelja"), object: nil)
            
        default:
            labelMinut.text = ""
        }
    }
    
    func animate(duration:Double, c: @escaping () -> Void){
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModePaced, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration, animations: {
                self.stuffView.isHidden = !self.stuffView.isHidden
                if(self.stuffView.alpha == 1){
                    self.stuffView.alpha = 0.5
                    
                }
                else{
                    self.stuffView.alpha = 1
                }
            })
        }, completion: { (finished: Bool) in
            print("Animation Finished")
            c()
        })
    }
    
    
    
}


//extension StackViewCell {
//
//    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
//
//        collectionView.delegate = dataSourceDelegate
//        collectionView.dataSource = dataSourceDelegate
//        collectionView.tag = row
//        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
//        collectionView.reloadData()
//    }
//
//    var collectionViewOffset: CGFloat {
//        set { collectionView.contentOffset.x = newValue }
//        get { return collectionView.contentOffset.x }
//    }
//}

class CustomCell: UICollectionViewCell {
    
    var data: CustomData? {
        didSet {
            self.title.center = self.bg.center
            self.title.textAlignment = .center
            guard let data = data else { return }
            
            bg.backgroundColor = UIColor.lightGray
            self.bg.layer.borderWidth = 2
            self.bg.layer.borderColor = UIColor(red:128/255.0, green:128/255.0, blue:128/255.0, alpha: 1.0).cgColor
            
            self.title.text = data.title
            self.title.textColor = UIColor.white
            self.title.center = self.bg.center
            self.title.textAlignment = .center
            
        }
    }
    
    fileprivate let bg: UIImageView = {
       let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    fileprivate let title: UILabel = {
       let iv = UILabel()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .center
        iv.textAlignment = .center
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)

        contentView.addSubview(bg)
        contentView.addSubview(title)
        
        title.centerXAnchor.constraint(equalTo: bg.centerXAnchor).isActive = true
        title.centerYAnchor.constraint(equalTo: bg.centerYAnchor).isActive = true
        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bg.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        bg.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StackViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return linije.count
        return satnica.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        
        cell.bg.backgroundColor = UIColor.lightGray
        cell.bg.layer.borderWidth = 2
        cell.bg.layer.borderColor = UIColor(red:128/255.0, green:128/255.0, blue:128/255.0, alpha: 1.0).cgColor
        cell.title.text = satnica[indexPath.row].sat
        
        //batters[indexPath.row].id
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        
        labelMinut?.text = satnica[indexPath.row].minuti

    }
}


//@IBDesignable extension UIButton {
//
//    @IBInspectable var borderWidth: CGFloat {
//        set {
//            layer.borderWidth = newValue
//        }
//        get {
//            return layer.borderWidth
//        }
//    }
//
//    @IBInspectable var cornerRadius: CGFloat {
//        set {
//            layer.cornerRadius = newValue
//        }
//        get {
//            return layer.cornerRadius
//        }
//    }
//
//    @IBInspectable var borderColor: UIColor? {
//        set {
//            guard let uiColor = newValue else { return }
//            layer.borderColor = uiColor.cgColor
//        }
//        get {
//            guard let color = layer.borderColor else { return nil }
//            return UIColor(cgColor: color)
//        }
//    }
//}
