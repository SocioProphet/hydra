package hydra.evaluation

import hydra.core.FunctionType
import hydra.core.Term

case class PrimitiveFunction(
    /**
     * @type function:
     *         from:
     *         - list: hydra/core.Term
     *         to: hydra/core.Term
     */
    implementation: Seq[Term] => Term,
    
    /**
     * @type hydra/core.FunctionType
     */
    `type`: FunctionType
)

val _PrimitiveFunction: String = "hydra/evaluation.PrimitiveFunction"
val _PrimitiveFunction_implementation: String = "implementation"
val _PrimitiveFunction_type: String = "type"