/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0.
 */

package software.amazon.smithy.swift.codegen.integration.serde

import software.amazon.smithy.aws.traits.protocols.RestXmlTrait
import software.amazon.smithy.model.shapes.MemberShape
import software.amazon.smithy.model.shapes.Shape
import software.amazon.smithy.model.traits.TimestampFormatTrait
import software.amazon.smithy.swift.codegen.SwiftWriter
import software.amazon.smithy.swift.codegen.integration.ProtocolGenerator
import software.amazon.smithy.swift.codegen.integration.serde.json.UnionDecodeGenerator
import software.amazon.smithy.swift.codegen.integration.serde.xml.UnionDecodeXMLGenerator

class UnionDecodeGeneratorStrategy(
    private val ctx: ProtocolGenerator.GenerationContext,
    private val shapeContainingMembers: Shape,
    private val members: List<MemberShape>,
    private val writer: SwiftWriter,
    private val defaultTimestampFormat: TimestampFormatTrait.Format
) {
    fun render() {
        when (ctx.protocol) {
            RestXmlTrait.ID -> {
                UnionDecodeXMLGenerator(ctx, shapeContainingMembers, members, writer, defaultTimestampFormat).render()
            }
            else -> {
                UnionDecodeGenerator(ctx, members, writer, defaultTimestampFormat).render()
            }
        }
    }
}
