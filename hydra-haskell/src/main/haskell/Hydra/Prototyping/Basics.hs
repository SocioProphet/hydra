module Hydra.Prototyping.Basics (
    comparePrecision,
    floatTypePrecision,
    floatTypeVariant,
    floatValueType,
    floatValueVariant,
    floatVariantPrecision,
    floatVariants,
    functionVariant,
    functionVariants,
    hydraCoreLanguage,
    integerTypeIsSigned,
    integerTypePrecision,
    integerTypeVariant,
    integerTypes,
    integerValueType,
    integerValueVariant,
    integerVariantIsSigned,
    integerVariantPrecision,
    integerVariants,
    literalTypeVariant,
    literalType,
    literalVariant,
    literalVariants,
    termVariant,
    termVariants,
    typeVariant,
    typeVariants,
  ) where

import Hydra.Core
import Hydra.Adapter

import qualified Data.Set as S


comparePrecision :: Precision -> Precision -> Ordering
comparePrecision p1 p2 = if p1 == p2 then EQ else case (p1, p2) of
  (PrecisionArbitrary, _) -> GT
  (_, PrecisionArbitrary) -> LT
  (PrecisionBits b1, PrecisionBits b2) -> compare b1 b2

floatTypePrecision :: FloatType -> Precision
floatTypePrecision = floatVariantPrecision . floatTypeVariant

floatTypeVariant :: FloatType -> FloatVariant
floatTypeVariant ft = case ft of
  FloatTypeBigfloat -> FloatVariantBigfloat
  FloatTypeFloat32 -> FloatVariantFloat32
  FloatTypeFloat64 -> FloatVariantFloat64

floatValueType :: FloatValue -> FloatType
floatValueType fv = case fv of
  FloatValueBigfloat _ -> FloatTypeBigfloat
  FloatValueFloat32 _ -> FloatTypeFloat32
  FloatValueFloat64 _ -> FloatTypeFloat64

floatValueVariant :: FloatValue -> FloatVariant
floatValueVariant = floatTypeVariant . floatValueType

floatVariantPrecision :: FloatVariant -> Precision
floatVariantPrecision v = case v of
  FloatVariantBigfloat -> PrecisionArbitrary
  FloatVariantFloat32 -> PrecisionBits 32
  FloatVariantFloat64 -> PrecisionBits 64

floatVariants :: [FloatVariant]
floatVariants = [FloatVariantFloat32, FloatVariantFloat64, FloatVariantBigfloat]

functionVariant :: Function a -> FunctionVariant
functionVariant f = case f of
  FunctionCases _ -> FunctionVariantCases
  FunctionCompareTo _ -> FunctionVariantCompareTo
  FunctionData -> FunctionVariantData
  FunctionPrimitive _ -> FunctionVariantPrimitive
  FunctionProjection _ -> FunctionVariantProjection

functionVariants :: [FunctionVariant]
functionVariants = [
  FunctionVariantCases,
  FunctionVariantCompareTo,
  FunctionVariantData,
  FunctionVariantPrimitive,
  FunctionVariantLambda,
  FunctionVariantProjection]

hydraCoreLanguage :: Language
hydraCoreLanguage = Language "hydra/core" $ Language_Constraints {
  languageConstraintsLiteralVariants = S.fromList literalVariants,
  languageConstraintsFloatVariants = S.fromList floatVariants,
  languageConstraintsFunctionVariants = S.fromList functionVariants,
  languageConstraintsIntegerVariants = S.fromList integerVariants,
  languageConstraintsTermVariants = S.fromList termVariants,
  languageConstraintsTypeVariants = S.fromList typeVariants,
  languageConstraintsTypes = const True }

integerTypeIsSigned :: IntegerType -> Bool
integerTypeIsSigned = integerVariantIsSigned . integerTypeVariant

integerTypePrecision :: IntegerType -> Precision
integerTypePrecision = integerVariantPrecision . integerTypeVariant

integerTypeVariant :: IntegerType -> IntegerVariant
integerTypeVariant it = case it of
  IntegerTypeBigint -> IntegerVariantBigint
  IntegerTypeInt8 -> IntegerVariantInt8
  IntegerTypeInt16 -> IntegerVariantInt16
  IntegerTypeInt32 -> IntegerVariantInt32
  IntegerTypeInt64 -> IntegerVariantInt64
  IntegerTypeUint8 -> IntegerVariantUint8
  IntegerTypeUint16 -> IntegerVariantUint16
  IntegerTypeUint32 -> IntegerVariantUint32
  IntegerTypeUint64 -> IntegerVariantUint64

integerValueType :: IntegerValue -> IntegerType
integerValueType iv = case iv of
  IntegerValueBigint _ -> IntegerTypeBigint
  IntegerValueInt8 _ -> IntegerTypeInt8
  IntegerValueInt16 _ -> IntegerTypeInt16
  IntegerValueInt32 _ -> IntegerTypeInt32
  IntegerValueInt64 _ -> IntegerTypeInt64
  IntegerValueUint8 _ -> IntegerTypeUint8
  IntegerValueUint16 _ -> IntegerTypeUint16
  IntegerValueUint32 _ -> IntegerTypeUint32
  IntegerValueUint64 _ -> IntegerTypeUint64

