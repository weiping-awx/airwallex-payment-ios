//
//  WeChatDemoViewController.swift
//  Examples
//
//  Created by Weiping Li on 2025/1/21.
//  Copyright © 2025 Airwallex. All rights reserved.
//

import UIKit
import Airwallex

class WeChatDemoViewController: UIViewController {
    
    struct FieldKey {
        static let appId = "appId"
        static let partnerId = "partnerId"
        static let prepayId = "prepayId"
        static let package = "package"
        static let nonceStr = "nonceStr"
        static let timeStamp = "timeStamp"
        static let sign = "sign"
    }
    
    private lazy var topView: TopView = {
        let view = TopView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let viewModel = TopViewModel(
            title: "Launch WeChat demo"
        )
        view.setup(viewModel)
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardDismissMode = .interactive
        return view
    }()
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 24
        view.axis = .vertical
        return view
    }()
    
    private lazy var nextButton: UIButton = {
        let view = AWXButton(style: .primary, title: "Next")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(onNextButtonTapped), for: .touchUpInside)
        return view
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = .awxCGColor(.borderDecorative)
        view.layer.borderWidth = 1
        return view
    }()
    
    private lazy var keyboardHandler = KeyboardHandler()
    
    private lazy var fieldViewModels: [ConfigTextFieldViewModel] = [
        ConfigTextFieldViewModel(
            displayName: "WeChat App ID",
            fieldKey: FieldKey.appId,
            text: "wx4c86d73fe4f82431"
        ),
        ConfigTextFieldViewModel(
            displayName: "Partner ID",
            fieldKey: FieldKey.partnerId
        ),
        ConfigTextFieldViewModel(
            displayName: "Prepay ID",
            fieldKey: FieldKey.prepayId
        ),
        ConfigTextFieldViewModel(
            displayName: "Package",
            fieldKey: FieldKey.package
        ),
        ConfigTextFieldViewModel(
            displayName: "NonceStr",
            fieldKey: FieldKey.nonceStr
        ),
        ConfigTextFieldViewModel(
            displayName: "Time Stamp",
            fieldKey: FieldKey.timeStamp
        ),
        ConfigTextFieldViewModel(
            displayName: "Sign",
            fieldKey: FieldKey.sign
        ),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeNavigationBackButton()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardHandler.startObserving(scrollView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardHandler.stopObserving()
    }
    
    private func setupViews() {
        customizeNavigationBackButton()
        view.backgroundColor = .awxColor(.backgroundPrimary)
        view.addSubview(scrollView)
        scrollView.addSubview(stack)
        stack.addArrangedSubview(topView)
        
        for viewModel in fieldViewModels {
            let textField = ConfigTextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.setup(viewModel)
            stack.addArrangedSubview(textField)
        }
        
        view.addSubview(bottomView)
        bottomView.addSubview(nextButton)
        
        var constraints = [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            stack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 6),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -32),
            stack.widthAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.widthAnchor, constant: -32),
            
            bottomView.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -1),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 1),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            nextButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16),
            nextButton.leadingAnchor.constraint(equalTo: bottomView.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: bottomView.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            nextButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 52),
        ]
        
        let nextButtonBottomConstraint = nextButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -40)
        nextButtonBottomConstraint.priority = .required - 1
        constraints.append(nextButtonBottomConstraint)
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func onNextButtonTapped() {
        var fields = [String: String]()
        fields = fieldViewModels.reduce(into: fields, { partialResult, viewModel in
            guard let text = viewModel.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return }
            partialResult[viewModel.fieldKey] = text
        })
        
        guard fields.count == fieldViewModels.count else {
            showAlert(message: "Please fill in all the fields")
            return
        }
#if canImport(WechatOpenSDK)
        let payReq = PayReq()
        payReq.partnerId = fields[FieldKey.partnerId]!
        payReq.prepayId = fields[FieldKey.prepayId]!
        payReq.package = fields[FieldKey.package]!
        payReq.nonceStr = fields[FieldKey.nonceStr]!
        payReq.timeStamp = UInt32(fields[FieldKey.timeStamp]!) ?? 0
        payReq.sign = fields[FieldKey.sign]!
        
        print(payReq.partnerId, payReq.prepayId, payReq.package, payReq.nonceStr, payReq.timeStamp, payReq.sign)
        Task {
            let success = await WXApi.send(payReq)
            showAlert(message: success ? "WXApi.send(payReq) succeed" : "WXApi.send(payReq) failed")
        }
#else
        showAlert(message: "Please add dependency for WeChatPay(cocoapods)/AirwallexWeChatPay(SPM)")
#endif
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            bottomView.layer.borderColor = .awxCGColor(.borderDecorative)
        }
    }
}
