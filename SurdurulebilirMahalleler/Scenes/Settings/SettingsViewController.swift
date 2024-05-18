//
//  SettingsViewController.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 7.05.2024.
//

import UIKit

class SettingsViewController: BaseViewController<SettingsViewModel> {
    //MARK: VERRIABLES
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var profileImageView: CustomUIImageView!
    @IBOutlet weak var signOutButton: CustomUIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    @IBOutlet weak var dateOfBirthDatePicker: UIDatePicker!
    @IBOutlet weak var passwordUpdateButton: UIButton!
    
    let dateFormatter = DateFormatter()
    var userDetail: UserDetailModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SettingsViewModel()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        configureTextFields()
        setUserDetail()
        setSaveButton()
    }
    
    // MARK: FUNCTIONS
    
    // Display user details.
    private func setUserDetail() {
        let userDetail: UserDetailModel? = UserInfo.shared.retrieve(key: .userDetail)
        guard let userDetail else {navigationController?.popViewController(animated: true); return}
        self.userDetail = userDetail
        
        fullNameTextField.text = userDetail.fullName
        usernameTextField.text = userDetail.username
        emailTextField.text = userDetail.email
        dateOfBirthDatePicker.date = userDetail.dateOfBirth
        dateOfBirthTextField.text = dateFormatter.string(from: dateOfBirthDatePicker.date)
        phoneNumberTextField.text = userDetail.phoneNumber
        
        if let profileImageUrl = URL(string: userDetail.profileImageUrl ?? "") {
            profileImageView.loadImage(url: profileImageUrl, placeHolderImage: nil, nil)
        }
        
    }
    
    private func configureTextFields() {
        
        setTextFielsDelegate()
        closeKeyboardWhenSceneTapped()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setTextFielsDelegate() {
        fullNameTextField.delegate = self
        usernameTextField.delegate = self
        emailTextField.delegate = self
        dateOfBirthTextField.delegate = self
        phoneNumberTextField.delegate = self
    }
    
    private func setSaveButton() {
        let saveButton = UIButton(type: .custom)
        
        saveButton.setTitle("Save", for: .normal)
        let buttonFont = UIFont.boldSystemFont(ofSize: 17)
        saveButton.titleLabel?.font = buttonFont
        saveButton.setTitleColor(.white, for: .normal)
        
        saveButton.backgroundColor = .activeButtonBackground
        
        saveButton.addTarget(self, action: #selector(saveUserDetail), for: .touchUpInside)
        saveButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        saveButton.layer.cornerRadius = 15
        
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        
        self.navigationItem.rightBarButtonItem = saveBarButton
    }
    
    private func closeKeyboardWhenSceneTapped() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    private func isEmptyTextFields() -> Bool {
        guard let name = fullNameTextField.text else {return true}
        guard let userName = usernameTextField.text else {return true}
        guard name.isEmpty || userName.isEmpty || name == "" || userName == "" else {return false}
        return true
    }
    
    private func transitionToSignUpScene() {
        let targetVc = SignUpViewController()
        let navigationVc = UINavigationController(rootViewController: targetVc)
        navigationVc.modalPresentationStyle = .fullScreen
        present(navigationVc, animated: true)
    }
    
    private func transitionToSignInScene() {
        let targetVc = SignInViewController()
        let navigationVc = UINavigationController(rootViewController: targetVc)
        navigationVc.modalPresentationStyle = .fullScreen
        present(navigationVc, animated: true)
    }
    
    //MARK: OBJC FUNCTIONS
    
    @objc func saveUserDetail() {
        guard var newUserDetail = userDetail else {return}
        guard !isEmptyTextFields() else {
            failAnimation(text: "Ad soyad veya kullanıcı adı boş bırakılamaz"); return
        }
        
        guard let date = dateFormatter.date(from: dateOfBirthTextField.text ?? "") else {
            failAnimation(text: "Date Hatalı"); return
        }
        
        newUserDetail.fullName = fullNameTextField.text
        newUserDetail.username = usernameTextField.text
        newUserDetail.email = emailTextField.text
        newUserDetail.phoneNumber = phoneNumberTextField.text
        newUserDetail.dateOfBirth = date
        
        guard let defaultImage = UIImage(named: "person") else {return}
        
        viewModel?.updateUserInfos(newUserDetail, (profileImageView.image) ?? defaultImage) {[weak self] status in
            guard status else {return}
            guard let self else {return}
            self.setUserDetail()
        }
    }
    
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateOfBirthTextField.inputView = dateOfBirthDatePicker
        let dateString = dateFormatter.string(from: sender.date)
        dateOfBirthTextField.text = dateString
        userDetail?.dateOfBirth = sender.date
    }
    
    @objc private func closeKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keywoardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keywoardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
    }
    
    @IBAction func deleteAccountButtonClicked(_ sender: Any) {
        alertMessageDefault("UYARI!", "Hesabınızı Silmek İstediğinize Emin Misiniz ?", "Sil") {[weak self] _ in
            guard let self else {return}
            
            viewModel?.deleteAccount { status in
                guard status else {return}
                self.transitionToSignUpScene()
            }
        }
    }
    
    @IBAction func signOutButtonClicked(_ sender: Any) {
        let auth = AuthManager.shared.auth
        do {
            try auth.signOut()
            transitionToSignInScene()
        } catch {
            failAnimation(text: "Oturup Sonlandırılamadı")
        }
    }
    
}


extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
