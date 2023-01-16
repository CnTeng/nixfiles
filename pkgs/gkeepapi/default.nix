{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "gkeepapi";
  version = "0.14.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CP3V73yWSA00HBLUct4hrNMjWZlvaaUlkpm1QP66RWA=";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/kiwiz/gkeepapi";
    description = "An unofficial client for the Google Keep API.";
    license = licenses.mitl;
    maintainers = with maintainers; [ CnTeng ];
  };
}
