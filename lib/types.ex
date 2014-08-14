defmodule WebAssembly.Types do

  @type tagname  :: atom
  @type attrs    :: [{atom, String.t}]
  @type content  :: String.t | out_tag | [String.t | out_tag]
  @type out_tag1 :: [String.t | [String.t]]
  @type out_tag  :: [String.t | [String.t] | content]

end
