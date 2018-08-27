//
//  ContactListVC.swift
//  ContactList
//
//  Created by Rahul Chopra on 22/08/18.
//  Copyright © 2018 AppSmall. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ContactListVC: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var organizationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func showContactListBtnPressed(_ sender: UIButton) {
        let entityType = CNEntityType.contacts    //User can grant access to contacts
        
        /*** CNContactStore :- It can fetch and save contacts, groups, and containers. ***/
        //It can check the authorization status of user contact list.
        let authStatus = CNContactStore.authorizationStatus(for: entityType)
        
        if authStatus == CNAuthorizationStatus.notDetermined {
            let contactStore = CNContactStore.init()
            contactStore.requestAccess(for: entityType) { (sucess, error) in
                if sucess {
                    self.openContacts()
                }
                else {
                    print("You are not authorized using your contact list.")
                }
            }
        }
        else if authStatus == CNAuthorizationStatus.authorized {
            self.openContacts()
        }
    }
    
    func openContacts() {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    
}

extension ContactListVC: CNContactPickerDelegate {
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        //when user selects any contact, then show all selected details in the app
        print(contact)

        //Getting FirstName and LastName
        let fullName = "\(contact.givenName) \(contact.familyName)"
        
        //Getting Organization Name
        var organizationName = "Not Applicable"
        if !contact.organizationName.isEmpty {
            organizationName = "\(contact.organizationName)"
        }
        
        //Getting Email Address
        var emailAddress = "Not Available"
        if !contact.emailAddresses.isEmpty {
            let fullEmail = (((contact.emailAddresses[0] as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value"))
            if let email = fullEmail as? String {
                emailAddress = email
            }
        }

        //Getting Phone Number
        var phone = "Not Applicable"
        if !contact.phoneNumbers.isEmpty {
            let phoneNumber = ((((contact.phoneNumbers[0] as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value") as AnyObject).value(forKey: "stringValue"))
            if let phoneNumberString = phoneNumber as? String {
                phone = phoneNumberString
            }
        }
        
        //Getting Street Address
        var postalAddress = "Not Applicable"
        if !contact.postalAddresses.isEmpty {
            if let postalAddressPair = (((contact.postalAddresses[0] as AnyObject).value(forKey: "labelValuePair") as AnyObject).value(forKey: "value")) as? CNPostalAddress {
                postalAddress = "\(postalAddressPair.street) \(postalAddressPair.city) \(postalAddressPair.state) \(postalAddressPair.postalCode)"
                
                print("Postal Adress: \(postalAddress)")
            }
            
        }

        //Show all details in the label
        nameLabel.text = fullName
        emailLabel.text = emailAddress
        phoneLabel.text = phone
        organizationLabel.text = organizationName
        addressLabel.text = postalAddress
    }
}
