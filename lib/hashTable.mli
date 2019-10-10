module type HashedType = sig
  include Set.OrderedType

  val equal: t -> t -> bool

  val hash: t -> int
end

module type S = sig
  module Key : HashedType

  type 'a t

  val create : int -> 'a t

  val set : Key.t -> 'a -> 'a t -> 'a t

  val size : 'a t -> int

  val is_empty : 'a t -> bool

  val find : Key.t -> 'a t -> 'a

  val find_opt : Key.t -> 'a t -> 'a option

  val resize : int -> 'a t -> 'a t

  val fold : ('b -> Key.t -> 'a -> 'b) -> 'b -> 'a t -> 'b

  val iter : (Key.t -> 'a -> unit) -> 'a t -> unit

  val map : (Key.t -> 'a -> 'b) -> 'a t -> 'b t

  val union : (Key.t -> 'a -> 'a -> 'a option) -> 'a t -> 'a t -> 'a t
end

module Make (K: HashedType) : S with module Key = K
