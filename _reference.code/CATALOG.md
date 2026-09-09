# Typed functional GraphQL reference catalog

Research pass: 2026-09-09

This is a design corpus for Idriç, not a dependency list.  The inclusion test is deliberately broad: a project is included when a strongly typed functional language is doing substantial GraphQL work in the parser/schema/query/client/server layer.  Historical implementations are included because type encodings remain useful even when packages are no longer maintained.

`_reference.code/` must preserve upstream license and provenance.  Presence here does not imply that the Idriç implementation should copy an upstream architecture literally.

## Haskell

### morpheusgraphql/morpheus-graphql

- URL: https://github.com/morpheusgraphql/morpheus-graphql
- Role: GraphQL API, server, client, parser, code generation and tools.
- Type idea: schema and operation documents become Haskell types; client queries are checked against the schema and generate typed variables/results.
- License: MIT.
- Status: active in 2026.
- Priority for Idriç: very high, especially the client/code-generation path.

### brandonchinn178/graphql-client

- URL: https://github.com/brandonchinn178/graphql-client
- Role: Haskell GraphQL client and code generator.
- Type idea: `.graphql` operations generate Haskell request/response definitions and execute through a typed client interface.
- Priority for Idriç: very high.

### haskell-graphql/graphql-api

- URL: https://github.com/haskell-graphql/graphql-api
- Role: type-safe GraphQL service DSL.
- Type idea: schema combinators live at the Haskell type level and determine handler types, in the style of Servant.
- Status: historical/inactive but unusually relevant to dependent/type-level design.
- Priority for Idriç: high as a type-encoding reference.

### higherkindness/mu-haskell / mu-graphql

- URL: https://github.com/higherkindness/mu-haskell
- Role: typed service framework with GraphQL support, including schema/client/server integration.
- Type idea: service descriptions generate/drive strongly typed endpoints and GraphQL schemas.
- Priority for Idriç: medium-high.

### haskell-servant/servant-graphql

- URL: https://github.com/haskell-servant/servant-graphql
- Role: small GraphQL/Servant integration experiment.
- Type idea: reuses a type-level web API DSL rather than introducing an untyped request layer.
- License: BSD-3-Clause.
- Status: historical; only a few commits, therefore useful as a small readable specimen.

### dmjio/graphql-meta

- URL: https://github.com/dmjio/graphql-meta
- Role: Haskell GraphQL implementation/schema work.
- Status: historical.
- Priority for Idriç: medium; retain chiefly to compare schema representations.

### JonathanLorimer/weft

- URL: https://github.com/JonathanLorimer/weft
- Role: experimental Haskell GraphQL implementation.
- Type idea: derives GraphQL structure from Haskell types/HKD-style encodings.
- Status: experimental/historical.
- Priority for Idriç: medium-high as an unusual type-design specimen.

### caraus/graphql

- URL: https://git.caraus.tech/OSS/graphql
- Role: GraphQL parser, schema/type system, validation and execution in Haskell.
- License: MPL-2.0 AND BSD-3-Clause.
- Status: active releases in 2026.
- Priority for Idriç: high for parser/validation separation.

### caraus/graphql-spice

- URL: https://git.caraus.tech/OSS/graphql-spice
- Role: convenience/extensions layer around the Haskell `graphql` package.
- Status: active releases in 2026.
- Priority for Idriç: medium.

### jasonsychau/graphql-w-persistent

- URL: https://github.com/jasonsychau/graphql-w-persistent
- Role: GraphQL interface middleware over Persistent/SQL-backed Haskell data.
- Status: historical.
- Priority for Idriç: low for the initial client, useful server-side comparison.

## PureScript

### OxfordAbstracts/purescript-graphql-client

- URL: https://github.com/OxfordAbstracts/purescript-graphql-client
- Role: type-safe GraphQL client with schema generation, subscriptions and caching hooks.
- Type idea: PureScript record/query types constrain legal fields, arguments and decoded responses.
- Priority for Idriç: very high; relatively direct functional client design.

### rowtype-yoga/purescript-graphql-fundeps

