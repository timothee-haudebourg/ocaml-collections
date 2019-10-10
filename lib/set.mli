module type OrderedType = sig
  type t
  (** The type of the set elements. *)

  val compare : t -> t -> int
  (** A total ordering function over the set elements.
      This is a two-argument function [f] such that
      [f e1 e2] is zero if the elements [e1] and [e2] are equal,
      [f e1 e2] is strictly negative if [e1] is smaller than [e2],
      and [f e1 e2] is strictly positive if [e1] is greater than [e2].
      Example: a suitable ordering function is the generic structural
      comparison function {!Stdlib.compare}. *)
end

module type S = sig
  module Elt : OrderedType

  type t

  val empty: t
  val is_empty: t -> bool
  val mem: Elt.t -> t -> bool
  val add: Elt.t -> t -> t
  val singleton: Elt.t -> t
  val remove: Elt.t -> t -> t
  val union: t -> t -> t
  val inter: t -> t -> t
  val diff: t -> t -> t
  val compare: t -> t -> int
  val equal: t -> t -> bool
  val subset: t -> t -> bool
  val iter: (Elt.t -> unit) -> t -> unit
  val map: (Elt.t -> Elt.t) -> t -> t
  val fold: (Elt.t -> 'a -> 'a) -> t -> 'a -> 'a
  val fold_pairs: ?reflexive:bool -> (Elt.t -> Elt.t -> 'a -> 'a) -> t -> 'a -> 'a
  val for_all: (Elt.t -> bool) -> t -> bool
  val exists: (Elt.t -> bool) -> t -> bool
  val filter: (Elt.t -> bool) -> t -> t
  val partition: (Elt.t -> bool) -> t -> t * t
  val cardinal: t -> int
  val elements: t -> Elt.t list
  val min_elt: t -> Elt.t
  val min_elt_opt: t -> Elt.t option
  val max_elt: t -> Elt.t
  val max_elt_opt: t -> Elt.t option
  val choose: t -> Elt.t
  val choose_opt: t -> Elt.t option
  val split: Elt.t -> t -> t * bool * t
  val find: Elt.t -> t -> Elt.t
  val find_opt: Elt.t -> t -> Elt.t option
  val find_first: (Elt.t -> bool) -> t -> Elt.t
  val find_first_opt: (Elt.t -> bool) -> t -> Elt.t option
  val find_last: (Elt.t -> bool) -> t -> Elt.t
  val find_last_opt: (Elt.t -> bool) -> t -> Elt.t option
  val of_list: Elt.t list -> t

  val fold_words : int -> (Elt.t list -> 'a -> 'a) -> t -> 'a -> 'a
  (** [fold_words n f x t] fold all words of size [n] where [t] is the alphabet.
      Complexity: |t|^n.*)

  val fold_inline_combinations : (Elt.t list -> 'a -> 'a) -> t list -> 'a -> 'a

  val fold_random: (Elt.t -> 'a -> 'a) -> t -> 'a -> 'a

  val update : (Elt.t option -> unit) -> Elt.t -> t -> t
  (** Add an element to the set.
      update f x t.
      Calls f with Some e if equal e x = 0 and mem e, or with None. *)

  val fold2 : (Elt.t -> Elt.t -> 'a -> 'a) -> t -> t -> 'a -> 'a

  val iter2 : (Elt.t -> Elt.t -> unit) -> t -> t -> unit

  val product : (Elt.t -> Elt.t -> Elt.t option) -> t -> t -> t

  val hash : t -> int
end

module Make (E : OrderedType) : S with module Elt = E

module Ext (A : S) (B : S) : sig
  val map : (A.Elt.t -> B.Elt.t) -> A.t -> B.t

  val fold2 : (A.Elt.t -> B.Elt.t -> 'a -> 'a) -> A.t -> B.t -> 'a -> 'a

  val iter2 : (A.Elt.t -> B.Elt.t -> unit) -> A.t -> B.t -> unit
end

module Product (A : S) (B : S) (AB : S) : sig
  val product : (A.Elt.t -> B.Elt.t -> AB.Elt.t option) -> A.t -> B.t -> AB.t
end
