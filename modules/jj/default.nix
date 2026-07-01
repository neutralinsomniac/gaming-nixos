{
  pkgs,
  # inputs,
  pkgsUnstable,
  ...
}:
let
  # jjPkg = pkgs.jujutsu;
  jjPkg = pkgsUnstable.jujutsu;
  # jjPkg = inputs.jujutsu.packages."${pkgs.stdenv.hostPlatform.system}".default;

  xdgDir = pkgs.linkFarm "jj-config" [
    {
      name = "jj/config.toml";
      path = ./config.toml;
    }
  ];

  jjWrapped = pkgs.symlinkJoin {
    name = "jj";
    paths = [ jjPkg ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/jj \
      --set JJ_CONFIG "${xdgDir}/jj/"
    '';
  };
in
{
  config = {
    environment.systemPackages = [ jjWrapped ];
  };
}
