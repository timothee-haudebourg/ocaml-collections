with import <nixpkgs> {};

runCommand "dummy" {
	buildInputs = [
		ocamlPackages_latest.ocaml
		ocamlPackages_latest.odoc
	];
} ""
