{
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "sbctl";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = "sbctl";
    rev = version;
    hash = "sha256-mntb3EMB+QTnFU476Dq6T6rAAv0JeYbvWJ/pbL3a4RE=";
  };

  vendorSha256 = "sha256-k6AIYigjxbitH0hH+vwRt2urhNYTToIF0eSsIWbzslI=";

  postPatch = ''
    substituteInPlace keys.go --replace "/usr/share/secureboot" "/etc/secureboot"
  '';
}
