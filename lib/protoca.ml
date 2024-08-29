type proto_syntax_version = 
  | Two
  | Three;;

type field_type = 
  | Enum
  | String
  | Double
  | Int32
  | Int64
  | UInt32
  | UInt64
  | SInt32
  | SInt64
  | Fixed32
  | Fixed64
  | SFixed32
  | SFixed64
  | Bytes;;

(* for field modifiers `repeated` and `map`, we do not check for explicit presence *)
(* so resulting OCaml code should not have methods for "has field" checks *)
(* i wonder if we can have it anyway *)
type field_modifier =
  | Repeated 
  | Optional
  | Required
  | Map 
  | OneOf;;


type field<'a> = {
  name: string;
  modifier: field_modifier;
  typ: field_type;
  fnum: int;
  data: 'a;
};;

type message = {
  name: string;
  fields: field list;
};;

type protobuf<'a> = {
  version: proto_syntax_version;
  messages: message list;
  tree: 'a; (* TODO build an AST ? *)
};;
