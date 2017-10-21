//
//  UIViewController+Extension.swift
//  FudarTruck
//
//  Created by Michael Sevy on 10/21/17.
//  Copyright © 2017 Michael Sevy. All rights reserved.
//

import Foundation
import SVProgressHUD
import IQKeyboardManager
import KYNavigationProgress
import MessageUI

extension UIViewController {

    /// Shows the progress hud.
    func showProgressHud() {
        SVProgressHUD.show()
    }

    /// Dismisses the progress hud.
    func dismissProgressHud() {
        SVProgressHUD.dismiss()
    }

    // Show progress hud with description.
    func showProgressHud(withStatus: String!) {
        SVProgressHUD.show(withStatus: withStatus)
    }

    /**
     Displays a message in the hud and then dismisses it after a certain duration.

     - Parameters:
     - message: A `String` representing the message to display in the hud.
     - iconType: A `HudIconType` representing the type of icon to display in the hud.
     - duration: A `Double` indicating how long the hud should stay in the window for. If `nil` is passed,
     two will be used.
     */
    func dismissProgressHudWithMessage(_ message: String, iconType: HudIconType, duration: Double?) {
        var dismissDuration = 2.0
        if let dismissTime = duration {
            dismissDuration = dismissTime
        }
        switch iconType {
        case .success:
            SVProgressHUD.showSuccess(withStatus: message)
            break
        case .error:
            SVProgressHUD.showError(withStatus: message)
            break
        case .info:
            SVProgressHUD.showInfo(withStatus: message)
            break
        }
        SVProgressHUD.dismiss(withDelay: dismissDuration)
    }
}


// MARK: - Public Instance Methods For IQKeyboardManager
extension UIViewController {

    func enableKeyboardManagement(_ shouldEnable: Bool) {
        IQKeyboardManager.shared().isEnabled = shouldEnable
    }
}


// MARK: - Public Instance Methods For KYNavigationProgress
extension UIViewController {

    func setProgressForNavigationBar(progress: Float) {
        navigationController?.setProgress(progress, animated: true)
    }

    /// Animates the finishing of the progress bar in the navigation controller.
    func finishProgressBar() {
        navigationController?.finishProgress()
    }

    /// Animates the canceling of the progress bar in the navigation controller.
    func cancelProgressBar() {
        navigationController?.cancelProgress()
    }
}

// MARK: - Public Instance Methods For SCLAlertView
extension UIViewController {

    func showErrorAlert(title: String, subTitle: String) {
        let alert = LYAlertViewController(shouldAutoDismiss: true, shouldShowCloseButton: false)
        alert.showErrorAlert(title: title, subtitle: subTitle)
    }


    func showInfoAlert(title: String, subTitle: String) {
        let alert = LYAlertViewController(shouldAutoDismiss: true, shouldShowCloseButton: false)
        alert.showInfoAlert(title: title, subtitle: subTitle)
    }
}


// MARK: - Public Instance Methods For UIActivityIndicatorView
extension UIViewController {

    func showActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.color = .main
        activityIndicatorView.tag = 99
        activityIndicatorView.center = view.center
        activityIndicatorView.alpha = 0
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.animateShow()
    }

    /// Dismisses the native activity indicator from the center of the view.
    func dismissActivityIndicator() {
        guard let activityIndicatorView = view.subviews.filter({ $0.tag == 99 }).first else { return }
        activityIndicatorView.animateHide()
        activityIndicatorView.removeFromSuperview()
    }
}


// MARK: - Public Instance Methods For MFMailComposeViewController
extension UIViewController {


    func showMailComposeView(emails: [String], subject: String, message: String, isHTML: Bool, failure: @escaping () -> Void) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeController = MFMailComposeViewController()
            mailComposeController.setToRecipients(emails)
            mailComposeController.setSubject(subject)
            mailComposeController.setMessageBody(message, isHTML: isHTML)
            mailComposeController.mailComposeDelegate = self
            mailComposeController.navigationController?.navigationBar.barTintColor = .main
            present(mailComposeController, animated: true, completion: nil)
        } else {
            failure()
        }
    }
}


// MARK: - MFMailComposeViewControllerDelegate
extension UIViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}


// MARK: - Public Class Methods
extension UIViewController {

    /// The storyboard identifier used.
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}


/// An enum that specifies the type of icon to display in the progress hud.
enum HudIconType {
    case success
    case error
    case info
}

