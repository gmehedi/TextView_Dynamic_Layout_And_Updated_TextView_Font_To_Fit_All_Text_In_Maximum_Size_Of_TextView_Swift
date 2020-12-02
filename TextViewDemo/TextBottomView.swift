//
//  TextBottomView.swift
//  TextViewDemo
//
//  Created by MacBook Pro on 11/23/20.
//

import UIKit

protocol TextBottomViewDelegate: NSObject {
    func tappedOnHideView()
    func panChangesOnHideView(changes: CGFloat)
    func panEndOnHideView(changes: CGFloat)
}

class TextBottomView: UIView {
    
    @IBOutlet weak var leftCollectioViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewContainer: UIView!
    @IBOutlet weak var rightCollectionView: UICollectionView!
    @IBOutlet weak var leftCollectionView: UICollectionView!
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var hideBarView: UIView!
    weak var delegate: TextBottomViewDelegate?
    public var tapGesture: UITapGestureRecognizer!
    public var panGesture: UIPanGestureRecognizer!
    fileprivate var currentColor: UIColor!
    
    fileprivate var colorArray = Array<UIColor>()
    fileprivate let leftArray = ["align_center_light", "align_left_light", "align_right_light"]
    fileprivate let fontNameArray = ["L sdfsdfsdf", "Rfsdfsdfsdfsdf","mnxbvmxncbvmxcnvb", "sjdfyurtjegjafb", "rqwerwedfwgdfsab", "L sdfsdfsdf", "Rfsdfsdfsdfsdf","mnxbvmxncbvmxcnvb", "sjdfyurtjegjafb", "rqwerwedfwgdfsab"]
    fileprivate let screenWidth = UIScreen.main.bounds.width - 80
    fileprivate var fontStack = [UIFont]()
    fileprivate var previousPos: Int!
    fileprivate var textStyleIndex = 0
    fileprivate var alaignmentIndex = 0
    fileprivate let textStyleNameArray = ["transparent_dark", "bg_dark", "opacity_dark"]
    fileprivate let alaignmentArray = ["align_center_dark", "align_left_dark", "align_right_dark"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        comonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        comonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        print("Deinit")
    }
    
    fileprivate func comonInit(){
        //MARK: Set Main Content View
        Bundle.main.loadNibNamed("TextBottomView", owner: self, options: nil)
        self.contentView.frame = self.bounds
        let numarator: CGFloat = 43
        self.topCollectionView.backgroundColor = UIColor(red: numarator/255.0, green: numarator/255.0, blue: numarator/255.0, alpha: 1)
        self.leftCollectionView.backgroundColor = UIColor(red: numarator/255.0, green: numarator/255.0, blue: numarator/255.0, alpha: 1)
        self.rightCollectionView.backgroundColor = UIColor(red: numarator/255.0, green: numarator/255.0, blue: numarator/255.0, alpha: 1)
        self.collectionViewContainer.backgroundColor = UIColor(red: numarator/255.0, green: numarator/255.0, blue: numarator/255.0, alpha: 1)
        self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        addSubview(contentView)
        self.textView.delegate = self
        self.textView.isScrollEnabled = false
        self.textView.layer.cornerRadius = 5
        self.colorArray = UIColor().getAllMetarialColor()
        self.colorArray.insert(UIColor.white, at: 0)
        self.currentColor = self.colorArray[0]
        self.addGestureToHideView()
        //MARK: CollectionViews Set
        registerCollectionViewCell()
        setCollectionViewDelegate()
        setCollectionViewFlowLayout()
        self.textView.becomeFirstResponder()
        print("cmn")
    }
    
}


