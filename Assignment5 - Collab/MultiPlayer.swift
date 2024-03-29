//
//  ViewController.swift
//  MultipeerExample
//
//  Created by Eyuphan Bulut on 4/5/17.
//  Copyright © 2017 Eyuphan Bulut. All rights reserved.
//

import UIKit
import MultipeerConnectivity

var mpc = MCPeerManager()

class Multiplayer: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate {
    
    
    
    var session: MCSession!
    
    var peerID: MCPeerID!
    
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!
    
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var pid1: UILabel!
    @IBOutlet weak var pid2: UILabel!
    @IBOutlet weak var pid3: UILabel!
    @IBOutlet weak var pid4: UILabel!
    @IBOutlet weak var ans1: UILabel!
    @IBOutlet weak var ans2: UILabel!
    @IBOutlet weak var ans3: UILabel!
    @IBOutlet weak var ans4: UILabel!
    @IBOutlet weak var score1: UILabel!
    @IBOutlet weak var score2: UILabel!
    @IBOutlet weak var score3: UILabel!
    @IBOutlet weak var score4: UILabel!
    @IBOutlet weak var qheader: UILabel!
    @IBOutlet weak var qsentence: UILabel!
    @IBOutlet weak var choice1: UIButton!
    @IBOutlet weak var choice2: UIButton!
    @IBOutlet weak var choice3: UIButton!
    @IBOutlet weak var choice4: UIButton!
    @IBOutlet weak var countdown: UILabel!
    @IBOutlet weak var startover: UIButton!
    @IBOutlet weak var bubble1: UIImageView!
    @IBOutlet weak var bubble2: UIImageView!
    @IBOutlet weak var bubble3: UIImageView!
    @IBOutlet weak var bubble4: UIImageView!
    
    let playerAssets : [UIImage] = [ #imageLiteral(resourceName: "User Filled-Blue2"), #imageLiteral(resourceName: "User Filled-Violet"), #imageLiteral(resourceName: "User Filled-Green"), #imageLiteral(resourceName: "User Filled-Orange")  ]
    
    let defaultColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
    let selectColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
    let submitColor = UIColor.cyan
    let revealColor = UIColor.green
    let COUNTDOWN_TIME = 20
    let transitionTime = 3
    let maxPlayers = 4
    
    var timer : Timer!
    var timeInSeconds : Int = 0
    var scores = Array(repeating: 0, count: 4)
    var tappedCount = Array(repeating: 0, count: 4)
    var numberOfPlayers : Int = 0
    let choices = ["A", "B", "C", "D"]
    var gameplayers = Array(repeating: (name: "", id: 0), count: 4)
    
    var num : String = ""
    
    
    var myplayer = (name: "", score: 0, Ans: "")
    var answers = Array(repeating: "", count: 3)
    let msg1 = "reveal"
    let msg2 = "restart"
    let msg3 = "back"
    
    

    
    var quiz = quizProperties()
    
    
    func initialize() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(quizTimer), userInfo: nil, repeats: true)
        
        timeInSeconds = 0
        
        for i in 0 ..< tappedCount.count {
            tappedCount[i] = 0
        }
        /*options.forEach({
            $0.backgroundColor = defaultColor
            $0.isUserInteractionEnabled = true
        })*/
        
        choice1.backgroundColor = defaultColor
        choice1.isUserInteractionEnabled = true
        choice2.backgroundColor = defaultColor
        choice2.isUserInteractionEnabled = true
        choice3.backgroundColor = defaultColor
        choice3.isUserInteractionEnabled = true
        choice4.backgroundColor = defaultColor
        choice4.isUserInteractionEnabled = true
        