integerValueVariant :: IntegerValue -> IntegerVariant
integerValueVariant = integerTypeVariant . integerValueType

integerVariantIsSigned :: IntegerVariant -> Bool
integerVariantIsSigned v = case v of
  IntegerVariantUint8 -> False
  IntegerVariantUint16 -> False
  IntegerVariantUint32 -> False
  IntegerVariantUint64 -> False
  _ -> True

integerVariantPrecision :: IntegerVariant -> Precision
integerVariantPrecision v = case v of
  IntegerVariantBigint -> PrecisionArbitrary
  IntegerVariantInt8 -> PrecisionBits 8
  IntegerVariantInt16 -> PrecisionBits 16
  IntegerVariantInt32 -> PrecisionBits 32
  IntegerVariantInt64 -> PrecisionBits 64
  IntegerVariantUint8 -> PrecisionBits 8
  IntegerVariantUint16 -> PrecisionBits 16
  IntegerVariantUint32 -> PrecisionBits 32
  IntegerVariantUint64 -> PrecisionBits 64

integerTypes :: [IntegerType]
integerTypes = [
  IntegerTypeBigint,
  IntegerTypeInt8, 
  IntegerTypeInt16,
  IntegerTypeInt32,
  IntegerTypeInt64,
  IntegerTypeUint8,
  IntegerTypeUint16,
  IntegerTypeUint32,
  IntegerTypeUint64]

integerVariants :: [IntegerVariant]
integerVariants = integerTypeVariant <$> integerTypes

literalType :: Literal -> LiteralType
literalType v = case v of
  LiteralBinary _ -> LiteralTypeBinary
  LiteralBoolean _ -> LiteralTypeBoolean
  LiteralFloat fv -> LiteralTypeFloat $ floatValueType fv
  LiteralInteger iv -> LiteralTypeInteger $ integerValueType iv
  LiteralString _ -> LiteralTypeString

literalTypeVariant :: LiteralType -> LiteralVariant
literalTypeVariant at = case at of
  LiteralTypeBinary -> LiteralVariantBinary
  LiteralTypeBoolean -> LiteralVariantBoolean
  LiteralTypeFloat _ -> LiteralVariantFloat
  LiteralTypeInteger _ -> LiteralVariantInteger
  LiteralTypeString -> LiteralVariantString

literalVariant :: Literal -> LiteralVariant
literalVariant = literalTypeVariant . literalType

literalVariants :: [LiteralVariant]
literalVariants = [
  LiteralVariantBinary,
  LiteralVariantBoolean,
  LiteralVariantFloat,
  LiteralVariantInteger,
  LiteralVariantString]

termVariant :: Term a -> TermVariant
termVariant term = case termData term of
  ExpressionApplication _ -> TermVariantApplication
  ExpressionLiteral _ -> TermVariantLiteral
  ExpressionElement _ -> TermVariantElement
  ExpressionFunction _ -> TermVariantFunction
  ExpressionList _ -> TermVariantList
  ExpressionMap _ -> TermVariantMap
  ExpressionNominal _ -> TermVariantNominal
  ExpressionOptional _ -> TermVariantOptional
  ExpressionRecord _ -> TermVariantRecord
  ExpressionSet _ -> TermVariantSet
  ExpressionTypeAbstraction _ -> TermVariantTypeAbstraction
  ExpressionTypeApplication _ -> TermVariantTypeApplication
  ExpressionUnion _ -> TermVariantUnion
  ExpressionVariable _ -> TermVariantVariable

termVariants :: [TermVariant]
termVariants = [
  TermVariantApplication,
  TermVariantLiteral,
  TermVariantElement,
  TermVariantFunction,
  TermVariantList,
  TermVariantMap,
  TermVariantNominal,
  TermVariantOptional,
  TermVariantRecord,
  TermVariantSet,
  TermVariantUnion,
  TermVariantVariable]

typeVariant :: Type -> TypeVariant
typeVariant typ = case typ of
  TypeLiteral _ -> TypeVariantLiteral
  TypeElement _ -> TypeVariantElement
  TypeFunction _ -> TypeVariantFunction
  TypeList _ -> TypeVariantList
  TypeMap _ -> TypeVariantMap
  TypeNominal _ -> TypeVariantNominal
  TypeOptional _ -> TypeVariantOptional
  TypeRecord _ -> TypeVariantRecord
  TypeSet _ -> TypeVariantSet
  TypeUnion _ -> TypeVariantUnion
  TypeVariable _ -> TypeVariantVariable
  TypeUniversal _ -> TypeVariantUniversal

typeVariants :: [TypeVariant]
typeVariants = [
  TypeVariantLiteral,
  TypeVariantElement,
  TypeVariantFunction,
  TypeVariantList,
  TypeVariantMap,
  TypeVariantNominal,
  TypeVariantOptional,
  TypeVariantRecord,
  TypeVariantSet,
  TypeVariantUnion,
  TypeVariantUniversal,
  TypeVariantVariable]
