module type HashedType = sig
  include Set.OrderedType

  val equal: t -> t -> bool

  val hash: t -> int
end

module type S = sig
	type key

  type 'a t

  val create : int -> 'a t

  val set : key -> 'a -> 'a t -> 'a t

  val size : 'a t -> int

  val is_empty : 'a t -> bool

  val find : key -> 'a t -> 'a

  val find_opt : key -> 'a t -> 'a option

  val resize : int -> 'a t -> 'a t

  val fold : ('b -> key -> 'a -> 'b) -> 'b -> 'a t -> 'b

  val iter : (key -> 'a -> unit) -> 'a t -> unit

  val map : (key -> 'a -> 'b) -> 'a t -> 'b t

  val union : (key -> 'a -> 'a -> 'a option) -> 'a t -> 'a t -> 'a t
end

module Make (K: HashedType) : S with type key = K.t