        for i in 0 ..< maxPlayers {
            if i+1 > numberOfPlayers {
                
                switch i {
                    
                case 0:
                    
                    img1.image = #imageLiteral(resourceName: "User-Unfilled")
                    img1.alpha = 0.02
                    score1.isEnabled = false
                    score1.alpha = 0.5
                    
                    bubble1.isHidden = true
                    ans1.isHidden = true
                    
                case 1:
                    
                    img2.image = #imageLiteral(resourceName: "User-Unfilled")
                    img2.alpha = 0.02
                    score2.isEnabled = false
                    score2.alpha = 0.5
                    
                    bubble2.isHidden = true
                    ans2.isHidden = true
                    
                case 2:
                    
                    img3.image = #imageLiteral(resourceName: "User-Unfilled")
                    img3.alpha = 0.02
                    score3.isEnabled = false
                    score3.alpha = 0.5
                    
                    bubble3.isHidden = true
                    ans3.isHidden = true
                    
                case 3:
                    
                    img4.image = #imageLiteral(resourceName: "User-Unfilled")
                    img4.alpha = 0.02
                    score4.isEnabled = false
                    score4.alpha = 0.5
                    
                    bubble4.isHidden = true
                    ans4.isHidden = true
                    
                default:
                    img2.image = #imageLiteral(resourceName: "User Filled-Cyan")
                    img2.alpha = 0.02
                    score2.isEnabled = false
                    score2.alpha = 0.5
                    
                    bubble2.isHidden = true
                    ans2.isHidden = true
                }
                
            }
                
            else {
                
                switch i {
                case 0:
                    img1.image = playerAssets[i]
                case 1:
                    img2.image = playerAssets[i]
                case 2:
                    img3.image = playerAssets[i]
                case 3:
                    img4.image = playerAssets[i]
                default:
                    img1.image = playerAssets[2]
                }
                
            }
            
            switch i {
                
            case 0:
                ans1.text = ""
                img1.contentMode = .scaleAspectFit
                score1.text = "\(scores[i])"
            case 1:
                ans2.text = ""
                img2.contentMode = .scaleAspectFit
                score2.text = "\(scores[i])"
            case 2:
                ans3.text = ""
                img3.contentMode = .scaleAspectFit
                score3.text = "\(scores[i])"
            case 3:
                ans4.text = ""
                img4.contentMode = .scaleAspectFit
                score4.text = "\(scores[i])"
            default:
                ans1.text = "?????"
                img1.contentMode = .scaleAspectFit
                score1.text = "\(scores[i])"
                
            }
            
        }
        
        qheader.text = "Question \(quiz.qIndex + 1)/\(quiz.qCount)"
        qsentence.text = quiz.questions[quiz.qIndex].questionPrompt
        countdown.text = String(COUNTDOWN_TIME)
        startover.isHidden = true
        
