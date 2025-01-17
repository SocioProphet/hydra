package hydra.core;

public abstract class Function<A> {
  private Function() {}
  
  public abstract <R> R accept(Visitor<R> visitor) ;
  
  /**
   * An interface for applying a function to a Function according to its variant (subclass)
   */
  public interface Visitor<R> {
    R visit(Cases instance) ;
    
    R visit(CompareTo instance) ;
    
    R visit(Data instance) ;
    
    R visit(Lambda instance) ;
    
    R visit(Primitive instance) ;
    
    R visit(Projection instance) ;
  }
  
  /**
   * An interface for applying a function to a Function according to its variant (subclass). If a visit() method for a
   * particular variant is not implemented, a default method is used instead.
   */
  public interface PartialVisitor<R> extends Visitor<R> {
    default R otherwise(Function instance) {
      throw new IllegalStateException("Non-exhaustive patterns when matching: " + instance);
    }
    
    @Override
    default R visit(Cases instance) {
      return otherwise(instance);
    }
    
    @Override
    default R visit(CompareTo instance) {
      return otherwise(instance);
    }
    
    @Override
    default R visit(Data instance) {
      return otherwise(instance);
    }
    
    @Override
    default R visit(Lambda instance) {
      return otherwise(instance);
    }
    
    @Override
    default R visit(Primitive instance) {
      return otherwise(instance);
    }
    
    @Override
    default R visit(Projection instance) {
      return otherwise(instance);
    }
  }
  
  /**
   * A case statement applied to a variant record, consisting of a function term for each alternative in the union
   */
  public static final class Cases<A> extends Function<A> {
    public final java.util.List<hydra.core.Field<A>> cases;
    
    /**
     * Constructs an immutable Cases object
     */
    public Cases(java.util.List<hydra.core.Field<A>> cases) {
      this.cases = cases;
    }
    
    @Override
    public <R> R accept(Visitor<R> visitor) {
      return visitor.visit(this);
    }
    
    @Override
    public boolean equals(Object other) {
      if (!(other instanceof Cases)) {
          return false;
      }
      Cases o = (Cases) other;
      return cases.equals(o.cases);
    }
    
    @Override
    public int hashCode() {
      return 2 * cases.hashCode();
    }
  }
  
  /**
   * Compares a term with a given term of the same type, producing a Comparison
   */
  public static final class CompareTo<A> extends Function<A> {
    public final hydra.core.Term<A> compareTo;
    
    /**
     * Constructs an immutable CompareTo object
     */
    public CompareTo(hydra.core.Term<A> compareTo) {
      this.compareTo = compareTo;
    }
    
    @Override
    public <R> R accept(Visitor<R> visitor) {
      return visitor.visit(this);
    }
    
    @Override
    public boolean equals(Object other) {
      if (!(other instanceof CompareTo)) {
          return false;
      }
      CompareTo o = (CompareTo) other;
      return compareTo.equals(o.compareTo);
    }
    
    @Override
    public int hashCode() {
      return 2 * compareTo.hashCode();
    }
  }
  
  /**
   * Hydra's delta function, which maps an element to its data term
   */
  public static final class Data<A> extends Function<A> {
    /**
     * Constructs an immutable Data object
     */
    public Data() {}
    
    @Override
    public <R> R accept(Visitor<R> visitor) {
      return visitor.visit(this);
    }
    
    @Override
    public boolean equals(Object other) {
      if (!(other instanceof Data)) {
          return false;
      }
      Data o = (Data) other;
      return true;
    }
    
    @Override
    public int hashCode() {
      return 0;
    }
  }
  
  /**
   * A function abstraction (lambda)
   */
  public static final class Lambda<A> extends Function<A> {
    public final hydra.core.Lambda<A> lambda;
    
    /**
     * Constructs an immutable Lambda object
     */
    public Lambda(hydra.core.Lambda<A> lambda) {
      this.lambda = lambda;
    }
    
    @Override
    public <R> R accept(Visitor<R> visitor) {
      return visitor.visit(this);
    }
    
    @Override
    public boolean equals(Object other) {
      if (!(other instanceof Lambda)) {
          return false;
      }
      Lambda o = (Lambda) other;
      return lambda.equals(o.lambda);
    }
    
    @Override
    public int hashCode() {
      return 2 * lambda.hashCode();
    }
  }
  
  /**
   * A reference to a built-in (primitive) function
   */
  public static final class Primitive<A> extends Function<A> {
    public final hydra.core.Name primitive;
    
    /**
     * Constructs an immutable Primitive object
     */
    public Primitive(hydra.core.Name primitive) {
      this.primitive = primitive;
    }
    
    @Override
    public <R> R accept(Visitor<R> visitor) {
      return visitor.visit(this);
    }
    
    @Override
    public boolean equals(Object other) {
      if (!(other instanceof Primitive)) {
          return false;
      }
      Primitive o = (Primitive) other;
      return primitive.equals(o.primitive);
    }
    
    @Override
    public int hashCode() {
      return 2 * primitive.hashCode();
    }
  }
  
  /**
   * A projection of a field from a record
   */
  public static final class Projection<A> extends Function<A> {
    public final hydra.core.Projection projection;
    
    /**
     * Constructs an immutable Projection object
     */
    public Projection(hydra.core.Projection projection) {
      this.projection = projection;
    }
    
    @Override
    public <R> R accept(Visitor<R> visitor) {
      return visitor.visit(this);
    }
    
    @Override
    public boolean equals(Object other) {
      if (!(other instanceof Projection)) {
          return false;
      }
      Projection o = (Projection) other;
      return projection.equals(o.projection);
    }
    
    @Override
    public int hashCode() {
      return 2 * projection.hashCode();
    }
  }
}
