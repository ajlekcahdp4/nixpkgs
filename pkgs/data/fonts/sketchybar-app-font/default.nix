{ lib
, stdenvNoCC
, fetchurl
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sketchybar-app-font";
  version = "2.0.4";

  src = fetchurl {
    url = "https://github.com/kvndrsslr/sketchybar-app-font/releases/download/v${finalAttrs.version}/sketchybar-app-font.ttf";
    hash = "sha256-G3ceScZQT1rrjw+V9ALRo78lSVYsLymQLFfzSo/gA8U=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/fonts/truetype/sketchybar-app-font.ttf

    runHook postInstall
  '';

  meta = {
    description = "A ligature-based symbol font and a mapping function for sketchybar";
    longDescription = ''
      A ligature-based symbol font and a mapping function for sketchybar, inspired by simple-bar's usage of community-contributed minimalistic app icons.
    '';
    homepage = "https://github.com/kvndrsslr/sketchybar-app-font";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
})
