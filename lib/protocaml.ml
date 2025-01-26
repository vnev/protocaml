(* Proto syntax versions *)
type proto_syntax_version = Two | Three

(* Field types *)
type scalar_type =
 | String
 | Double
 | Int32 | Int64 | UInt32 | UInt64 | SInt32 | SInt64
 | Fixed32 | Fixed64 | SFixed32 | SFixed64
 | Bytes

type map_key_type =
 | KString
 | KInt32 | KInt64 | KUInt32 | KUInt64 | KSInt32 | KSInt64
 | KFixed32 | KFixed64
 | KBool

type field_type =
 | Scalar of scalar_type
 | Enum of string (* enum name *)
 | Message of string (* message name *)

(* Field modifiers with version constraints *)
type field_modifier =
 | Repeated
 | Optional of {proto2_only: bool}
 | Required of {proto2_only: bool}
 | Map of {key_type: map_key_type}
 | OneOf of string (* oneof group name *)

type 'a field = {
 name: string;
 modifier: field_modifier;
 typ: field_type;
 fnum: int32; (* Positive by type *)
 data: 'a;
}

type 'a message = {
 name: string;
 fields: 'a field list;
 validate: unit -> bool; (* Validate field numbers, names etc *)
}

type 'a protobuf = {
 version: proto_syntax_version;
 messages: 'a message list;
 validate: unit -> bool; (* Validate cross-references *)
}


module Deserialize = struct
  include Deserialize
end
