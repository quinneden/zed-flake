{
  lib,
  makeWrapper,
  marksman,
  nixd,
  nixfmt-rfc-style,
  python3,
  superhtml,
  symlinkJoin,
  zed-editor,
  ...
}:
let
  extraPackages =
    let
      pythonEnv = python3.withPackages (
        ps: with ps; [
          beautifulsoup4
          boto3
          ipykernel
          ipython
          pip
          pylsp-rope
          python-lsp-server
          pyyaml
          requests
          rope
          venvShellHook
          yapf
        ]
      );
    in
    [
      marksman
      nixd
      nixfmt-rfc-style
      pythonEnv
      pythonEnv
      superhtml
    ];
in
symlinkJoin {
  name = "${lib.getName zed-editor}-wrapped-${lib.getVersion zed-editor}";
  paths = [ zed-editor ];
  preferLocalBuild = true;
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/zeditor \
      --suffix PATH : ${lib.makeBinPath extraPackages}

    ln -s $out/bin/zeditor $out/bin/zed
  '';
}
