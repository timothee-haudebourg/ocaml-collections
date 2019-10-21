with import <nixpkgs> {};

runCommand "dummy" {
	buildInputs = [
		ocamlPackages_latest.ocaml
		ocamlPackages.odoc
	];
} ""