        for i in 0..<quiz.choices.count {
            
            switch i {
            case 0:
                choice1.setTitle(quiz.choices[i] + ") " + quiz.questions[quiz.qIndex].choices[quiz.choices[i]]! , for: .normal)
            case 1:
                choice2.setTitle(quiz.choices[i] + ") " + quiz.questions[quiz.qIndex].choices[quiz.choices[i]]! , for: .normal)

            case 2:
                choice3.setTitle(quiz.choices[i] + ") " + quiz.questions[quiz.qIndex].choices[quiz.choices[i]]! , for: .normal)

            case 3:
                choice4.setTitle(quiz.choices[i] + ") " + quiz.questions[quiz.qIndex].choices[quiz.choices[i]]! , for: .normal)

            default:
                choice1.setTitle(quiz.choices[i] + ")???? " + quiz.questions[quiz.qIndex].choices[quiz.choices[i]]! , for: .normal)
            }
            
        }
        
    }
    
   
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        quiz.number = 1
        quiz.qIndex = 0
        
        //  Load JSON data before view is shown
        searchQuizData(quizNumber: quiz.number)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
       // self.session = MCSession(peer: peerID)
        self.browser = MCBrowserViewController(serviceType: "chat", session: session)
        self.assistant = MCAdvertiserAssistant(serviceType: "chat", discoveryInfo: nil, session: session)
        
        //assistant.start()
        session.delegate = self
        //browser.delegate = self
        
        choice1.layer.cornerRadius = 15
        choice1.layer.masksToBounds = true
        choice2.layer.cornerRadius = 15
        choice2.layer.masksToBounds = true
        choice3.layer.cornerRadius = 15
        choice3.layer.masksToBounds = true
        choice4.layer.cornerRadius = 15
        choice4.layer.masksToBounds = true
        
        
        //givePeerID()
        
        print("Players: \(numberOfPlayers)")
        
        myplayer.name = peerID.displayName
        
        print("Session count: \(session.connectedPeers.count)")
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(Multiplayer.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton

        
    }
    
    
    func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        let dataToSend3 =  NSKeyedArchiver.archivedData(withRootObject: msg3)
        do{
            try session.send(dataToSend3, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch let err {
            print("Error in sending data in msg3 \(err)")
        }

        print("Go back!")
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func selectOption(_ sender: UIButton) {
        
        if (sender.tag == 1)
        {
            tappedCount[0] += 1
            
            choice1.isSelected = false
            choice2.isSelected = false
            choice3.isSelected = false
            choice4.isSelected = false
            
            switch tappedCount[0] {
            case 1:
                choice1.backgroundColor = selectColor
                choice2.backgroundColor = defaultColor
                choice3.backgroundColor = defaultColor
                choice4.backgroundColor = defaultColor
                
            case 2:
                
                shouldSubmit(1)
                
            default: break
            }

        }
        else if sender.tag == 2
        {
            tappedCount[1] += 1
            
            choice1.isSelected = false
            choice2.isSelected = false
            choice3.isSelected = false
            choice4.isSelected = false
            
            switch tappedCount[1] {
            case 1:
                choice2.backgroundColor = selectColor
                choice1.backgroundColor = defaultColor
                choice3.backgroundColor = defaultColor
                choice4.backgroundColor = defaultColor
                
            case 2:
                
                shouldSubmit(2)
                
            default: break
            }

        }
        else if sender.tag == 3
        {
            tappedCount[2] += 1
            
            choice1.isSelected = false
            choice2.isSelected = false
            choice3.isSelected = false
            choice4.isSelected = false
            
            switch tappedCount[2] {
            case 1:
                choice3.backgroundColor = selectColor
                choice2.backgroundColor = defaultColor
                choice1.backgroundColor = defaultColor
                choice4.backgroundColor = defaultColor
                
            case 2:
                
                shouldSubmit(3)
                
            default: break
            }

        }
        else if sender.tag == 4
        {
            tappedCount[3] += 1
            
            choice1.isSelected = false
            choice2.isSelected = false
            choice3.isSelected = false
            choice4.isSelected = false
            
            switch tappedCount[3] {
            case 1:
                choice4.backgroundColor = selectColor
                choice2.backgroundColor = defaultColor
                choice3.backgroundColor = defaultColor
                choice1.backgroundColor = defaultColor
                
            case 2:
                
                shouldSubmit(4)
                
            default: break
            }

        }
        else
        {
            print("Error")
        }
        
       
        
    }
    
    
    
    func timeUp(_ selectIndex : Int) {
        
        /* TO-DO: maybe add red text showing user choice if user runs out of time & does not submit (this is assuming his submission would not? get recorded
         let letter = options[selectIndex].currentTitle!.characters.first!
         
         playerVisualChoice[0].text = String(letter)
         playerVisualChoice[0].textColor = UIColor.red
         */
        
        ans1.text = ""
        ans2.text = ""
        ans3.text = ""
        ans4.text = ""
        countdown.text = "Time's up!"
        revealAnswer()
    }
    
    func shouldSubmit(_ selectIndex : Int) {
        
        let letter = choices[selectIndex - 1]
        
        timer.invalidate()
        
        
        switch selectIndex
        {
        case 1:
            choice1.backgroundColor = submitColor
        case 2:
            choice2.backgroundColor = submitColor
        case 3:
            choice3.backgroundColor = submitColor
        case 4:
            choice4.backgroundColor = submitColor
        default:
            print("Error in submitted answer")
        }
        
        
        // NOTE: this will only set player 1's speech overhead.
        // Need to loop through all players inside this func
        ans1.text = String(letter)
        myplayer.Ans = ans1.text!
        
        choice1.isUserInteractionEnabled = false
        choice2.isUserInteractionEnabled = false
        choice3.isUserInteractionEnabled = false
        choice4.isUserInteractionEnabled = false
        
        if (String(letter) == quiz.questions[quiz.qIndex].answer) {
            countdown.text = "Nice Job!"
            
            // Determine which player was correct ?
            scores[0] += 1
            myplayer.score = scores[0]
            
            //for i in 0 ..< maxPlayers {
                //score1.text = "\(scores[1])"
                score1.text = "\(scores[0])"
                score2.text = "\(scores[1])"
                score3.text = "\(scores[2])"
                score4.text = "\(scores[3])"
            //}
        }
        else {
            countdown.text = "Incorrect!"
        }
        
        
        let obj :  [String: String] = ["name": "\(myplayer.name)", "score": "\(myplayer.score)", "ans": "\(myplayer.Ans)"]
        
        
        
        let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: obj)
        
        do{
            try session.send(dataToSend, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch let err {
            print("Error in sending data \(err)")
        }
        
        var count = 0
        
        for i in 0..<answers.count
        {
            if answers[i] != ""
            {
                count += 1
            }
        }
        
        if count == session.connectedPeers.count && (ans1.text != "")
        {
            
            let dataToSend1 =  NSKeyedArchiver.archivedData(withRootObject: msg1)
            do{
                try session.send(dataToSend1, toPeers: session.connectedPeers, with: .unreliable)
            }
            catch let err {
                print("Error in sending data in msg1 \(err)")
            }
            
            revealAnswer()
        }
    }

    
    @IBAction func restartQuiz(_ sender: Any) {
        
        let dataToSend2 =  NSKeyedArchiver.archivedData(withRootObject: msg2)
        do{
            try session.send(dataToSend2, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch let err {
            print("Error in sending data in msg2 \(err)")
        }

        
        startover.isHidden = true
        quiz.number += 1
        
        for i in 0 ..< maxPlayers {
            scores[i] = 0
        }
        
        DispatchQueue.main.async(){
            self.searchQuizData(quizNumber: self.quiz.number)
        }
    }
    
    
    func revealAnswer()
    {
        // perhaps setup as a timer instead ?
        
        switch (quiz.choices.index(of: quiz.questions[quiz.qIndex].answer)!) {
        case 0:
            choice1.backgroundColor = revealColor
        case 1:
            choice2.backgroundColor = revealColor
        case 2:
            choice3.backgroundColor = revealColor
        case 3:
            choice4.backgroundColor = revealColor
        default:
            choice1.backgroundColor = selectColor
        }
        
        
        let when = DispatchTime.now() + 3
        
        for i in 0..<session.connectedPeers.count
        {
            switch i
            {
             case 0:
                self.score2.text = "\(self.scores[1])"
                self.ans2.text = self.answers[0]
            case 1:
                self.score3.text = "\(self.scores[2])"
                self.ans3.text = self.answers[1]
            case 2:
                self.score4.text = "\(self.scores[3])"
                self.ans4.text = self.answers[2]
            default:
                print("Error in Revealing Peer Answer & score")
            }
        }
            
        
        quiz.qIndex += 1
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            
            if self.quiz.qIndex == self.quiz.qCount {   // End quiz
                self.quiz.qIndex = 0
                
                let playerScore = self.scores[0]  // Assume player one
                //  Determine the winner (if there is any)
                self.scores.sort(by: {$0 > $1})
                
                if playerScore == self.scores.first! {  //Satisfies predicate for a win-draw scenario
                    if self.scores[0] == self.scores[1] {
                        self.countdown.text = "You tied !"
                    }
                    else {
                        self.countdown.text = "You WON !"
                    }
                }
                else {
                    self.countdown.text = "You lost."
                }
                
                self.startover.isHidden = false
                
            }
            else {
                self.initialize()
            }
        }
        
    }
    
   

    

    
    func quizTimer() {
        
        timeInSeconds += 1
        countdown.text = String(COUNTDOWN_TIME - timeInSeconds)
        
        
        if timeInSeconds == COUNTDOWN_TIME {
            timer.invalidate()
            timeUp(0)
        }
    }
    

    
    
    
    
    @IBAction func connect(_ sender: UIButton) {
        
        present(browser, animated: true, completion: nil)
        
    }
    
    
    //**********************************************************
    // required functions for MCBrowserViewControllerDelegate
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        // Called when the browser view controller is dismissed
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        // Called when the browser view controller is cancelled
        dismiss(animated: true, completion: nil)
    }
    //**********************************************************
    
    
    
    
    //**********************************************************
    // required functions for MCSessionDelegate
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        // this needs to be run on the main thread
        DispatchQueue.main.async(execute: {
            
            
            
            let receivedPlayer = NSKeyedUnarchiver.unarchiveObject(with: data) as? Dictionary<String,String>
            
            
            if receivedPlayer?["name"] == self.gameplayers[1].name
            {
                 self.num = receivedPlayer!["score"]!
                 self.answers[0] = receivedPlayer!["ans"]!
                
                self.scores[1] = Int(self.num)!
                //self.score2.text = "\(self.scores[1])"
                //self.ans2.text = self.answer
                print("Player: \(receivedPlayer!["name"]), Score: \(receivedPlayer?["score"]), Ans: \(receivedPlayer?["ans"])")
            }
            else if receivedPlayer?["name"] == self.gameplayers[2].name
            {
                self.num = receivedPlayer!["score"]!
                self.answers[1] = receivedPlayer!["ans"]!
                
                self.scores[2] = Int(self.num)!
                //self.score3.text = "\(self.scores[2])"
                //self.ans3.text = self.answer
                print("Player: \(receivedPlayer!["name"]), Score: \(receivedPlayer?["score"]), Ans: \(receivedPlayer?["ans"])")
            }
            else if receivedPlayer?["name"] == self.gameplayers[3].name
            {
                self.num = receivedPlayer!["score"]!
                self.answers[2] = receivedPlayer!["ans"]!
                
                self.scores[3] = Int(self.num)!
                //self.score3.text = "\(self.scores[3])"
                //self.ans3.text = self.answer
                print("Player: \(receivedPlayer!["name"]), Score: \(receivedPlayer?["score"]), Ans: \(receivedPlayer?["ans"])")
            }
            else
            {
                print("Player Score not recorded")
            }

            let ReceivedMessage = NSKeyedUnarchiver.unarchiveObject(with: data) as? String
            
            if ReceivedMessage == self.msg1
            {
                self.revealAnswer()
            }
            
            if ReceivedMessage == self.msg2
            {
                self.startover.isHidden = true
                self.quiz.number += 1
                
                for i in 0 ..< self.maxPlayers {
                    self.scores[i] = 0
                }
                
                DispatchQueue.main.async(){
                    self.searchQuizData(quizNumber: self.quiz.number)
                }

            }
            
            if ReceivedMessage == self.msg3
            {
                _ = self.navigationController?.popViewController(animated: true)
            }

          
            
            
        })
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        // Called when a connected peer changes state (for example, goes offline)
        
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
        
    }
    //**********************************************************
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
    }
    func searchQuizData(quizNumber: Int) {
        
        let quizUrl = URL(string: "http://www.people.vcu.edu/~ebulut/jsonFiles/quiz\(quizNumber).json")!
        let request = URLRequest(url: quizUrl)
        let session = URLSession.shared
        let STATUS_OK = 200
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            let httpResponse = response as? HTTPURLResponse
            let statusCode = httpResponse?.statusCode
            
            
            if let Error = error {
                print("An error occurred: \(Error)")
                return
            }
                
            else if statusCode! != STATUS_OK { // Status code != OK can happen for any number of reasons, chief among them is the 404 (Not Found) error, in which we rollback to Quiz 1 (default)
                DispatchQueue.main.async {
                    self.quiz.number = 1
                    self.searchQuizData(quizNumber: self.quiz.number)
                }
                return
            }
            
            
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                
                DispatchQueue.main.async() {
                    self.parseQuizData(jsonResult)
                    self.setUp()
                    
                    return
                }
            }
                
            catch let err {
                print(err.localizedDescription)
            }
            // Close the dataTask block, and call resume() in order to make it run immediately
        }
        
        task.resume()
    }
    
    func setUp(){
        initialize()
        quiz.qIndex = 0
        
        qheader.text = "Question \(quiz.qIndex + 1)/\(quiz.qCount)"
        qsentence.text = quiz.questions[quiz.qIndex].questionPrompt
        
        let multipleChoices = ["A", "B", "C", "D"]
        for i in 0..<multipleChoices.count {
            
            switch i {
            case 0:
                choice1.setTitle(multipleChoices[i] + ") " + quiz.questions[quiz.qIndex].choices[multipleChoices[i]]! , for: .normal)
            case 1:
                choice2.setTitle(multipleChoices[i] + ") " + quiz.questions[quiz.qIndex].choices[multipleChoices[i]]! , for: .normal)
            case 2:
                choice3.setTitle(multipleChoices[i] + ") " + quiz.questions[quiz.qIndex].choices[multipleChoices[i]]! , for: .normal)
            case 3:
                choice4.setTitle(multipleChoices[i] + ") " + quiz.questions[quiz.qIndex].choices[multipleChoices[i]]! , for: .normal)
            default:
                choice1.setTitle(multipleChoices[i] + ")???? " + quiz.questions[quiz.qIndex].choices[multipleChoices[i]]! , for: .normal)
            }
            
            
        }
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    func parseQuizData(_ quizData: [String: Any]) {
        // Make sure the results are in the expected format of [String: Any]
        guard let quizQuestions = quizData["questions"] as? [[String: Any]],
            let questionsCount = quizData["numberOfQuestions"] as? Int,
            let quizTopic = quizData["topic"] as? String
            else {
                print("Could not process search results...")
                return
        }
        
        
        // Create a temporary place to add the new list of app details to
        var questions = [QuizQuestion]()
        
        // Loop through all the results...
        for question in quizQuestions {
            questions.append(QuizQuestion(json: question)!)
        }
        
        quiz.questions = questions
        quiz.qCount = questionsCount
        quiz.topic = quizTopic
        
    }


    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

class my_player : NSObject, NSCoding {
    var score = 0             //Text address to send to
    var ans: String = ""        //Message to be sent
    var name: String = ""             //Number of hours between messages (usually a multiple of 24 - 24 = daily)
    
    
    init(score: Int, ans: String, name: String){
        
        self.score = score
        self.ans = ans
        self.name = name
        
        }
    
    required init?(coder aDecoder: NSCoder) {
        score = aDecoder.decodeInteger(forKey: "score")
        ans = aDecoder.decodeObject(forKey: "answer") as! String
        name = aDecoder.decodeObject(forKey: "name") as! String

    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(score, forKey: "score")
        aCoder.encode(ans, forKey: "answer")
        aCoder.encode(name, forKey: "name")
        
    }
}
