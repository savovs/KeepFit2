import CoreData

public class Persistence {
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "KeepFit")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved persistence error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static func saveContext () {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Error saving context \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    static func addGoal(name: String, target: Int16) -> Goal {
        let goal = Goal(context: context)

        goal.name = name
        goal.target = target
        goal.tracked = true
        
        Persistence.saveContext()
        
        return goal
    }
    
    static func getGoals() -> [Goal] {
        let request = NSFetchRequest<Goal>(entityName: "Goal")

        do {
            return try(context.fetch(request)) as [Goal]
        } catch let err {
            print(err)
        }
        
        return [Goal]()
    }
    
    static func getTrackedGoal() -> Goal? {
        let request = NSFetchRequest<Goal>(entityName: "Goal")
        request.predicate = NSPredicate(format: "tracked == %@", true as CVarArg)
        
        do {
            let goals = try(context.fetch(request)) as [Goal]

            if (goals.count > 0) {
                return goals[0]
            }

            return nil
        } catch let err {
            print(err)
        }
        
        return nil
    }
    
    static func addHistoryAction(type: HistoryAction.type, goal: Goal, amount: Int16 = 0) -> HistoryAction {
        let action = HistoryAction(context: context)
        let steps = "\(goal.current) / \(goal.target)"
        
        let texts: [HistoryAction.type: String] = [
            .set: "Set a goal \(steps)",
            .track: "Started tracking \(steps)",
            .update: "Updated \(steps)",
            .add: "Making +\(amount) progress \(steps)",
            .subtract: "Walking -\(amount) backwards \(steps)",
            .delete: "Deleted \(steps)",
            .complete: "Yay, completed \(steps)"
        ]
        
        action.text = texts[type] ?? ""
        action.typeString = type.rawValue
        action.date = NSDate()
        
        saveContext()
        
        return action
    }
    
    static func getHistoryActions() -> [HistoryAction] {
        let request = NSFetchRequest<HistoryAction>(entityName: "HistoryAction")
        
        do {
            return try(context.fetch(request)) as [HistoryAction]
        } catch let err {
            print(err)
        }
        
        return [HistoryAction]()
    }
    
    static func delete(object: NSManagedObject) {
        context.delete(object)
        saveContext()
    }
    
    static func clearHistory() {
        let actions = getHistoryActions()
        actions.forEach { context.delete($0) }
        
        saveContext()
    }
}

