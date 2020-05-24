//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var data = ["One", "Two", "Three"]
    /*
     Our initial implementation needs a little more setup
     therefore we should initialise it with a closure
     look at it. We are setting a lot of things here
     */
    let roundButton:UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 50))
        //to programmatically control auto-layout
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor.purple
        //round the button
        btn.layer.cornerRadius = 5.0
        btn.layer.masksToBounds = true
        return btn
    }()
    var tableView = UITableView()
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        
        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        let attr:[NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.white
        ]
        let attrStr = NSAttributedString(string: "Animate cells", attributes: attr)
        roundButton.setAttributedTitle(attrStr, for: .normal)
        roundButton.addTarget(self, action: #selector(animateCell), for: .touchUpInside)
        
        view.addSubview(roundButton)
        view.addSubview(label)
        view.addSubview(tableView)
        self.view = view
        
        NSLayoutConstraint.activate([
            roundButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            roundButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: roundButton.bottomAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    /*
     When you animate cell is clicked, either
     delete a row
     add a row
     or reset and reload tableRows with
     original data
     randomly pick between 1 and 3
     */
    @objc func animateCell() {
        let rand = Int.random(in: 1...3)
        print("Rand value -> \(rand)")
        switch rand {
        case 1: //add
            let newText = "New data@\(Date().timeIntervalSince1970)"
            data.append(newText)
            //here we append a value and animate adding row
            //and the UITableView operates on a 0 index
            //i.e. the first row has index position of 1
            let indexSetArr = [IndexPath(row: (data.count - 1), section: 0)]
            tableView.insertRows(at: indexSetArr, with: .fade)
            break
        case 2: //delete
            if data.count > 1 {
                data.remove(at: 0)
                let path = IndexPath(row: 0, section: 0)
                tableView.deleteRows(at: [path], with: .left)
            } else {
                let msg = """
                            No data or rows to remove. Keep tapping
                            animate to eventually randomly add a value
                        """
                print(msg)
            }
            break
        case 3: //reset and reload everything
            data = ["One", "Two", "Three"]
            let set = IndexSet(integersIn: 0...0)
            tableView.reloadSections(set, with: .middle)
            break
        default:
            print("We shouldn't be here")
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        let element = data[indexPath.row]
        cell.textLabel?.text = element
        return cell
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
