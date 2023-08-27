import UIKit
import RealmSwift

class ViewController: UIViewController {
    let realm = try! Realm()

    @IBOutlet weak var tableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
      //  fetchPeople()
    }
    @IBAction func addName(_ sender: Any) {
        let alert = UIAlertController(title: "New Name", message: "add a new name", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            action in
            let textFiled = alert.textFields?.first
            //Cerate a Person Opject
            let nameToSave = realm.write{
                realm.add(Item)
            }
            nameToSave.name = textFiled?.text
            self.saveItem()
            self.fetchPeople()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
extension ViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        people.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = Person.value(forKeyPath: "name")as? String
        return cell
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { _, _
            ,_ in
            let remove = self.people[indexPath.row]
            self.context.delete(remove)
            self.saveItem()
         //   self.fetchPeople()
            
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let Person = people[indexPath.row]
        let alert = UIAlertController(title: "Save", message: "Edit the name", preferredStyle: .alert)
        alert.addTextField()
        let textField = alert.textFields?.first
        textField?.text = Person.name
        let saveButton = UIAlertAction(title: "Save", style: .default) { action in
            let textField = alert.textFields?.first
            Person.name = textField?.text
            self.saveItem()
            self.fetchPeople()
            
        }
        alert.addAction(saveButton)
        present(alert, animated: true)
        
    }
    func save(Item: Item){
        do {
            try realm.write{
                realm.add(Item)
            }
        } catch {
            print("erorr")
        }
        tableView.reloadData()
    }
//    func fetchPeople(){
//        self.people = try! context.fetch(Person.fetchRequest())
//        tableView.reloadData()
//    }
}
