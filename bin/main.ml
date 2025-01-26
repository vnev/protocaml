let () = match Protocaml.Deserialize.read_proto_bin "test/proto/output.bin" with
  | Ok result -> Protocaml.Deserialize.start_decode result
  | Error e -> Printf.eprintf "Error: %s\n" (Printexc.to_string e)
