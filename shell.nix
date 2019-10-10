with import <nixpkgs> {};

runCommand "dummy" {
	buildInputs = [
		dune
		ocamlPackages_latest.ocaml
		ocamlPackages.odoc
	];
} ""
