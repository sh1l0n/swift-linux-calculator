// import Foundation

// // sudo apt-get install gobjc gnustep gnustep-devel

// class Stream<T> {
//     init(controller: StreamController<T>) {
//         self.controller = controller
//     }
//     weak var controller: StreamController<T>?

//     @obj
//     func listen(observer: Any, selector: @escaping (_:Any)->Void) {
//         controller?.listen(observer: observer, callback: selector)
//     }

//     func remove(observer: Any) {
//         controller?.remove(observer: observer)
//     }
// }

// class Sink<T> {
//     init(controller: StreamController<T>) {
//         self.controller = controller
//     }
//     weak var controller: StreamController<T>?

//     func add(message: T) {
//         controller?.post(object: message)
//     }
// }

// class StreamController<T> {
//     init(id: Notification.Name, notificationCenter: NotificationCenter) {
//         self.id = id
//         self.notificationCenter = notificationCenter
//     }
    
//     var id: Notification.Name
//     var notificationCenter: NotificationCenter

//     var sink: Sink<T> {
//         return Sink(controller: self)
//     }

//     // var stream: Stream {
//     //     return Stream(controller: self)
//     // }

//     func post(object: T?) {
//         notificationCenter.post(name: self.id, object: object)
//     }

//     func listen(observer: Any, callback: @escaping (_:Any)->Void) {
//         notificationCenter.addObserver(observer,
//             selector: #selector(callback),
//             name: self.id,
//             object: nil
//         )
//     }

//     func remove(observer: Any) {
//         notificationCenter.removeObserver(observer,
//             name: self.id,
//             object: nil
//         )
//     }

//     func dispose() {
//         // ##TODO: remove all observers
//     }
// }