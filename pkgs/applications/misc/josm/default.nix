{ fetchurl, stdenv, makeDesktopItem, makeWrapper, unzip, jdk11, libXxf86vm }:

stdenv.mkDerivation rec {
  pname = "josm";
  version = "15628";

  src = fetchurl {
    url = "https://josm.openstreetmap.de/download/josm-snapshot-${version}.jar";
    sha256 = "19yn311h9x1434832i0awpv2n9vhbhkk1j1mi9zggy9f256f80c6";
  };

  buildInputs = [ jdk11 makeWrapper ];

  desktopItem = makeDesktopItem {
    name = "josm";
    exec = "josm";
    icon = "josm";
    desktopName = "JOSM";
    genericName = "OpenStreetMap Editor";
    comment = meta.description;
    categories = "Education;Geoscience;Maps;";
  };

  # Add libXxf86vm to path because it is needed by at least Kendzi3D plugin
  buildCommand = ''
    mkdir -p $out/bin $out/share/java
    cp -v $src $out/share/java/josm.jar

    makeWrapper ${jdk11}/bin/java $out/bin/josm \
      --add-flags "-jar $out/share/java/josm.jar" \
      --prefix LD_LIBRARY_PATH ":" '${libXxf86vm}/lib'

    mkdir -p $out/share/applications
    cp $desktopItem/share/applications"/"* $out/share/applications
    mkdir -p $out/share/pixmaps
    ${unzip}/bin/unzip -p $src images/logo_48x48x32.png > $out/share/pixmaps/josm.png
  '';

  meta = with stdenv.lib; {
    description = "An extensible editor for OpenStreetMap";
    homepage = https://josm.openstreetmap.de/;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
  };
}
