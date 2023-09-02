import Cocoa

class ClipboardMonitor {
    let pasteboard = NSPasteboard.general
    var changeCount = NSPasteboard.general.changeCount
    var previous1 = ""
    var previous2 = ""

    init() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            checkClipboardChange()
        }
    }

    func checkClipboardChange() {
        let newChangeCount = pasteboard.changeCount
        if newChangeCount != changeCount {
            changeCount = newChangeCount
            if let content = getClipboardContent() {
                if previous1.trimmingCharacters(in: .whitespacesAndNewlines) == content.trimmingCharacters(in: .whitespacesAndNewlines) || previous2.trimmingCharacters(in: .whitespacesAndNewlines) == content.trimmingCharacters(in: .whitespacesAndNewlines) || content.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return
                }
                print("\u{001B}[31;1m--------------------Clipboard you copied--------------------\u{001B}[0m")
                print("\u{001B}[32m\(content)\u{001B}[0m")
                print("------------------------------------------------------------")
                previous2 = previous1
                previous1 = content

            }
        }
    }

    func getClipboardContent() -> String? {
        return pasteboard.string(forType: .string)
    }
}

let _ = ClipboardMonitor()
RunLoop.current.run()
