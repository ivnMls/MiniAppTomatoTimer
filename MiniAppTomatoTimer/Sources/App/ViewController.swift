//
//  ViewController.swift
//  MiniAppTomatoTimer
//
//  Created by User on 17.02.23.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    //MARK: - Outlets

    private lazy var backgroundView: UIImageView = {
        let image = UIImage(named: "backgroundRed")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var previewLabel: UILabel = {
        let label = UILabel()
        label.text = "Tomato Timer by I.Demidov"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    private lazy var shapeView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ellipse")
        imageView.adjustsImageSizeForAccessibilityContentSizeCategory = false
        return imageView
    }()

    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "\(durationTimer)"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 60)
        label.textColor = .black
        label.layer.shadowColor = UIColor.black.cgColor //задаем цвет тени
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    private lazy var buttonStart: UIButton = {
        let button = UIButton()
        button.setTitle("START", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .black
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        button.layer.shadowOpacity = 0.2                 //задаем прозрачность тени
        button.layer.shadowOffset = .zero                //отключаем смещение тени
        button.layer.shadowRadius = 10                   //задаем радиус скруглени тени
        button.layer.shouldRasterize = true              //отвечает за растрирование тение
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var buttonPause: UIButton = {
        let button = UIButton()
        button.setTitle("STOP", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .black
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(pausedTapped), for: .touchUpInside)
        button.layer.shadowOpacity = 0.2                 //задаем прозрачность тени
        button.layer.shadowOffset = .zero                //отключаем смещение тени
        button.layer.shadowRadius = 10                   //задаем радиус скруглени тени
        button.layer.shouldRasterize = true              //отвечает за растрирование тение
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var timerWork = Timer()
    var timerRest = Timer()


    var durationTimer = 25

    var isWork = false
    var isStarted = false

    let shapeLayer = CAShapeLayer()

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.animationCircular()
    }


    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
        setupLayout()
        buttonStart.isHidden = false
        buttonPause.isHidden = true
    }


    //MARK: - Animation

    func animationCircular() {
        let center = CGPoint(x: shapeView.frame.width / 2 , y: shapeView.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle

        let circularPath = UIBezierPath(arcCenter: center, radius: 138, startAngle: startAngle, endAngle: endAngle, clockwise: false)

        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 21
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = CGColor.init(red: 224, green: 224, blue: 224, alpha: 0.6)
        shapeView.layer.addSublayer(shapeLayer)

    }

    func basicAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")

        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true

        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }



    //MARK: - Setup



    private func setupHierarchy() {
        view.addSubview(backgroundView)
        view.addSubview(previewLabel)
        view.addSubview(buttonStart)
        view.addSubview(buttonPause)
        view.addSubview(shapeView)
        shapeView.addSubview(timerLabel)
    }

    private func setupLayout() {

        backgroundView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }

        previewLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.safeAreaInsets.top).offset(100)
        }

        buttonStart.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.bottom).offset(-100)
            make.height.equalTo(50)
            make.width.equalTo(200)
        }

        buttonPause.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.bottom).offset(-100)
            make.height.equalTo(50)
            make.width.equalTo(200)
        }

        shapeView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.height.equalTo(305)
            make.width.equalTo(shapeView.snp.height)
        }

        timerLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
        }

    }



    //MARK: - Actions

    @objc func playTapped(_ sender: UIButton) {
        buttonStart.isHidden = true
        buttonPause.isHidden = false

        basicAnimation()

        timerWork = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }

    @objc func pausedTapped(_ sender: UIButton) {
        timerWork.invalidate()
        timerRest.invalidate()
        timerLabel.text = "\(durationTimer)"
        buttonStart.isHidden = false
        buttonPause.isHidden = true
    }

    @objc func timerAction() {
        if durationTimer > 0 {
            durationTimer -= 1
            timerLabel.text = "\(durationTimer)"
        } else {
            backgroundView.image = UIImage(named: "backgroundGreen")
            timerWork.invalidate()
            durationTimer = 10
            timerLabel.text = "\(durationTimer)"
            timerRest = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerResting), userInfo: nil, repeats: true)
        }
    }

    @objc func timerResting() {
        if durationTimer > 0 {
            durationTimer -= 1
            timerLabel.text = "\(durationTimer)"
        } else {
            backgroundView.image = UIImage(named: "backgroundRed")
            durationTimer = 25
            timerLabel.text = "\(durationTimer)"
            timerRest.invalidate()
            timerWork = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
    }
}

    //MARK: - Extension