- URL: https://github.com/rowtype-yoga/purescript-graphql-fundeps
- Role: lightweight type-safe GraphQL client.
- Type idea: functional dependencies connect GraphQL selections to result types without a large generated client layer.
- Priority for Idriç: very high because it deliberately keeps the implementation small.

### purescript-graphqlclient/purescript-graphqlclient

- URL: https://github.com/purescript-graphqlclient/purescript-graphqlclient
- Role: typed GraphQL client, influenced by/ported from `elm-graphql`.
- Type idea: applicative construction of selections while preserving response types.
- Priority for Idriç: high.

### hendrikniemann/purescript-graphql

- URL: https://github.com/hendrikniemann/purescript-graphql
- Role: end-to-end type-safe GraphQL server implementation/DSL.
- License: MIT.
- Type idea: PureScript types constrain schema fields, resolver arguments and result types.
- Priority for Idriç: high for server/schema type encodings; less directly useful for the first Indeed client.

### rowtype-yoga/purescript-prospero

- URL: https://github.com/rowtype-yoga/purescript-prospero
- Role: newer type-safe GraphQL server library.
- Type idea: PureScript's type system rejects most schema/resolver mismatches at compile time.
- Status: newly visible in the 2026 ecosystem.
- Priority for Idriç: high as a modern small type-safe server design.

## Elm

### dillonkearns/elm-graphql

- URL: https://github.com/dillonkearns/elm-graphql
- Role: schema-driven typed GraphQL client/code generator.
- License: BSD-3-Clause.
- Type idea: generated Elm modules make invalid field/argument selections difficult or impossible to express and generate response decoders from the same selection.
- Priority for Idriç: very high.

### jamesmacaulay/elm-graphql

- URL: https://github.com/jamesmacaulay/elm-graphql
- Role: earlier typed GraphQL query-building library for Elm.
- Status: historical.
- Priority for Idriç: medium-high for comparison with the later code-generation approach.

### jahewson/elm-graphql

- URL: https://github.com/jahewson/elm-graphql
- Role: historical command-line generator producing Elm code from `.graphql` queries.
- Status: historical.
- Priority for Idriç: medium.

### M1chaelTran/elm-graphql

- URL: https://github.com/M1chaelTran/elm-graphql
- Role: early/WIP GraphQL client work in Elm.
- Status: historical/experimental.
- Priority for Idriç: low-medium; catalogued so early approaches are not rediscovered blindly.

## OCaml / Reason / ReScript

### andreas/ocaml-graphql-server

- URL: https://github.com/andreas/ocaml-graphql-server
- Role: GraphQL schema, parsing, execution, introspection and subscriptions in OCaml.
- License: MIT.
- Type idea: typed OCaml schema construction ties resolvers to declared GraphQL field types.
- Priority for Idriç: very high because the implementation is ML-shaped and comparatively direct.

### teamwalnut/graphql-ppx

- URL: https://github.com/teamwalnut/graphql-ppx
- Genealogy: `reasonml-community/graphql-ppx` / earlier `mhallin/graphql_ppx` work.
- Role: GraphQL PPX/code generation for ReScript/Reason/OCaml-family code.
- Type idea: schema + operation documents produce statically typed variables and response values.
- Priority for Idriç: high for compiler/codegen architecture.

### hansole/graphql_jsoo_client

- URL: https://github.com/hansole/graphql_jsoo_client
- Role: OCaml GraphQL-over-WebSocket/browser client.
- License: MIT.
- Priority for Idriç: low-medium; useful for subscription transport rather than first-pass query typing.

### sainthkh/reasonql

- URL: https://github.com/sainthkh/reasonql
- Role: small type-safe GraphQL client for ReasonML.
- License: MIT.
- Priority for Idriç: high specifically because it is small.

### zth/rescript-relay

- URL: https://github.com/zth/rescript-relay
- Role: typed ReScript integration/code generation for Relay GraphQL clients.
- Type idea: Relay compiler artifacts are surfaced as native ReScript operation/result types.
- Priority for Idriç: medium-high for industrial codegen patterns, although Relay itself is much larger than the intended Idriç first pass.

## F#

