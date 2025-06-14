{ lib, stdenv, fetchurl, p7zip }:
let
  # https://swscan.apple.com/content/catalogs/others/index-rosettaupdateauto-1.sucatalog.gz

  # Sequoia 15.5
  version = "24F74";
  src = fetchurl {
    url = "https://swcdn.apple.com/content/downloads/34/05/082-44576-A_XFN7Y7QSUP/199d74a1yz7r7jzqhtgswkg8q10zpddsys/RosettaUpdateAuto.pkg";
    hash = "sha256-nl0SzY8zpbGIv0zLP6syDHM3V52YqQyVM+JrMXgNu00=";
  };

  drv = stdenv.mkDerivation {
    pname = "rosetta";
    inherit version src;

    nativeBuildInputs = [ p7zip ];

    unpackPhase = ''
      runHook preUnpack

      7z x $src
      7z x Payload\~

      runHook postUnpack
    '';

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp Library/Apple/usr/libexec/oah/RosettaLinux/* $out/bin
      chmod +x $out/bin/*

      runHook postInstall
    '';

    dontFixup = true;
  };
in drv
