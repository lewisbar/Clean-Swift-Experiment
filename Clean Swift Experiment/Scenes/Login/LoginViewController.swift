//
//  LoginViewController.swift
//  Clean Swift Experiment
//
//  Created by Lennart Wisbar on 22.01.22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LoginDisplayLogic: AnyObject
{
    func displayLoginFeedback(viewModel: Login.LoginCheck.ViewModel)
}

class LoginViewController: UIViewController, LoginDisplayLogic
{
    var interactor: LoginBusinessLogic?
    var router: (NSObjectProtocol & LoginRoutingLogic & LoginDataPassing)?
    
    var nameTextField: UITextField!
    var passwordTextField: UITextField!
    var feedbackLabel: UILabel!
    var goToOverviewButton: UIButton!
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        let router = LoginRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        createUI()
    }
    
    func createUI() {
        view.backgroundColor = .black
        
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome"
        welcomeLabel.font = UIFont.systemFont(ofSize: Sizes.Fonts.title)
        welcomeLabel.textColor = .white
        
        let nameLabel = UILabel()
        nameLabel.text = "Username"
        nameLabel.font = UIFont.systemFont(ofSize: Sizes.Fonts.labels)
        nameLabel.textColor = .white
        
        let passwordLabel = UILabel()
        passwordLabel.text = "Password"
        passwordLabel.font = UIFont.systemFont(ofSize: Sizes.Fonts.labels)
        passwordLabel.textColor = .white
        
        nameTextField = UITextField()
        nameTextField.delegate = self
        nameTextField.placeholder = "Max Mustermann"
        nameTextField.font = UIFont.systemFont(ofSize: Sizes.Fonts.textFields)
        nameTextField.backgroundColor = .white
        nameTextField.addHorizontalInsets(width: Sizes.Spacing.tiny)
        
        passwordTextField = UITextField()
        passwordTextField.delegate = self
        passwordTextField.placeholder = "12345678"
        passwordTextField.font = UIFont.systemFont(ofSize: Sizes.Fonts.textFields)
        passwordTextField.backgroundColor = .white
        passwordTextField.addHorizontalInsets(width: Sizes.Spacing.tiny)
        
        feedbackLabel = UILabel()
        feedbackLabel.text = " "
        
        let action = UIAction(title: "Go to overview") { [unowned self]_ in
            router?.route(to: OverviewViewController())
        }
        goToOverviewButton = UIButton(type: .system, primaryAction: action)
        goToOverviewButton.alpha = 0
                
        let labelStack = UIStackView(arrangedSubviews: [nameLabel, passwordLabel])
        labelStack.axis = .vertical
        labelStack.alignment = .trailing
        labelStack.distribution = .fillEqually
        labelStack.spacing = Sizes.Spacing.medium
        
        let textFieldStack = UIStackView(arrangedSubviews: [nameTextField, passwordTextField])
        textFieldStack.axis = .vertical
        textFieldStack.alignment = .fill
        textFieldStack.distribution = .fillEqually
        textFieldStack.spacing = Sizes.Spacing.medium
        
        let middleStack = UIStackView(arrangedSubviews: [labelStack, textFieldStack])
        middleStack.axis = .horizontal
        middleStack.distribution = .fillProportionally
        middleStack.spacing = Sizes.Spacing.medium
        
        let parentStack = UIStackView(arrangedSubviews: [
            welcomeLabel,
            middleStack,
            feedbackLabel,
            goToOverviewButton])
        parentStack.axis = .vertical
        parentStack.alignment = .center
        parentStack.translatesAutoresizingMaskIntoConstraints = false
        parentStack.spacing = Sizes.Spacing.medium
        parentStack.setCustomSpacing(Sizes.Spacing.large, after: welcomeLabel)
        
        view.addSubview(parentStack)

        NSLayoutConstraint.activate([
            nameTextField.heightAnchor.constraint(equalToConstant: Sizes.Spacing.textFieldHeight),
            passwordTextField.heightAnchor.constraint(equalToConstant: Sizes.Spacing.textFieldHeight),
            nameTextField.widthAnchor.constraint(equalToConstant: Sizes.Spacing.textFieldWidth),
            passwordTextField.widthAnchor.constraint(equalToConstant: Sizes.Spacing.textFieldWidth),
            parentStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            parentStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        struct Sizes {
            struct Spacing {
                static let tiny: CGFloat = 4
                static let small: CGFloat = 8
                static let medium: CGFloat = 16
                static let large: CGFloat = 48
                static let textFieldHeight: CGFloat = 36
                static let textFieldWidth: CGFloat = 200
            }
            struct Fonts {
                static let title: CGFloat = 70
                static let labels: CGFloat = 20
                static let textFields: CGFloat = 20
            }
        }
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func checkLogin()
    {
        guard let name = nameTextField.text,
              let password = passwordTextField.text
        else { return }
        
        let request = Login.LoginCheck.Request(name: name, password: password)
        interactor?.checkLogin(request: request)
    }
    
    func displayLoginFeedback(viewModel: Login.LoginCheck.ViewModel)
    {
        feedbackLabel.text = viewModel.message
        feedbackLabel.textColor = viewModel.isLoginValid ? .green : .red
        goToOverviewButton.alpha = viewModel.isLoginValid ? 1 : 0
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkLogin()
        return true
    }
}

extension UITextField {
    func addHorizontalInsets(width: CGFloat) {
        let rect = CGRect(x: 0, y: 0, width: width, height: frame.size.height)
        
        let leftSpacer = UIView(frame: rect)
        leftViewMode = UITextField.ViewMode.always
        leftView = leftSpacer
        
        let rightSpacer = UIView(frame: rect)
        rightViewMode = UITextField.ViewMode.always
        rightView = rightSpacer
    }
}
