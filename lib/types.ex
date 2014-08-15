defmodule WebAssembly.Types do

  @type tagname  :: atom
  @type attrs    :: [{atom, String.t}]
  @type content  :: atom | number | String.t | out_tag | [String.t | out_tag]
  @type out_tag  :: [String.t | [String.t] | content]
  @type out_tag_void :: [String.t | [String.t]]

end
