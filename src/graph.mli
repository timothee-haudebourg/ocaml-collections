module type S = sig
  type node

  module NodeSet : Set.S with type elt = node

  type t

  val empty : t

  val nodes : t -> NodeSet.t

  val successors : t -> node -> NodeSet.t

  val add : node -> t -> t

  val connect : node -> node -> t -> t

  val components : t -> NodeSet.t list
end

module Make (Node : HashTable.HashedType) :
  S with type node = Node.t
