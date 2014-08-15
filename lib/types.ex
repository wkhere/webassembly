defmodule WebAssembly.Types do
  @moduledoc """
  Types of input and output data used in the tag assembly.
  """

  @type tagname  :: atom
  @type attrs    :: [{atom, atom | number | String.t}]
  @type content  :: atom | number | String.t | out_tag | [String.t | out_tag]
  @type out_tag  :: [String.t | [String.t] | content]
  @type out_tag_void :: [String.t | [String.t]]

end
