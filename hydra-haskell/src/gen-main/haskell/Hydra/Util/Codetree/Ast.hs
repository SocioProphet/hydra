module Hydra.Util.Codetree.Ast where

import qualified Hydra.Core as Core
import Data.Map
import Data.Set

-- Operator associativity
data Associativity 
  = AssociativityNone 
  | AssociativityLeft 
  | AssociativityRight 
  | AssociativityBoth 
  deriving (Eq, Ord, Read, Show)

_Associativity = (Core.Name "hydra/util/codetree/ast.Associativity")

_Associativity_none = (Core.FieldName "none")

_Associativity_left = (Core.FieldName "left")

_Associativity_right = (Core.FieldName "right")

_Associativity_both = (Core.FieldName "both")

-- An expression enclosed by brackets
data BracketExpr 
  = BracketExpr {
    bracketExprBrackets :: Brackets,
    bracketExprEnclosed :: Expr}
  deriving (Eq, Ord, Read, Show)

_BracketExpr = (Core.Name "hydra/util/codetree/ast.BracketExpr")

_BracketExpr_brackets = (Core.FieldName "brackets")

_BracketExpr_enclosed = (Core.FieldName "enclosed")

-- Matching open and close bracket symbols
data Brackets 
  = Brackets {
    bracketsOpen :: Symbol,
    bracketsClose :: Symbol}
  deriving (Eq, Ord, Read, Show)

_Brackets = (Core.Name "hydra/util/codetree/ast.Brackets")

_Brackets_open = (Core.FieldName "open")

_Brackets_close = (Core.FieldName "close")

-- An abstract expression
data Expr 
  = ExprConst Symbol
  | ExprOp OpExpr
  | ExprBrackets BracketExpr
  deriving (Eq, Ord, Read, Show)

_Expr = (Core.Name "hydra/util/codetree/ast.Expr")

_Expr_const = (Core.FieldName "const")

_Expr_op = (Core.FieldName "op")

_Expr_brackets = (Core.FieldName "brackets")

-- An operator symbol
data Op 
  = Op {
    opSymbol :: Symbol,
    opPadding :: Padding,
    opPrecedence :: Precedence,
    opAssociativity :: Associativity}
  deriving (Eq, Ord, Read, Show)

_Op = (Core.Name "hydra/util/codetree/ast.Op")

_Op_symbol = (Core.FieldName "symbol")

_Op_padding = (Core.FieldName "padding")

_Op_precedence = (Core.FieldName "precedence")

_Op_associativity = (Core.FieldName "associativity")

-- An operator expression
data OpExpr 
  = OpExpr {
    opExprOp :: Op,
    opExprLhs :: Expr,
    opExprRhs :: Expr}
  deriving (Eq, Ord, Read, Show)

_OpExpr = (Core.Name "hydra/util/codetree/ast.OpExpr")

_OpExpr_op = (Core.FieldName "op")

_OpExpr_lhs = (Core.FieldName "lhs")

_OpExpr_rhs = (Core.FieldName "rhs")

-- Left and right padding for an operator
data Padding 
  = Padding {
    paddingLeft :: Ws,
    paddingRight :: Ws}
  deriving (Eq, Ord, Read, Show)

_Padding = (Core.Name "hydra/util/codetree/ast.Padding")

_Padding_left = (Core.FieldName "left")

_Padding_right = (Core.FieldName "right")

-- Operator precedence
newtype Precedence 
  = Precedence Int
  deriving (Eq, Ord, Read, Show)

_Precedence = (Core.Name "hydra/util/codetree/ast.Precedence")

-- Any symbol
newtype Symbol 
  = Symbol String
  deriving (Eq, Ord, Read, Show)

_Symbol = (Core.Name "hydra/util/codetree/ast.Symbol")

-- One of several classes of whitespace
data Ws 
  = WsNone 
  | WsSpace 
  | WsBreak 
  | WsBreakAndIndent 
  deriving (Eq, Ord, Read, Show)

_Ws = (Core.Name "hydra/util/codetree/ast.Ws")

_Ws_none = (Core.FieldName "none")

_Ws_space = (Core.FieldName "space")

_Ws_break = (Core.FieldName "break")

_Ws_breakAndIndent = (Core.FieldName "breakAndIndent")