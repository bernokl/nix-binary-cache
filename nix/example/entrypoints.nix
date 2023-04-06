# A common `std` idiom is to place all buildables for a cell in a `apps.nix`
# cell block. This is not required, and you can name this cell block anything
# that makes sense for your project.
#
# This cell block is used to define how our example application is built.
# Ultimately, this means it produces a nix derivation that, when evalulated,
# produces our binary.

# The function arguments shown here are universal to all cell blocks. We are
# provided with the inputs from our flake and a `cell` attribute which refers
# to the parent cell this block falls under. Note that the inputs are
# "desystematized" and are not in the same format as the `inputs` attribute in
# the flake. This is a key benefit afforded by `std`.
{ inputs
, cell
}:
let
  # The `inputs` attribute allows us to access all of our flake inputs.
  inherit (inputs) nixpkgs std;
  inherit (inputs.nix-cache.packages) nix-serve;

  # This is a common idiom for combining lib with builtins.
  l = nixpkgs.lib // builtins;
in
{
  # We can think of this attribute set as what would normally be contained under
  # `outputs.packages` in our flake.nix. In this case, we're defining a default
  # package which contains a derivation for building our binary.
  default = nixpkgs.runCommand "serveit"  { 
      buildInputs = [nix-serve];
      meta = {
        description = "This will be our caching server";
      };

    } ''
      ${nix-serve}/bin/nix-serve --port 8080
    '';
}

