type sign_type =
  | Unsigned
  | Signed;;

type varint_field_type =
  | Integer32 of Int32.t
  | Integer64 of Int64.t
  | UInt32 of sign_type * Int32.t
  | UInt64 of sign_type * Int64.t
  | SInt32 of sign_type * Int32.t
  | SInt64 of sign_type * Int64.t
  | Bool of bool
  | Enum of (string, int) Hashtbl.t;;

type fixed32_field_type =
  | Fixed32 of Int32.t
  | SFixed32 of sign_type * Int32.t
  | Float of float;;

type fixed64_field_type =
  | Fixed64 of Int64.t
  | SFixed64 of sign_type * Int64.t
  | Double of float;;

(* how do we initialize a repeated field under this ? *)
type len_delim_field_type =
  | Bytes of int list
  | String of string;;

type field_type =
  | Enum of (string, int) Hashtbl.t
  | Bool of bool
  | String of string
  | Double of float
  | Int32 of Int32.t
  | Int64 of Int64.t
  | UInt32 of Int32.t
  | UInt64 of Int64.t
  | SInt32 of Int32.t
  | SInt64 of Int64.t
  | Fixed32 of Int32.t
  | Fixed64 of Int64.t
  | SFixed32 of Int32.t
  | SFixed64 of Int64.t
  | Bytes of int list (* TODO: is this right? *)
  | Repeated of field_type list
  | Optional of field_type option
  | Field of field_type option;;

type wire_type =
  | VarInt (* int32, int64, uint32, uint64, sint32, sint64, bool, enum *)
  | Fixed32 (* fixed32, sfixed32, float *)
  | Fixed64 (* fixed64, sfixed64, double *)
  | LenDelimBlock (* string, bytes, embedded messages, packed repeated fields *)
  | SGroup (* deprecated *)
  | EGroup (* deprecated *)
  | Unknown;; (* should not happen! *)



let get_wire_type wt = match wt with
  | 0 -> VarInt
  | 1 -> Fixed64
  | 2 -> LenDelimBlock
  | 3 -> SGroup
  | 4 -> EGroup
  | 5 -> Fixed32
  | _ -> Printf.printf "FATAL ERROR: Unknown wire type %d\n" wt; Unknown;; (* should never happen *)

let extract_wire_type_bits byte = (int_of_char byte) land 0b111;;

(* returns wire type and field number *)
let decode_tag inp : (wire_type * int) = (get_wire_type (extract_wire_type_bits inp), Int.shift_right (int_of_char inp) 3);;

(*
let parse_proto_bin buffer : j
let read_proto_bin filename =
  let channel = open_in_bin filename in
  try
    let len = in_channel_length channel in
    let buffer = really_input_string channel len in
    close_in channel;
    Ok buffer
  with e ->
    close_in_noerr channel;
    Error e
    "../test/proto/simple_msg_test.bin"
    *)

let is_msb_set byte = ((Char.code byte) land 0x80) <> 0

let to_big_endian bytes =
 let len = Bytes.length bytes in
 let result = Bytes.create len in
 for i = 0 to len - 1 do
   Bytes.set result i (Bytes.get bytes (len - 1 - i))
 done;
 result;;

let read_proto_bin filename =
  let in_channel = open_in_bin filename in
  try
    let len = in_channel_length in_channel in
    let buffer = Bytes.create len in
    really_input in_channel buffer 0 len;
    close_in in_channel;
    Ok (to_big_endian buffer)
  with e ->
    close_in_noerr in_channel;
    Error e;;

let start_decode buffer =
  for i = 0 to Bytes.length buffer - 1 do
    let byte = Bytes.get buffer i in
      Printf.printf "wire type code: %d\n" (int_of_char byte)
  done
