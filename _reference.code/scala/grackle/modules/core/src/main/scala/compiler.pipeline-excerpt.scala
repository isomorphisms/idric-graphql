// Reference excerpt from upstream modules/core/src/main/scala/compiler.scala.
// Modified only by truncation to the QueryCompiler pipeline; see _reference.code/SOURCES.tsv.
// Copyright (c) 2016-2025 Association of Universities for Research in Astronomy, Inc. (AURA)
// Copyright (c) 2016-2025 Grackle Contributors
// Licensed under the Apache License, Version 2.0.

package grackle

import io.circe.Json
import grackle.QueryCompiler._

/**
 * GraphQL query compiler.
 *
 * A QueryCompiler parses GraphQL queries to query algebra terms, then applies a collection of
 * transformation phases in sequence, yielding a query algebra term which can be directly
 * interpreted.
 */
class QueryCompiler(parser: QueryParser, schema: Schema, phases: List[Phase]) {
  import IntrospectionLevel._

  /**
   * Compiles the GraphQL query `text` to a query algebra term which can be directly executed.
   *
   * GraphQL errors and warnings are accumulated in the result.
   */
  def compile(
      text: String,
      name: Option[String] = None,
      untypedVars: Option[Json] = None,
      introspectionLevel: IntrospectionLevel = Full,
      reportUnused: Boolean = true,
      env: Env = Env.empty): Result[Operation] =
    parser.parseText(text).flatMap {
      case (ops, frags) =>
        for {
          _ <- Result.fromProblems(validateVariablesAndFragments(ops, frags, reportUnused))
          _ <- Result.fromProblems(validateFieldMergeability(ops, frags))
          ops0 <- ops.traverse(op =>
            compileOperation(op, untypedVars, frags, introspectionLevel, env)
              .map(op0 => (op.name, op0)))
          res <- (ops0, name) match {
            case (List((_, op)), None) =>
              op.success
            case (Nil, _) =>
              Result.failure("At least one operation required")
            case (_, None) =>
              Result.failure("Operation name required to select unique operation")
            case (ops, _) if ops.lengthCompare(1) > 0 && ops.exists(_._1.isEmpty) =>
              Result.failure("Query shorthand cannot be combined with multiple operations")
            case (ops, on @ Some(name)) =>
              ops.filter(_._1 == on) match {
                case List((_, op)) =>
                  op.success
                case Nil =>
                  Result.failure(s"No operation named '$name'")
                case _ =>
                  Result.failure(s"Multiple operations named '$name'")
              }
          }
        } yield res
    }

  /**
   * Compiles the provided operation AST to a query algebra term which can be directly executed.
   *
   * GraphQL errors and warnings are accumulated in the result.
   */
  def compileOperation(
      op: UntypedOperation,
      untypedVars: Option[Json],
      frags: List[UntypedFragment],
      introspectionLevel: IntrospectionLevel = Full,
      env: Env = Env.empty): Result[Operation] = {
    val allPhases =
      IntrospectionElaborator(
        introspectionLevel).toList ++ (VariablesSkipAndFragmentElaborator :: MergeFields :: phases)

    for {
      varDefs <- compileVarDefs(op.variables)
      vars <- compileVars(varDefs, untypedVars)
      _ <- Directive.validateDirectivesForQuery(schema, op, frags, vars)
      rootTpe <- op.rootTpe(schema)
      _ <- VariableUsage.validateVariableUsages(schema, rootTpe, op, frags, varDefs)
      res <- (
        for {
          query <- allPhases.foldLeftM(op.query) { (acc, phase) =>
            phase.transformFragments *> phase.transform(acc)
          }
        } yield Operation(query, rootTpe, op.directives)
      ).runA(
        ElabState(
          None,
          schema,
          Context(rootTpe),
          vars,
          frags.map(f => (f.name, f)).toMap,
          op.query,
          env,
          List.empty,
          Elab.pure
        )
      )
    } yield res
  }
}
