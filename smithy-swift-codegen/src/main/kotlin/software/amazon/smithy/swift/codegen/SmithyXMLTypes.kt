/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0.
 */
package software.amazon.smithy.swift.codegen

import software.amazon.smithy.codegen.core.Symbol
import software.amazon.smithy.swift.codegen.model.buildSymbol

object SmithyXMLTypes {
    val XMLReadWrite = runtimeSymbol("XMLReadWrite")
    val Writer = runtimeSymbol("Writer")
    val Reader = runtimeSymbol("Reader")
}

private fun runtimeSymbol(name: String): Symbol = buildSymbol {
    this.name = name
    this.namespace = SwiftDependency.SMITHY_XML.target
    dependency(SwiftDependency.SMITHY_XML)
}
