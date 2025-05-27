{ writeShellApplication, openconnect, fetchFromGitLab }:

let updatedOpenconnect = openconnect.overrideAttrs {
  version = "9.12+";
  src = fetchFromGitLab {
    owner = "openconnect";
    repo  = "openconnect";
    rev = "f17fe20d337b400b476a73326de642a9f63b59c8"; # head 1/21/25
    hash = "sha256-OBEojqOf7cmGtDa9ToPaJUHrmBhq19/CyZ5agbP7WUw=";
  };
  patches = [ ./ipv4-bind.patch ];
}; in writeShellApplication {
  name = "vpn-up";
  runtimeInputs = [ updatedOpenconnect ];
  text = ''
    browser="$(command -v xdg-open || command -v open)"
    COOKIE=
    sudo -v
    # Sets $COOKIE, $FINGERPRINT, $CONNECT_URL and optionally $RESOLVE
    eval "$(${updatedOpenconnect}/bin/openconnect  \
            "$@" \
            --authenticate \
            --external-browser "$browser" \
            --useragent "AnyConnect*")"

    if [ -z "$COOKIE" ]; then
        echo "OpenConnect didn't set the expected variables!" 1>&2
        exit 1
    fi

    sudo ${updatedOpenconnect}/bin/openconnect  \
        --servercert "$FINGERPRINT" \
        "$CONNECT_URL" \
        --useragent "AnyConnect*" \
        --cookie-on-stdin \
        ''${RESOLVE:+--resolve "$RESOLVE"} <<< "$COOKIE"
  '';
}
