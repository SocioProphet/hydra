module Hydra.Impl.Haskell.Sources.Adapters.Utils (adapterUtilsModule) where

import Hydra.Core
import Hydra.Impl.Haskell.Sources.Libraries
import Hydra.Graph
import Hydra.Impl.Haskell.Dsl.Terms
import qualified Hydra.Impl.Haskell.Dsl.Types as Types
import Hydra.Impl.Haskell.Dsl.Standard
import Hydra.Impl.Haskell.Extras
import Hydra.Impl.Haskell.Sources.Basics


(++.) :: Default a => Data a -> Data a -> Data a
l ++. r = apply (primitive _strings_cat) $ list [l, r]

(@.) :: Default a => Data a -> Data a -> Data a
l @. r = apply l r

(->.) :: Default a => String -> Data a -> Data a
v ->. body = lambda v body

const_ :: Default a => Data a -> Data a
const_ = constFunction

_eldata :: Default a1 => Element a2 -> Data a1
_eldata el = delta @. element (elementName el)

l_ :: Default a => String -> Data a -> Data a
l_ = lambda

match_ :: Name -> Type Meta -> [(FieldName, Data Meta)] -> Data Meta
match_ = standardMatch

p_ :: Default a => Name -> Data a
p_ = primitive

r_ :: Name -> [Field Meta] -> Data Meta
r_ = standardRecord

s_ :: String -> Data Meta
s_ = stringValue

v_ :: Default a => String -> Data a
v_ = variable


adapterUtilsModule :: Module Meta
adapterUtilsModule = Module adapterUtils [hydraBasicsModule]

adapterUtilsName :: GraphName
adapterUtilsName = GraphName "hydra/adapters/utils"

adapterUtils :: Graph Meta
adapterUtils = standardGraph adapterUtilsName [
  describeFloatType,
  describeIntegerType,
  describeLiteralType,
  describePrecision,
  describeType]

describeFloatType :: Element Meta
describeFloatType = standardFunction adapterUtilsName "describeFloatType"
  "Display a floating-point type as a string"
  (Types.nominal _FloatType) Types.string
  $ l_"t" $ (_eldata describePrecision @. (_eldata floatTypePrecision @. v_"t")) ++. s_" floating-point numbers"

describeIntegerType :: Element Meta
describeIntegerType = standardFunction adapterUtilsName "describeIntegerType"
  "Display an integer type as a string"
  (Types.nominal _IntegerType) Types.string
  $ l_"t" $ (_eldata describePrecision @. (_eldata integerTypePrecision @. v_"t")) ++. s_" integers"

describeLiteralType :: Element Meta
describeLiteralType = standardFunction adapterUtilsName "describeLiteralType"
  "Display a literal type as a string"
  (Types.nominal _LiteralType) Types.string $
  match_ _LiteralType Types.string [
    (_LiteralType_binary, const_ $ s_"binary strings"),
    (_LiteralType_boolean, const_ $ s_"boolean values"),
    (_LiteralType_float, _eldata describeFloatType),
    (_LiteralType_integer, _eldata describeIntegerType),
    (_LiteralType_string, const_ $ s_"character strings")]

describePrecision :: Element Meta
describePrecision = standardFunction adapterUtilsName "describePrecision"
  "Display numeric precision as a string"
  (Types.nominal _Precision) Types.string $
  match_ _Precision Types.string [
    (_Precision_arbitrary, const_ $ s_"arbitrary-precision"),
    (_Precision_bits,
      l_"bits" $ p_ _strings_cat @.
        list [
          p_ _literals_showInt32 @. v_"bits",
          s_"-bit"])]

describeType :: Element Meta
describeType = standardFunction adapterUtilsName "describeType"
  "Display a type as a string"
  (Types.universal "m" $ Types.nominal _Type) Types.string $
  lambda "typ" $ apply
    (match_ _TypeTerm Types.string [
      (_TypeTerm_literal, _eldata describeLiteralType),
      (_TypeTerm_element, l_"t" $ s_"elements containing " ++. (_eldata describeType @. v_"t")),
      (_TypeTerm_function, l_"ft" $ s_"functions from "
        ++. (_eldata describeType @. (project (Types.nominal _FunctionType) _FunctionType_domain (Types.nominal _Type) @. v_"ft"))
        ++. s_" to "
        ++. (_eldata describeType @. (project (Types.nominal _FunctionType) _FunctionType_codomain (Types.nominal _Type) @. v_"ft"))),
      (_TypeTerm_list, l_"t" $ s_"lists of " ++. (_eldata describeType @. v_"t")),
      (_TypeTerm_map, l_"mt" $ s_"maps from "
        ++. (_eldata describeType @. (project (Types.nominal _MapType) _MapType_keys (Types.nominal _Type) @. v_"mt"))
        ++. s_" to "
        ++. (_eldata describeType @. (project (Types.nominal _MapType) _MapType_values (Types.nominal _Type) @. v_"mt"))),
      (_TypeTerm_nominal, l_"name" $ s_"alias for " ++. v_"name"),
      (_TypeTerm_optional, l_"ot" $ s_"optional " ++. (_eldata describeType @. v_"ot")),
      (_TypeTerm_record, const_ $ s_"records of a particular set of fields"),
      (_TypeTerm_set, l_"st" $ s_"sets of " ++. (_eldata describeType @. v_"st")),
      (_TypeTerm_union, const_ $ s_"unions of a particular set of fields"),
      (_TypeTerm_universal, const_ $ s_"polymorphic terms"),
      (_TypeTerm_variable, const_ $ s_"unspecified/parametric terms")])
    (apply (project (Types.universal "m" $ Types.nominal _Type) _Type_term (Types.universal "m" $ Types.nominal _TypeTerm))
           $ variable "typ")

--idAdapter :: Element Meta
--idAdapter = standardFunction adapterUtilsName "idAdapter"
--  "An identity adapter for a given type"
--  (Types.nominal _Type) (TypeTermUniversal (UniversalType "m" $ ())) $
--  l_"t" $ r_ _Adapter [
--    Field _Adapter_isLossy (booleanValue False),
--    Field _Adapter_source (v_"t"),
--    Field _Adapter_target (v_"t"),
--    Field _Adapter_step (_eldata idStep)]