extension TextBottomView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: Registration nib file and Set Delegate, Datasource
    fileprivate func registerCollectionViewCell(){
        let topNib = UINib(nibName: "TopCollectionViewCell", bundle: nil)
        self.topCollectionView.register(topNib, forCellWithReuseIdentifier: "TopCollectionViewCell")
        
        let leftNib = UINib(nibName: "LeftCollectionViewCell", bundle: nil)
        self.leftCollectionView.register(leftNib, forCellWithReuseIdentifier: "LeftCollectionViewCell")
        
        let rightNib = UINib(nibName: "RightCollectionViewCell", bundle: nil)
        self.rightCollectionView.register(rightNib, forCellWithReuseIdentifier: "RightCollectionViewCell")
    }
    
    //MARK: Set Collection View Flow Layout
    fileprivate func setCollectionViewFlowLayout(){
        
        if let layoutTop = topCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layoutTop.scrollDirection = .horizontal
            layoutTop.minimumLineSpacing = 16
            layoutTop.minimumInteritemSpacing = 16
        }
        topCollectionView.contentInset = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        
        if let layoutLeft = rightCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layoutLeft.scrollDirection = .horizontal
            layoutLeft.minimumLineSpacing = 16
            layoutLeft.minimumInteritemSpacing = 16
        }
        rightCollectionView.contentInset = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        
        if let layoutRight = leftCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layoutRight.scrollDirection = .horizontal
            layoutRight.minimumLineSpacing = 16
            layoutRight.minimumInteritemSpacing = 16
        }
        leftCollectionView.contentInset = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        
    }
    
    //MARK: Set Collection View Delegate
    fileprivate func setCollectionViewDelegate(){
        self.topCollectionView.delegate = self
        self.leftCollectionView.delegate = self
        self.rightCollectionView.delegate = self
        self.topCollectionView.dataSource = self
        self.leftCollectionView.dataSource = self
        self.rightCollectionView.dataSource = self
        print("Delegate")
    }
    
    //MARK: Collection View Delegate And DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("HHere ", collectionView)
        switch collectionView {
        case self.topCollectionView:
            print("Here1  ", fontNameArray.count)
            return fontNameArray.count
        case self.leftCollectionView:
            print("Here2  ", leftArray.count)
            return leftArray.count
        case self.rightCollectionView:
            print("Here3  ", colorArray.count)
            return colorArray.count
        default:
            print("Not Match")
            return 0
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //print("cellll")
        let numarator: CGFloat = 43
        switch collectionView {
        case self.topCollectionView:
            let cell = self.topCollectionView.dequeueReusableCell(withReuseIdentifier: "TopCollectionViewCell", for: indexPath) as! TopCollectionViewCell
            cell.titleLabel.text = self.fontNameArray[indexPath.item]
            cell.titleLabel.layer.cornerRadius = (cell.titleLabel.bounds.height * 0.5)
            return cell
        case self.leftCollectionView:
            let cell = self.leftCollectionView.dequeueReusableCell(withReuseIdentifier: "LeftCollectionViewCell", for: indexPath) as! LeftCollectionViewCell
            cell.iconImageView.backgroundColor = UIColor(red: numarator/255.0, green: numarator/255.0, blue: numarator/255.0, alpha: 1)
            switch indexPath.item {
            case 0:
                cell.iconImageView.image = UIImage(named: self.textStyleNameArray[self.textStyleIndex])
                textView.textAlignment = .center
            case 1:
                cell.iconImageView.image = UIImage(named: "shadow_dark")
            case 2:
                cell.iconImageView.image = UIImage(named: self.alaignmentArray[self.alaignmentIndex])
            default:
                print("Not Match")
            }
            return cell
        case self.rightCollectionView:
            let cell = self.rightCollectionView.dequeueReusableCell(withReuseIdentifier: "RightCollectionViewCell", for: indexPath) as! RightCollectionViewCell
            if indexPath.item == 0 {
                cell.colorView.backgroundColor = UIColor(red: numarator/255.0, green: numarator/255.0, blue: numarator/255.0, alpha: 1)
                cell.imageView.isHidden = false
            }else{
                cell.imageView.isHidden = true
                cell.colorView.backgroundColor = self.colorArray[indexPath.item]
                cell.colorView.layer.cornerRadius = cell.frame.height * 0.5
                cell.colorView.clipsToBounds = true
            }
            return cell
        default:
            print("Not Match")
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Select")
        switch collectionView {
        case self.topCollectionView:
            let cell = self.topCollectionView.dequeueReusableCell(withReuseIdentifier: "TopCollectionViewCell", for: indexPath) as! TopCollectionViewCell
            cell.titleLabel.text = self.fontNameArray[indexPath.item]
            cell.titleLabel.layer.cornerRadius = (cell.titleLabel.bounds.height * 0.5)
            self.topCollectionView.reloadItems(at: [indexPath])
        case self.leftCollectionView:
          //  print("INNd  ", indexPath.item)
            let cell = self.leftCollectionView.dequeueReusableCell(withReuseIdentifier: "LeftCollectionViewCell", for: indexPath) as! LeftCollectionViewCell
            switch indexPath.item {
            case 0:
               // print("Here   ", self.textStyleNameArray[self.textStyleIndex])
                textStyleIndex += 1
                textStyleIndex %= 3
                
                cell.iconImageView.image = UIImage(named: self.textStyleNameArray[self.textStyleIndex])!
                print("III  ", self.textStyleIndex)
                switch self.textStyleIndex {
                case 0:
                    self.textView.backgroundColor = UIColor.clear
                case 1:
                    self.textView.backgroundColor = self.currentColor
                case 2:
                    self.textView.backgroundColor = self.currentColor.withAlphaComponent(0.5)
                default:
                    print("Not Match")
                }
                
            case 1:
                cell.iconImageView.image = UIImage(named: "shadow_dark")
            case 2:
                alaignmentIndex += 1
                alaignmentIndex %= 3
                
                cell.iconImageView.image = UIImage(named: self.alaignmentArray[self.alaignmentIndex])
                switch self.alaignmentIndex {
                case 0:
                    textView.textAlignment = .center
                case 1:
                    textView.textAlignment = .left
                case 2:
                    textView.textAlignment = .right
                default:
                    print("Not Match")
                }
                
            default:
                print("Not Match")
            }
            self.leftCollectionView.reloadItems(at: [indexPath])
        case self.rightCollectionView:
            let cell = self.rightCollectionView.dequeueReusableCell(withReuseIdentifier: "RightCollectionViewCell", for: indexPath) as! RightCollectionViewCell
            cell.colorView.backgroundColor = self.colorArray[indexPath.item]
            cell.colorView.layer.cornerRadius = cell.frame.height * 0.5
            self.rightCollectionView.reloadItems(at: [indexPath])
            self.currentColor = self.colorArray[indexPath.item]
            
            switch self.textStyleIndex {
            case 0:
                self.textView.backgroundColor = UIColor.clear
            case 1:
                self.textView.backgroundColor = self.currentColor
            case 2:
                self.textView.backgroundColor = self.currentColor.withAlphaComponent(0.5)
            default:
                print("Not Match")
            }
        default:
            print("Not Match")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width = collectionView.bounds.height - 8
        var height = width
        
        switch collectionView {
        case self.topCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopCollectionViewCell", for: indexPath ) as! TopCollectionViewCell
            width = fontNameArray[indexPath.item].widthOfString(usingFont: cell.titleLabel.font) + 10
            // print("W  ", width,"  ", cell.titleLabel.text,"  ", cell.titleLabel.font)
            height = collectionView.bounds.height - 8
        case self.leftCollectionView:
            width = collectionView.bounds.height - 8
            height = width
        case self.rightCollectionView:
            width = collectionView.bounds.height - 8
            height = width
        default:
            width = collectionView.bounds.height - 8
            height = width
        }
        return CGSize(width: width, height: height)
    }
    
}


//MARK: TextView Delegate
extension TextBottomView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // self.updateTextFont(textView: textView)
        print("UP")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var maxFontSize: CGFloat!
        var textViewMaxHeight: CGFloat!
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            maxFontSize = 32.0
            textViewMaxHeight = 200.0
        }else{
            maxFontSize = 50.0
            textViewMaxHeight = 600.0
        }
        if let char = text.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            //print("Hello")
            if (isBackSpace == -92) {
                print("Backspace was pressed ",textView.bounds.height )
                if textView.font!.pointSize <  textViewMaxHeight{
                    textView.frame.size.height = textViewMaxHeight
                    textView.increaseFontSize()
                    resizeFont(textView)
                }
                
            }else{
                if textView.frame.size.height >= textViewMaxHeight {
                    resizeFont(textView)
                }else if textView.frame.size.height < (textViewMaxHeight * 0.5) {
                    while textView.font!.pointSize < maxFontSize {
                        textView.increaseFontSize()
                    }
                }
            }
        }
        
        return true
    }
    
    func resizeFont(_ textView: UITextView) {
        if (textView.text.isEmpty || textView.bounds.size.equalTo(CGSize.zero)) {
            return;
        }
        print("H1  ", textView.frame.height)
        let textViewSize = textView.frame.size
        let fixedWidth = textViewSize.width
        //print("SSS  ",textViewSize )
        let expectSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))
        var expectFont = textView.font
        if (expectSize.height > textViewSize.height) {
            while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = textView.font!.withSize(textView.font!.pointSize - 1)
                textView.font = expectFont
            }
        }
        else if textView.frame.height < textViewSize.height{
            while (textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT))).height < textViewSize.height) {
                expectFont = textView.font
                textView.font = textView.font!.withSize(textView.font!.pointSize + 1)
            }
          //  print("NNN")
        }
        print("H2  ", textView.frame.height)
    }
}

extension TextBottomView{
    fileprivate func addGestureToHideView(){
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapped(_: )))
        tapGesture.numberOfTapsRequired = 1
        self.hideView.addGestureRecognizer(tapGesture)
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_: )))
        self.hideView.addGestureRecognizer(tapGesture)
        self.hideView.addGestureRecognizer(panGesture)
    }
    
    @objc func handleTapped(_ sender: UITapGestureRecognizer){
        self.delegate?.tappedOnHideView()
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer){
        
        switch sender.state {
        case .began:
            print("Begin")
        case .changed:
            let changes = sender.translation(in: self.hideView.superview).y
            self.delegate?.panChangesOnHideView(changes: changes)
        case .ended:
            let changes = sender.translation(in: self.hideView.superview).y
            self.delegate?.panEndOnHideView(changes: changes)
        default:
            print("Not Match")
        }
    }
}

