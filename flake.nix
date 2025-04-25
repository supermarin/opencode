{
  outputs =
    { nixpkgs, ... }:
    let
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system: function nixpkgs.legacyPackages.${system}
        );
    in
    {
      packages = forAllSystems (pkgs: {
        default = pkgs.buildGoModule {
          name = "opencode";
          src = pkgs.lib.cleanSource ./.;
          vendorHash = "sha256-GyhboaFQ+tfZiEkgQyHFWz8PlnGzbZBUD8ccsg4rzdA=";
          doCheck = false;
        };
      });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            go
            gopls
          ];
        };
      });
    };
}
