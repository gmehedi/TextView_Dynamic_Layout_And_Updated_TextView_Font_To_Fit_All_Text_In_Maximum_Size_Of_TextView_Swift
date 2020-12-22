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
    func goToColorPicker()
    func updateFontSize(size: CGFloat)
}

class TextBottomView: UIView {
    
    @IBOutlet weak var collectionViewContainer: UIView!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    @IBOutlet weak var fontCollectionView: UICollectionView!
    @IBOutlet weak var alignmentCollectionView: UICollectionView!
    @IBOutlet weak var alignmentCollectionViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var shadowSlider: UISlider!
    @IBOutlet weak var backgroundCollectionView: UICollectionView!
    
    @IBOutlet weak var textColorCollectionView: UICollectionView!
    @IBOutlet weak var bGColorCollectionView: UICollectionView!
    @IBOutlet weak var backgroundCollectionViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var collectionViewsBottomConstraint: [NSLayoutConstraint]!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var textViewContainerView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var textView: TextView!
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var hideBarView: UIView!
    
    @IBOutlet weak var menuContainerWidthConstraint: NSLayoutConstraint!
    weak var delegate: TextBottomViewDelegate?
    public var tapGesture: UITapGestureRecognizer!
    public var panGesture: UIPanGestureRecognizer!
    fileprivate var currentColor: UIColor!
    fileprivate var firstSelect = true
    fileprivate var colorArray = Array<UIColor>()
    fileprivate var fontArray = Array<FontModel>()
    fileprivate var isSelectedMenu = [Bool]()
    fileprivate var isSelectedFont = [Bool]()
    fileprivate var isSelectedAlignment = [Bool]()
    fileprivate var isSelectedBackground = [Bool]()
    fileprivate var isSelectedTextColor = [Bool]()
    fileprivate var isSelectedBGColor = [Bool]()
    public var maxFontSize: CGFloat!
    fileprivate var textViewMaxHeight: CGFloat!
    fileprivate var textViewPrevSize: CGSize!
    var fontSize: CGFloat = 16
    var constant: CGFloat = 20
    //fileprivate let alaignmentNameArray = ["align_center_light", "align_left_light", "align_right_light"]
    public let menuArray = ["Font", "Alignment", "Shadow", "Background", "Text Color", "BG Color"]
    fileprivate let screenWidth = UIScreen.main.bounds.width - 80
    fileprivate let backgroundArray = ["transparent_dark", "bg_dark", "opacity_dark"]
    fileprivate let alignmentArray = ["align_center_dark", "align_left_dark", "align_right_dark"]
    
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
    
    //MARK: Shadow Slider
    @IBAction func tappedOnShadowSlider(_ sender: UISlider) {
        //print("Hi")
        self.textView.layer.masksToBounds = false
        self.textView.layer.shadowOpacity = 1
        self.textView.layer.shadowRadius = CGFloat(sender.value * 12)
        self.textView.layer.shadowColor = UIColor.black.cgColor
        self.textView.layer.shadowOffset = .zero
    }
    
    //MARK: Common Initialization
    fileprivate func comonInit(){
        
        //MARK: Set Main Content View
        Bundle.main.loadNibNamed("TextBottomView", owner: self, options: nil)
        self.contentView.frame = self.bounds
      //  self.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        addSubview(contentView)
        //Sort Bottom Constraints
        self.collectionViewsBottomConstraint.sort{
            $0.identifier! < $1.identifier!
        }
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.maxFontSize = 32
        }else{
            self.maxFontSize = 50
        }
        self.setBackgroundColor()
        self.textView.delegate = self
        self.textView.isScrollEnabled = false
        self.textView.layer.cornerRadius = 5
        self.colorArray = UIColor().getAllMetarialColor()
        self.fontArray = FontLoader.shared.loadFont()
        var tempArray = Array<FontModel>()
        for name in self.fontArray {
           // print("Name ", name.fontName)
            let font = UIFont(name: name.fontName, size: 16.0)
            if font != nil {
                tempArray.append(name)
            }
        }
      //  self.textView.font = UIFont(name: self.fontArray[0].fontName, size: self.maxFontSize)
       // self.resizeFont(textView)
        self.fontArray = tempArray
        self.initIsSelected()
        
