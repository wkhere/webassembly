defmodule WebAssembly.Types do
  @moduledoc """
  Types of input, intermediate and output data used in the elements assembly.
  """

  @type tag        :: atom
  @type attributes :: [{atom, atom | number | String.t}]
  @type content    :: String.t | assembled_elements
  @type assembled_tag           :: String.t
  @type assembled_attributes    :: [String.t]
  @type assembled_void_elements :: [assembled_tag | assembled_attributes]
  @type assembled_elements      :: [assembled_tag | assembled_attributes |
                                    content]

end
