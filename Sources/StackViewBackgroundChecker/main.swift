import Foundation

print("start")
let filepaths = ProcessInfo.processInfo.arguments[1...]
do {
    try filepaths.map(Runner.init(filepath:)).forEach{ try $0.run() }
} catch {
    fatalError(error.localizedDescription)
}
print("end")
