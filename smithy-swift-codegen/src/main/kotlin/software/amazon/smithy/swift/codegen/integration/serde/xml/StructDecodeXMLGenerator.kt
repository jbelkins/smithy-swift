/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0.
 */

package software.amazon.smithy.swift.codegen.integration.serde.xml

import software.amazon.smithy.aws.traits.customizations.S3UnwrappedXmlOutputTrait
import software.amazon.smithy.model.shapes.BlobShape
import software.amazon.smithy.model.shapes.CollectionShape
import software.amazon.smithy.model.shapes.MapShape
import software.amazon.smithy.model.shapes.MemberShape
import software.amazon.smithy.model.shapes.OperationShape
import software.amazon.smithy.model.shapes.Shape
import software.amazon.smithy.model.shapes.TimestampShape
import software.amazon.smithy.model.traits.TimestampFormatTrait
import software.amazon.smithy.swift.codegen.SmithyXMLTypes
import software.amazon.smithy.swift.codegen.SwiftDependency
import software.amazon.smithy.swift.codegen.SwiftTypes
import software.amazon.smithy.swift.codegen.SwiftWriter
import software.amazon.smithy.swift.codegen.integration.ProtocolGenerator
import software.amazon.smithy.swift.codegen.integration.serde.MemberShapeDecodeGeneratable
import software.amazon.smithy.swift.codegen.model.ShapeMetadata
import software.amazon.smithy.swift.codegen.model.hasTrait

open class StructDecodeXMLGenerator(
    private val ctx: ProtocolGenerator.GenerationContext,
    private val shapeContainingMembers: Shape,
    private val members: List<MemberShape>,
    private val metadata: Map<ShapeMetadata, Any>,
    private val writer: SwiftWriter,
    private val defaultTimestampFormat: TimestampFormatTrait.Format
) : MemberShapeDecodeGeneratable {
    private val memberGenerator = MemberShapeDecodeXMLGenerator(ctx, writer, defaultTimestampFormat)

    override fun render() {
        writer.addImport(SwiftDependency.SMITHY_XML.target)
        val symbol = ctx.symbolProvider.toSymbol(shapeContainingMembers)
        writer.openBlock(
            "static func readingClosure(from reader: \$N) throws -> \$N {", "}",
            SmithyXMLTypes.Reader,
            symbol
        ) {
            if (members.isEmpty()) {
                writer.write("return \$N()", symbol)
            } else {
                writer.write("var value = \$N()", symbol)
                if (isUnwrapped){
                    writer.write("let reader = reader.parent ?? reader")
                }
                members.forEach { memberGenerator.render(it, false) }
                writer.write("return value")
            }
        }
    }

    private val isUnwrapped: Boolean =
        (metadata[ShapeMetadata.OPERATION_SHAPE] as? OperationShape)?.hasTrait<S3UnwrappedXmlOutputTrait>() ?: false
}
