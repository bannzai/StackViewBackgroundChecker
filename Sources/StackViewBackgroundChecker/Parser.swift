import Foundation

enum ParserError: Swift.Error {
    case xmlParseError(url: URL)
}

struct Node {
    let level: Int
}

class Runner: NSObject {
    let parser: XMLParser
    let url: URL
    init(filepath: String) throws {
        self.url = URL(fileURLWithPath: filepath)
        guard let parser = XMLParser(contentsOf: url) else {
            throw ParserError.xmlParseError(url: url)
        }
        self.parser = parser
        
        super.init()
        parser.delegate = self
    }
    
    func run() throws {
        if !parser.parse() {
            throw ParserError.xmlParseError(url: url)
        }
    }
    
    var level: Int = 0
    var stackViewNodeList: [Node] = []
}

extension Runner: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        level += 1
        if elementName == "stackView" {
            stackViewNodeList.append(.init(level: level))
            return
        }
        let isStackViewChild = stackViewNodeList.contains(where: { ($0.level + 1) == level })
        if isStackViewChild {
            if elementName == "color" {
                print("\(url) has background color attributes for stackView. level is \(level)")
            }
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        level -= 1
        stackViewNodeList = stackViewNodeList.filter { $0.level <= level }
    }
}
