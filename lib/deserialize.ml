type wire_type = 
  | VarInt (* int32, int64, uint32, uint64, sint32, sint64, bool, enum *)
  | Fixed32 (* fixed32, sfixed32, float *)
  | Fixed64 (* fixed64, sfixed64, double *)
  | LenDelimBlock (* string, bytes, embedded messages, packed repeated fields *)
  | SGroup (* deprecated *)
  | EGroup (* deprecated *)
  | Unknown;;


let get_wire_type wt = match wt with
  | 0 -> VarInt
  | 1 -> Fixed64
  | 2 -> LenDelimBlock 
  | 3 -> SGroup 
  | 4 -> EGroup 
  | 5 -> Fixed32
  | _ -> Unknown;; 

let decode_tag _ = ();;


let read_proto_bin filename = 
  let channel = open_in_bin filename in
  let rec read_bytes () =
    try
      let byte = input_char channel in
      Printf.printf "Read byte: %02x\n" (int_of_char byte);
      read_bytes ()
    with End_of_file ->
      close_in channel
  in
  read_bytes()

let () = 
  let in_channel = open_in "../test/proto/simple_msg_test.bin" in
  try
    while true do
      let line = input_line in_channel in
      print_endline line
    done
  with End_of_file ->
    close_in in_channel;;

