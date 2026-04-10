{
  description = "ROS integration for Franka research robots";

  inputs = {
    gepetto.url = "github:gepetto/nix";
    flake-parts.follows = "gepetto/flake-parts";
    systems.follows = "gepetto/systems";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      {
        systems = import inputs.systems;
        imports = [
          inputs.gepetto.flakeModule
          {
            flakoboros = {
              rosDistros = [ "humble" ]; # TODO
              rosShellDistro = "humble"; # TODO
              rosOverrideAttrs.franka-description = _: _: {
                src = lib.fileset.toSource {
                  root = ./.;
                  fileset = lib.fileset.unions [
                    ./CMakeLists.txt
                    ./end_effectors
                    ./env-hooks
                    ./launch
                    ./meshes
                    ./package.xml
                    ./robots
                    ./rviz
                    ./scripts
                    ./test
                    ./worlds
                  ];
                };
              };
            };
          }
        ];
      }
    );
}
