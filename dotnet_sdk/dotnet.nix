{ pkgs, nix2container, ... }:
{
  dependabot-dotnet-sdk = nix2container.buildImage {
    name = "dependabot-dotnet-sdk";
    tag = "latest";
    layers = [
      (nix2container.buildLayer {
        deps = [ pkgs.bashInteractive ];
        copyToRoot = pkgs.buildEnv {
          name = "root";
          paths = [ pkgs.bashInteractive ];
          pathsToLink = [ "/bin" ];
        };
        layers = [
          (nix2container.buildLayer {
            deps = [ pkgs.dotnet-sdk_11 ];
          })
        ];
      })
    ];
    config = {
      Env = [
        (let path = with pkgs; lib.makeBinPath [ dotnet-sdk_11 ];
        in "PATH=${path}:$PATH")
      ];
      Cmd = [ "dotnet" "--version" ];
    };
  };
}