{ lib, stdenv, fetchurl, p7zip }:
let
  # https://swscan.apple.com/content/catalogs/others/index-rosettaupdateauto-1.sucatalog.gz

  # Sequoia 15.2
  version = "24C101";
  src = fetchurl {
    url = "https://swcdn.apple.com/content/downloads/56/11/072-44352-A_TZG2YTBMAZ/hnqfqmuuulu2yf3n226fqu7phar2jpago2/RosettaUpdateAuto.pkg";
    hash = "sha256-fP/4HbPkMUz1LQrK1bJ0aEp+U1q7GYiCzY6/b5OptoY=";
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
