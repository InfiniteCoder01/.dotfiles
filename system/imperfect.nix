{ config, lib, ... }:
{
  options.imperfect-source.enable = lib.mkOption {
    default = true;
    description = ''
      Whether to enable /nix/source for "imperfect" packages.
      WARNING: This is not only a security risk, but also completely destroys reproducibility.
      NOTE: You MUST create the directory manually.
    '';
  };

  options.imperfect-source.path = lib.mkOption {
    default = "/nix/source";
    description = ''
      Path to store mutable source code of imperfect packages in. MUST be created manually.
    '';
  };

  options.imperfect = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    description = ''
      imperfect.nix functions
    '';
  };

  # Impl
  config = lib.mkMerge [{
    imperfect = lib.makeExtensible (final: {
      hashPath = path: filter: let
        # Recursive helper
        process = path: type:
            if filter path type then
              if type == "regular" then builtins.hashFile "sha256" path
              else if type == "directory" then
                let hashes = lib.mapAttrsToList (name: process "${path}/${name}") (builtins.readDir path);
                in builtins.concatStringsSep "" hashes
              else if type == "symlink" then builtins.hashString "sha256" (builtins.readFile path)
              else ""
            else "";
      in process path (builtins.readFileType path);

      _expose = package: oldAttrs: {
        filter ? lib.sources.cleanSourceFilter,
        name ? package.name,
        path ? "${config.imperfect-source.path}/${name}",
        configureOnce ? false,
      }: let
        preStage = ["imperfectHook"] ++ oldAttrs.prePhases or [];
        fetchStage = ["unpackPhase" "fixStructurePhase" "patchPhase"];
        configureStage = oldAttrs.preConfigurePhases or [] ++ ["configurePhase"];
        buildStage = oldAttrs.preBuildPhases or [] ++ ["buildPhase" "checkPhase"] ++
                     oldAttrs.preInstallPhases or [] ++ ["installPhase"] ++
                     oldAttrs.preFixupPhases or [] ++ ["fixupPhase" "installCheckPhase"] ++
                     oldAttrs.preDistPhases or [] ++ ["distPhase"] ++
                     oldAttrs.postPhases or [];
      in {
        NIX_ENFORCE_PURITY = false;
        __structuredAttrs = true; # Fixes "error: executing '/nix/store/*/bash': Argument list too long"

        imperfectPath = path;
        phases = preStage ++ (if !builtins.pathExists path then fetchStage else []) ++
                 (if builtins.pathExists path != configureOnce then configureStage else []) ++ buildStage;
        hash = if builtins.pathExists path then final.hashPath path filter
               else builtins.currentTime;
        imperfectHook = ''
          mkdir -p "$imperfectPath"
          cd "$imperfectPath"
          [ -e .nix-path ] && cd "$(cat .nix-path)" || :
        '';
        fixStructurePhase = ''
          _imperfectList="$(ls -A "$imperfectPath")"
          if [ "$(echo "$_imperfectList" | wc -l)" -eq 1 ] && [ -d "$imperfectPath/$_imperfectList" ]; then
            _imperfectWorkdir="$(pwd)"
            _imperfectWorkdir="''${_imperfectWorkdir/"$_imperfectList/"/}"
            cd "$imperfectPath"
            mv "$_imperfectList" "__inner"
            mv __inner/* .
            rm -r __inner/
            cd "$_imperfectWorkdir"
            unset _imperfectWorkdir
          fi
          unset _imperfectList
          [ "$(pwd)" = "$imperfectPath" ] || pwd > "$imperfectPath/.nix-path"
        '';
      };

      expose = package: attrs: package.overrideAttrs (oldAttrs: (final._expose package oldAttrs (if builtins.isFunction attrs then attrs oldAttrs else attrs)));
    });
  } (lib.mkIf config.imperfect-source.enable {
      nix.settings.extra-sandbox-paths = [ config.imperfect-source.path ];
      systemd.tmpfiles.rules = [
        "d ${config.imperfect-source.path} 0775 root nixbld -"
      ];
  })];
}
