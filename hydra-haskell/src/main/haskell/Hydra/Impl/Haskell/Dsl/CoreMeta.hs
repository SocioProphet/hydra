module Hydra.Impl.Haskell.Dsl.CoreMeta (
  nominalCases,
  nominalMatch,
  nominalMatchWithVariants,
  nominalProjection,
  nominalRecord,
  named,
  nominalUnion,
  nominalUnitVariant,
  nominalVariant,
  nominalWithFunction,
  nominalWithUnitVariant,
  nominalWithVariant,
  withType,
  module Hydra.Impl.Haskell.Dsl.Terms,
) where

import Hydra.Core
import Hydra.Evaluation
import Hydra.Graph
import Hydra.Impl.Haskell.Dsl.Terms
import qualified Hydra.Impl.Haskell.Dsl.Types as Types
import Hydra.Impl.Haskell.Extras


nominalCases :: Default m => Context m -> Name -> Type m -> [Field m] -> Data m
nominalCases cx name cod fields = withType cx (Types.function (Types.nominal name) cod) $ cases fields

nominalMatch :: Default m => Context m -> Name -> Type m -> [(FieldName, Data m)] -> Data m
nominalMatch cx name cod fields = nominalCases cx name cod (fmap toField fields)
  where
    toField (fname, term) = Field fname term

nominalMatchWithVariants :: Context Meta -> Type Meta -> Type Meta -> [(FieldName, FieldName)] -> Data Meta
nominalMatchWithVariants cx dom cod = withType cx ft . cases . fmap toField
  where
    ft = Types.function dom cod
    toField (from, to) = Field from $ constFunction $ withType cx cod $ unitVariant to -- nominalUnitVariant cx cod to

nominalProjection :: Default m => Context m -> Name -> FieldName -> Type m -> Data m
nominalProjection cx name fname ftype = withType cx (Types.function (Types.nominal name) ftype) $ projection fname

nominalRecord :: Default m => Context m -> Name -> [Field m] -> Data m
nominalRecord cx name fields = named cx name $ record fields

named :: Default m => Context m -> Name -> Data m -> Data m
named cx name = withType cx (Types.nominal name)

nominalUnion :: Default m => Context m -> Name -> Field m -> Data m
nominalUnion cx name field = withType cx (Types.nominal name) $ union field

nominalUnitVariant :: Default m => Context m -> Name -> FieldName -> Data m
nominalUnitVariant cx name fname = nominalVariant cx name fname unitData

nominalVariant :: Default m => Context m -> Name -> FieldName -> Data m -> Data m
nominalVariant cx name fname term = named cx name $ variant fname term

nominalWithFunction :: Default m => Context m -> Name -> FieldName -> Element m -> Data m
nominalWithFunction cx name fname el = lambda var $ nominalVariant cx name fname $ apply (elementRef el) (variable var)
  where var = "x"

nominalWithUnitVariant :: Default m => Context m -> Name -> FieldName -> Data m
nominalWithUnitVariant cx name fname = constFunction $ nominalUnitVariant cx name fname

nominalWithVariant :: Default m => Context m -> Name -> FieldName -> Data m -> Data m
nominalWithVariant cx name fname term = constFunction $ nominalVariant cx name fname term

withType :: Context m -> Type m -> Data m -> Data m
withType cx typ term = term { dataMeta = contextSetTypeOf cx (Just typ) (dataMeta term)}
