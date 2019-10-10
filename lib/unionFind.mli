module type Class = sig
  type t

  val equal: t -> t -> bool

  val union: t -> t -> t
end

module type S = sig
  module Elt : HashTable.HashedType
  module Class : Class

  type t

  type factory = Elt.t -> Class.t

  val create: ?size:int -> unit -> t

  val find: ?default:factory -> Elt.t -> t -> Class.t

  val find_opt: ?default:factory -> Elt.t -> t -> Class.t option

  val union: ?default:factory -> ?hook:(Class.t -> Class.t -> unit) -> Elt.t -> Elt.t -> t -> t
  (* hook is triggered only if both elements are not in the same class. *)
end

module Make (E: HashTable.HashedType) (C: Class) : S with module Elt = E and module Class = C