### fsprojects/FSharp.Data.GraphQL

- URL: https://github.com/fsprojects/FSharp.Data.GraphQL
- Role: GraphQL server and client for F#.
- License: MIT.
- Type idea: the client type provider introspects a schema and supplies statically typed queries/results.
- Status: client releases continued into 2026.
- Priority for Idriç: very high; one of the clearest examples of schema-to-native-type generation.

### Zaid-Ajaj/Snowflaqe

- URL: https://github.com/Zaid-Ajaj/Snowflaqe
- Role: CLI generator for type-safe F#/Fable GraphQL clients.
- Type idea: operation documents are checked/generated into F# request and response types with static decoding.
- Priority for Idriç: very high for a command-line schema/query compiler model.

## Scala (functional / type-heavy)

### ghostdogpr/caliban

- URL: https://github.com/ghostdogpr/caliban
- Role: purely functional Scala GraphQL server and client, with `caliban-client` code generation/DSL.
- License: Apache-2.0.
- Type idea: schema derivation and client code generation preserve Scala types across GraphQL boundaries.
- Priority for Idriç: very high.

### typelevel/grackle

- URL: https://github.com/typelevel/grackle
- Role: functional GraphQL query compiler/interpreter/server for the Typelevel stack.
- License: Apache-2.0.
- Type idea: query compilation/type checking is explicit and separated from interpretation/execution.
- Priority for Idriç: very high for a compiler-shaped architecture.

### valdemargr/gql

- URL: https://github.com/valdemargr/gql
- Role: functional Scala GraphQL implementation with server, client and client code generation.
- License: Apache-2.0.
- Priority for Idriç: high.

### sangria-graphql/sangria

- URL: https://github.com/sangria-graphql/sangria
- Role: mature strongly typed Scala GraphQL implementation.
- License: Apache-2.0.
- Priority for Idriç: high as a mature baseline, though its architecture is not as narrowly functional as Caliban/Grackle.

### erdeszt/graphient

- URL: https://github.com/erdeszt/graphient
- Role: GraphQL client/query generator for Sangria schemas.
- License: MIT.
- Type idea: schema definitions drive query and variable generation; execution can use Cats Effect.
- Priority for Idriç: medium-high.

### mediative/sangria-codegen

- URL: https://github.com/mediative/sangria-codegen
- Role: historical Sangria GraphQL code generator.
- Status: historical/superseded.
- Priority for Idriç: low-medium, retained as a code-generation comparison.

## Dependently typed languages searched

The following searches did **not** turn up a substantive GraphQL library in this research pass:

- Idris / Idris 2
- Agda
- Lean
- Coq
- F*

This is a negative search result, not a proof that no private, unpublished or poorly indexed implementation exists.  In particular, do not turn “none found” into “GraphQL cannot be modeled dependently.”  Idriç may be the first useful specimen in this group precisely because GraphQL's nullability, selection sets, variables and schema/operation agreement are natural type-level constraints.

## Excluded on purpose

- Elixir, Clojure and ClojureScript have substantial GraphQL ecosystems, but they are dynamically typed and therefore are not primary references for this corpus.
- Rust, Swift, Kotlin and TypeScript have excellent typed GraphQL libraries, but they are not being used as primary functional-language references in this pass.
- Generic HTTP and JSON libraries are not GraphQL libraries and are not catalogued here.

## First comparison questions for Idriç

For each reference implementation, extract answers to these questions before copying an abstraction:

1. Is the GraphQL schema represented as values, types, generated source, or some combination?
2. Is an operation represented as raw GraphQL text, an AST, a typed selection DSL, or generated native code?
3. At what point is an operation checked against the schema?
4. Does response nullability become the host language's optional type correctly?
5. Are variables statically tied to the operation that consumes them?
6. Are interfaces/unions represented as tagged alternatives rather than unchecked casts?
7. Is JSON decoding derived from the same selection that constructed the query?
8. Can a tiny client issue one fixed query without importing an entire server framework?
9. Can the network transport remain independent of GraphQL typing?
10. Which parts are genuinely GraphQL and which are incidental framework machinery?
