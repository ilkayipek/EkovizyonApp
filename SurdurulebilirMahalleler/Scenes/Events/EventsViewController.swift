//
//  EventsViewController.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 28.04.2024.
//

import UIKit

class EventsViewController: BaseViewController<EventsViewModel> {
    @IBOutlet weak var eventsTableView: UITableView!
    var events = [EventModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = EventsViewModel()
        configureEventsTableView()
        getEvents()
    }
    
    private func configureEventsTableView() {
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        
        let cellString = String(describing: EventsTableViewCell.self)
        eventsTableView.register(UINib(nibName: cellString, bundle: nil), forCellReuseIdentifier: cellString)
    }
    
    func getEvents() {
        viewModel?.getEvenents { [weak self] results in
            guard let results else {return}
            guard let self else {return}
            
            self.events = results
            self.eventsTableView.reloadData()
        }
    }
    @IBAction func verificationEventButtonClicked(_ sender: Any) {
        addAlertBox { [weak self] code in
            guard let self else {return}
            guard let code else {return}
            self.viewModel?.checkEventVerificationCode(code) { status in
                print("Dönen status Değeri\(status)")
            }
        }
    }
    
    private func addAlertBox(_ closure: @escaping(_ code: String?)->Void) {
        let alertController = UIAlertController(title: "Etkinlik Doğrula", message: "", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Doğrulam Kodunu Giriniz"
        }
        
        let okAction = UIAlertAction(title: "Doğrula", style: .default) { _ in
            if let text = alertController.textFields?.first?.text {
                closure(text)
            }
        }
        
        let cancelAction = UIAlertAction(title: "iptal", style: .cancel)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = eventsTableView.dequeueReusableCell(withIdentifier: String(describing: EventsTableViewCell.self), for: indexPath) as! EventsTableViewCell
        guard !events.isEmpty else {return cell}
        
        let model = events[indexPath.row]
        cell.loadCell(model)
        return cell
    }
    
    
}
