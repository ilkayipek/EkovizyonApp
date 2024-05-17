//
//  ScoresViewModel.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 16.05.2024.
//

import Foundation

class ScoresViewModel: BaseViewModel {
    
    func getScores(_ closure: @escaping([PointDetail]?) -> Void) {
        let collectionStr = FirebaseCollections.pointDetails.rawValue
        let network = Network.shared
        let collection = network.database.collection(collectionStr)
        let query = collection.order(by: "totalScore", descending: true).limit(to: 20)
        
        gradientLoagingTabAnimation?.startAnimations()
        
        network.getMany(of: PointDetail.self, with: query) {[weak self] (result:Result<[PointDetail], any Error>) in
            guard let self else {closure(nil); return}
            
            switch result {
            case .success(let data):
                
                guard !data.isEmpty else {closure(nil); return}
                
                self.getScoresUsers(scores: data) { newData in
                    closure(newData)
                }
                
            case .failure(let error):
                print("ERROR: \(error.localizedDescription)")
                closure(nil)
            }
            
            self.gradientLoagingTabAnimation?.stopAnimations()
        }
    }
    
    private func getScoresUsers(scores: [PointDetail],_ closure: @escaping([PointDetail]) -> Void) {
        
        var newScores = [PointDetail]()
        let dispatchGroup = DispatchGroup()
        
        for score in scores {
            
            dispatchGroup.enter()
            var newScore =  score
            
            guard let userRef = score.userRef else {
                dispatchGroup.leave()
                continue
            }
            
            Network.shared.getDocument(reference: userRef) {[weak self] (result: Result<UserModel, any Error>) in
                guard let self else {return}
                
                switch result {
                case .success(let user):
                    newScore.userModel = user
                    newScores.append(newScore)
                case .failure(let error):
                    print("\n Error: \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            let sortedScores = newScores.sorted(by: {$0.totalScore > $1.totalScore})
            closure(sortedScores)
        }
    }
    
}