        self.addGestureToHideView()
        
        //MARK: CollectionViews Set
        registerCollectionViewCell()
        setCollectionViewDelegate()
        setCollectionViewFlowLayout()
        self.textView.textColor = self.colorArray[0]
        self.currentColor = self.colorArray[self.colorArray.count - 1]
        self.textView.backgroundColor = self.currentColor
        self.textView.becomeFirstResponder()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            textViewMaxHeight = 200.0
        }else{
            textViewMaxHeight = 600.0
        }
    }
}

extension TextBottomView {
    
    fileprivate func setBackgroundColor(){
        let numarator: CGFloat = 43
        self.visualEffectView.backgroundColor =  UIColor(red: numarator/255.0, green: numarator/255.0, blue: numarator/255.0, alpha: 0.7)
        self.collectionViewContainer.backgroundColor = UIColor.clear
        self.menuCollectionView.backgroundColor = UIColor.clear
        self.fontCollectionView.backgroundColor = UIColor.clear
        self.alignmentCollectionView.backgroundColor = UIColor.clear
        self.backgroundCollectionView.backgroundColor = UIColor.clear
        self.textColorCollectionView.backgroundColor = UIColor.clear
        self.bGColorCollectionView.backgroundColor = UIColor.clear
    }
    
    fileprivate func initIsSelected(){
        for _ in self.menuArray{
            self.isSelectedMenu.append(false)
        }
        self.isSelectedMenu[0] = true
        
        for _ in self.fontArray{
            self.isSelectedFont.append(false)
        }
        self.isSelectedFont[0] = true
        
        for _ in self.alignmentArray{
            self.isSelectedAlignment.append(false)
        }
        self.isSelectedAlignment[0] = true
        
        for _ in self.backgroundArray{
            self.isSelectedBackground.append(false)
        }
        self.isSelectedBackground[0] = true
        
        
        for _ in self.colorArray{
            self.isSelectedBGColor.append(false)
            self.isSelectedTextColor.append(false)
        }
        self.isSelectedBGColor.append(false)
        self.isSelectedTextColor.append(false)
        self.isSelectedTextColor[1] = true
        self.isSelectedBGColor[1] = true
    }
}

