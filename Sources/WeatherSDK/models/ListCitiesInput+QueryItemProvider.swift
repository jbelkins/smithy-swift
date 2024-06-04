// Code generated by smithy-swift-codegen. DO NOT EDIT!

import ClientRuntime
import Smithy
import SmithyHTTPAPI

extension ListCitiesInput {

    static func queryItemProvider(_ value: ListCitiesInput) throws -> [Smithy.URIQueryItem] {
        var items = [Smithy.URIQueryItem]()
        if let nextToken = value.nextToken {
            let nextTokenQueryItem = Smithy.URIQueryItem(name: "nextToken".urlPercentEncoding(), value: Swift.String(nextToken).urlPercentEncoding())
            items.append(nextTokenQueryItem)
        }
        if let pageSize = value.pageSize {
            let pageSizeQueryItem = Smithy.URIQueryItem(name: "pageSize".urlPercentEncoding(), value: Swift.String(pageSize).urlPercentEncoding())
            items.append(pageSizeQueryItem)
        }
        return items
    }
}
