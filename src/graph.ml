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

module Make (Node : HashTable.HashedType) = struct
  type node = Node.t

  module NodeSet = Set.Make (Node)
  module NodeTable = HashTable.Make (Node)

  type t = {
    nodes: NodeSet.t;
    succ: NodeSet.t NodeTable.t
  }

  let empty =
    {
      nodes = NodeSet.empty;
      succ = NodeTable.create 8
    }

  let nodes t =
    t.nodes

  let successors t node =
    match NodeTable.find_opt node t.succ with
    | Some succs -> succs
    | None -> NodeSet.empty

  let add node t =
    { t with nodes = NodeSet.add node t.nodes }

  let connect a b t =
    let t = add b (add a t) in
    { t with succ = NodeTable.set a (NodeSet.add b (successors t a)) t.succ }

  type node_component_data = {
    mutable index: int;
    mutable low_link: int;
    mutable on_stack: bool
  }

  let components t =
    let table = Hashtbl.create (NodeSet.cardinal t.nodes) in
    let stack = Stack.create () in
    let components = ref [] in
    let count = ref 0 in
    let next_index () =
      let index = !count in
      count := index + 1;
      index
    in
    let rec strong_connect node =
      match Hashtbl.find_opt table node with
      | Some node_data -> node_data
      | None ->
        Stack.push node stack;
        let index = next_index () in
        let node_data = { index = index; low_link = index; on_stack = true } in
        Hashtbl.add table node node_data;

        NodeSet.iter (
          function succ ->
          match Hashtbl.find_opt table succ with
          | None ->
            let succ_data = strong_connect succ in
            node_data.low_link <- min node_data.low_link succ_data.low_link
          | Some succ_data when succ_data.on_stack ->
            node_data.low_link <- min node_data.low_link succ_data.index
          | Some _ -> ()
        ) (successors t node);

        if node_data.low_link = node_data.index then begin
          let rec build_component component =
            let member = Stack.pop stack in
            let member_data = Hashtbl.find table member in
            member_data.on_stack <- false;
            let component = NodeSet.add member component in
            if Node.equal node member then component else build_component component
          in
          let component = build_component NodeSet.empty in
          components := component :: !components
        end;
        node_data
    in
    NodeSet.iter (function node -> ignore (strong_connect node)) t.nodes;
    !components
end