extension TextBottomView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: Registration nib file and Set Delegate, Datasource
    fileprivate func registerCollectionViewCell(){
        let menuNib = UINib(nibName: "MenuCollectionViewCell", bundle: nil)
        self.menuCollectionView.register(menuNib, forCellWithReuseIdentifier: "MenuCollectionViewCell")
        self.fontCollectionView.register(menuNib, forCellWithReuseIdentifier: "MenuCollectionViewCell")
        
        let optionNib = UINib(nibName: "OptionsCollectionViewCell", bundle: nil)
        self.alignmentCollectionView.register(optionNib, forCellWithReuseIdentifier: "OptionsCollectionViewCell")
        self.backgroundCollectionView.register(optionNib, forCellWithReuseIdentifier: "OptionsCollectionViewCell")
        
        let colorNib = UINib(nibName: "ColorCollectionViewCell", bundle: nil)
        self.textColorCollectionView.register(colorNib, forCellWithReuseIdentifier: "ColorCollectionViewCell")
        self.bGColorCollectionView.register(colorNib, forCellWithReuseIdentifier: "ColorCollectionViewCell")
    }
    
    //MARK: Set Collection View Flow Layout
    fileprivate func setCollectionViewFlowLayout(){
        
        if let layoutMenu = self.menuCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layoutMenu.scrollDirection = .horizontal
            layoutMenu.minimumLineSpacing = 16
            layoutMenu.minimumInteritemSpacing = 16
        }
        self.menuCollectionView.contentInset = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        
        if let layoutFont = self.fontCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layoutFont.scrollDirection = .horizontal
            layoutFont.minimumLineSpacing = 16
            layoutFont.minimumInteritemSpacing = 16
        }
        self.fontCollectionView.contentInset = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        
        if let layoutAlnmnt = self.alignmentCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layoutAlnmnt.scrollDirection = .horizontal
            layoutAlnmnt.minimumLineSpacing = 16
            layoutAlnmnt.minimumInteritemSpacing = 16
        }
        self.alignmentCollectionView.contentInset = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        
        if let layoutBG = self.backgroundCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layoutBG.scrollDirection = .horizontal
            layoutBG.minimumLineSpacing = 16
            layoutBG.minimumInteritemSpacing = 16
        }
        self.backgroundCollectionView.contentInset = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        
        if let layoutText = self.textColorCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layoutText.scrollDirection = .horizontal
            layoutText.minimumLineSpacing = 16
            layoutText.minimumInteritemSpacing = 16
        }
        self.textColorCollectionView.contentInset = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        
        if let layoutBGColor = self.bGColorCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layoutBGColor.scrollDirection = .horizontal
            layoutBGColor.minimumLineSpacing = 16
            layoutBGColor.minimumInteritemSpacing = 16
        }
        self.bGColorCollectionView.contentInset = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        
    }
    
    //MARK: Set Collection View Delegate
    fileprivate func setCollectionViewDelegate(){
        self.menuCollectionView.delegate = self
        self.menuCollectionView.dataSource = self
        self.fontCollectionView.delegate = self
        self.fontCollectionView.dataSource = self
        self.alignmentCollectionView.delegate = self
        self.alignmentCollectionView.dataSource = self
        self.backgroundCollectionView.delegate = self
        self.backgroundCollectionView.dataSource = self
        self.textColorCollectionView.delegate = self
        self.textColorCollectionView.dataSource = self
        self.bGColorCollectionView.delegate = self
        self.bGColorCollectionView.dataSource = self
       // print("Delegate")
    }
    
    //MARK: Collection View Delegate And DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.menuCollectionView:
            return menuArray.count
        case self.fontCollectionView:
            return self.fontArray.count
        case self.alignmentCollectionView:
            return self.alignmentArray.count
        case self.backgroundCollectionView:
            return self.backgroundArray.count
        case self.textColorCollectionView:
            return self.colorArray.count
        case self.bGColorCollectionView:
            return self.colorArray.count
        default:
            print("Not Match")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.menuCollectionView:
            let cell = self.menuCollectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell
            cell.titleLabel.text = self.menuArray[indexPath.item]
            cell.backgroundColor = UIColor.black
            cell.layer.cornerRadius = (cell.bounds.height * 0.5)
            //Selection Set
            let index = Int(self.collectionViewsBottomConstraint[indexPath.item].identifier!)
            
            if self.isSelectedMenu[indexPath.item] {
                cell.titleLabel.layer.opacity = 0.5
                self.layoutIfNeeded()
                UIView.animate(withDuration: 0.5, animations: {
                    self.collectionViewsBottomConstraint[index!].constant = 0
                    self.layoutIfNeeded()
                })
            }else{
                cell.titleLabel.layer.opacity = 1.0
                self.layoutIfNeeded()
            }
            return cell
        case self.fontCollectionView:
            let cell = self.fontCollectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell
            
            cell.titleLabel.text = "ABC"
            cell.titleLabel.font = UIFont(name: self.fontArray[indexPath.item].fontName, size: cell.titleLabel.font.pointSize)
            if self.isSelectedFont[indexPath.item] {
                cell.titleLabel.layer.opacity  = 0.5
                self.textView.font = UIFont(name: self.fontArray[indexPath.item].fontName, size: self.textView.font!.pointSize)
                DispatchQueue.main.async { [self] in
                    while textView.font!.pointSize < self.maxFontSize && textView.frame.size.height < textViewMaxHeight{
                        self.textView.increaseFontSize(fontSize: maxFontSize)
                    }
                    self.resizeFont(textView)
                    //print("FFF  ", self.textView.font!.pointSize)
                }
            }else{
                cell.titleLabel.layer.opacity  = 1.0
            }
            return cell
        
        case self.alignmentCollectionView:
            let cell = self.alignmentCollectionView.dequeueReusableCell(withReuseIdentifier: "OptionsCollectionViewCell", for: indexPath) as! OptionsCollectionViewCell
            cell.iconImageView.image = UIImage(named: self.alignmentArray[indexPath.item])
            if self.isSelectedAlignment[indexPath.item] {
                cell.iconImageView.layer.opacity = 0.5
            }else{
                cell.iconImageView.layer.opacity = 1.0
            }
            return cell
            
        case self.backgroundCollectionView:
            let cell = self.backgroundCollectionView.dequeueReusableCell(withReuseIdentifier: "OptionsCollectionViewCell", for: indexPath) as! OptionsCollectionViewCell
            cell.iconImageView.image = UIImage(named: self.backgroundArray[indexPath.item])
            
            if self.isSelectedBackground[indexPath.item] {
                cell.iconImageView.layer.opacity  = 0.5
            }else{
                cell.iconImageView.layer.opacity  = 1.0
            }
            return cell
            
        case self.textColorCollectionView:
            
            let cell = self.textColorCollectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
            if self.isSelectedTextColor[indexPath.item] {
                //cell.colorView.layer.opacity = 0.5
                cell.selectionImageView.isHidden = false
            }else{
                //cell.colorView.layer.opacity = 1.0
                cell.selectionImageView.isHidden = true
            }
            if indexPath.item == 0 {
                cell.backgroundColor = UIColor.clear
                cell.colorView.backgroundColor = UIColor.clear
                cell.cellContainerView.backgroundColor = UIColor.clear
                cell.pickerImageView.isHidden = false
                
            }else{
                cell.pickerImageView.isHidden = true
                cell.colorView.backgroundColor = self.colorArray[indexPath.item]
                cell.colorView.layer.cornerRadius = cell.frame.height * 0.5
                cell.colorView.clipsToBounds = true
            }
            
            return cell
            
        case self.bGColorCollectionView:
            let cell = self.bGColorCollectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
            
            if self.isSelectedBGColor[indexPath.item] {
                cell.selectionImageView.isHidden = false
            }else{
                cell.selectionImageView.isHidden = true
            }
            
            if indexPath.item == 0 {
                cell.backgroundColor = UIColor.clear
                cell.colorView.backgroundColor = UIColor.clear
                cell.cellContainerView.backgroundColor = UIColor.clear
                cell.pickerImageView.isHidden = false
            }else{
                cell.pickerImageView.isHidden = true
                cell.colorView.backgroundColor = self.colorArray[self.colorArray.count - indexPath.item - 1]
                cell.colorView.layer.cornerRadius = cell.frame.height * 0.5
                cell.colorView.clipsToBounds = true
            }
            return cell
            
        default:
            print("Not11 Match")
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.menuCollectionView:
            self.isSelectedMenu[indexPath.item] = true
            for i in 0 ..< self.isSelectedMenu.count {
                if indexPath.item != i {
                    if self.isSelectedMenu[i] {
                        let index = Int(self.collectionViewsBottomConstraint[i].identifier!)
                        UIView.animate(withDuration: 0.5, animations: {
                            self.collectionViewsBottomConstraint[index!].constant = -self.collectionViewContainer.bounds.height
                            self.layoutIfNeeded()
                        })
                    }
                    self.isSelectedMenu[i] = false
                }
            }
            self.menuCollectionView.reloadData()
        case self.fontCollectionView:
        //    print("Font")
            self.isSelectedFont[indexPath.item] = true
            for i in 0 ..< self.isSelectedFont.count {
                if indexPath.item != i {
                    self.isSelectedFont[i] = false
                }
            }
            self.fontCollectionView.reloadData()
        case self.alignmentCollectionView:
            switch indexPath.item {
            case 0:
                self.textView.textAlignment = .center
            case 1:
                self.textView.textAlignment = .left
            case 2:
                self.textView.textAlignment = .right
            default:
                print("Not Match")
            }
            
            self.isSelectedAlignment[indexPath.item] = true
            for i in 0 ..< self.isSelectedAlignment.count {
                if indexPath.item != i {
                    self.isSelectedAlignment[i] = false
                }
            }
            self.alignmentCollectionView.reloadData()
        case self.backgroundCollectionView:
            switch indexPath.item {
            case 0:
                self.textView.backgroundColor = UIColor.clear
            case 1:
                self.textView.backgroundColor = self.currentColor
            case 2:
                self.textView.backgroundColor = self.currentColor.withAlphaComponent(0.5)
            default:
                print("Notn Match")
            }
            
            self.isSelectedBackground[indexPath.item] = true
            for i in 0 ..< self.isSelectedBackground.count {
                if indexPath.item != i {
                    self.isSelectedBackground[i] = false
                }
            }
            self.backgroundCollectionView.reloadData()
            
        case self.textColorCollectionView:
            if indexPath.item == 0 {
                self.colorPicker()
            }else{
                self.textView.textColor = self.colorArray[indexPath.item]
            }
            
            self.isSelectedTextColor[indexPath.item] = true
            for i in 0 ..< self.isSelectedTextColor.count {
                if indexPath.item != i {
                    self.isSelectedTextColor[i] = false
                }
            }
            self.textColorCollectionView.reloadData()
            
        case self.bGColorCollectionView:
            if indexPath.item == 0 {
                self.colorPicker()
            }else{
                self.currentColor = self.colorArray[self.colorArray.count - indexPath.item]
                self.textView.backgroundColor = self.currentColor
                //print("C33  ", self.currentColor)
            }
            
            
            self.isSelectedBGColor[indexPath.item] = true
            for i in 0 ..< self.isSelectedBGColor.count {
                if indexPath.item != i {
                    self.isSelectedBGColor[i] = false
                }
            }
            self.bGColorCollectionView.reloadData()
        default:
            print("Not11 Match")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width = collectionView.bounds.height - 8
        var height = width
      
        switch collectionView {
        case self.menuCollectionView:
            width = self.menuArray[indexPath.item].widthOfString(usingFont: UIFont.systemFont(ofSize: fontSize)) + constant
            height = collectionView.bounds.height - 8
        case self.fontCollectionView:
            width = "ABC".widthOfString(usingFont: UIFont(name: self.fontArray[indexPath.item].fontName, size: fontSize)!) + constant
          //  print("W1  ", width)
            height = collectionView.bounds.height - 8
        case self.textColorCollectionView:
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print("Here  ", textView.font!.pointSize)
        if let char = text.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            //print("Hello")
            if (isBackSpace == -92) {
                //print("Backspace was pressed ",textView.bounds.height )
                if textView.font!.pointSize <  textViewMaxHeight{
                    textView.frame.size.height = textViewMaxHeight
                    textView.increaseFontSize(fontSize: maxFontSize)
                    resizeFont(textView)
                }
                
            }else{
                if textView.frame.size.height >= textViewMaxHeight {
                    resizeFont(textView)
                }else if textView.frame.size.height < (textViewMaxHeight * 0.5) {
                    while textView.font!.pointSize < maxFontSize {
                        textView.increaseFontSize(fontSize: maxFontSize)
                    }
                }
            }
        }
        
       // print("Pre  ", self.textViewPrevSize)
        self.textViewPrevSize = self.textView.bounds.size
        self.delegate?.updateFontSize(size: textView.font!.pointSize)
        print("Here2  ", textView.font!.pointSize)
        //Delegate for Update FontSize
        return true
    }
    
    func resizeFont(_ textView: UITextView) {
        if (textView.text.isEmpty || textView.bounds.size.equalTo(CGSize.zero)) {
            return;
        }
        let textViewSize = textView.frame.size
        let fixedWidth = textViewSize.width
       // print("SSSZZZZ  ",textViewSize)
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
        }
    }
}

extension TextBottomView{
    
    fileprivate func addGestureToHideView(){
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapped(_: )))
        tapGesture.numberOfTapsRequired = 1
       self.hideView.addGestureRecognizer(tapGesture)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_: )))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        self.hideView.addGestureRecognizer(panGesture)
        self.hideView.isUserInteractionEnabled = true
        self.hideView.backgroundColor = UIColor.yellow
    }
    
    @objc func handleTapped(_ sender: UITapGestureRecognizer){
        print("T T")
        self.delegate?.tappedOnHideView()
    }
    
    @objc func handlePan(_ sender: UIPanGestureRecognizer){
        print("P T")
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
    
    //MARK: ColorPicker
    fileprivate func colorPicker(){
        self.delegate?.goToColorPicker()
    }
}

