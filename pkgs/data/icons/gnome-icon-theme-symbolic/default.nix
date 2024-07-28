{ stdenv, inkscape, iconnamingutils, pkg-config, lib, fetchurl, gtk3 }:
stdenv.mkDerivation rec {
  pname = "gnome-icon-theme-symbolic";
  version = "3.12.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-icon-theme-symbolic/${lib.versions.major version}.${lib.versions.minor version}/${pname}-${version}.tar.xz";
    hash = "sha256-hRpMnY6MsAAMnl54JZq4uOZ8UzTkJQ68yN/aozUgBos=";
  };

  # A hack to patch out the gtk-update-icon-cache, which fails due to the icon pack not having a theme index.
  env.GTK_UPDATE_ICON_CACHE = "${gtk3}/bin/gtk-update-icon-cache --ignore-theme-index";

  nativeBuildInputs = [
    inkscape # For manipulating SVGs
    iconnamingutils # For naming the resulting icons
    pkg-config # REquired for package discovery
    gtk3 # Needed for updating the icon cache
  ];

  dontDropIconThemeCache = true;

  meta = with lib; {
    description = [ "A collection of icons for the GNOME 2 desktop." ];
    homepage = "https://gitlab.gnome.org/Archive/gnome-icon-theme-symbolic";
    platforms = with platforms; linux ++ darwin;
    maintainers = teams.gnome.members;
    license = licenses.cc-by-sa-30;
  };
}
